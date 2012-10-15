SystemOrganization addCategory: #'DynamicAspects-Tests'!
SystemOrganization addCategory: #'DynamicAspects-Joinpoints'!
SystemOrganization addCategory: #'DynamicAspects-Kernel'!
SystemOrganization addCategory: #'DynamicAspects-Pointcuts'!
SystemOrganization addCategory: #'DynamicAspects-Aspects'!
SystemOrganization addCategory: #'DynamicAspects-Test'!

!Browser methodsFor: '*DynamicAspects' stamp: 'as 7/23/2007 17:33'!
defineClass: defString notifying: aController  
	"The receiver's textual content is a request to define a new class. The
	source code is defString. If any errors occur in compilation, notify
	aController."
	| oldClass class newClassName defTokens keywdIx envt |
	oldClass _ self selectedClassOrMetaClass.
	defTokens _ defString findTokens: Character separators.
	
	((defTokens first = 'Trait' and: [defTokens second = 'named:'])
		or: [defTokens second = 'classTrait'])
		ifTrue: [^self defineTrait: defString notifying: aController].
		
	keywdIx _ defTokens findFirst: [:x | x beginsWith: 'category'].
	envt _ Smalltalk.
	keywdIx _ defTokens findFirst: [:x | '*subclass*' match: x].
	
	"The next line is a fix for DynamicAspects, which do not contain the word 'subclass',
	 but 'subaspect' instead."
	keywdIx = 0 ifTrue: [ keywdIx _ defTokens findFirst: [ :x | '*subaspect*' match: x. ]. ].
	
	newClassName _ (defTokens at: keywdIx+1) copyWithoutAll: '#()'.
	((oldClass isNil or: [oldClass theNonMetaClass name asString ~= newClassName])
		and: [envt includesKey: newClassName asSymbol]) ifTrue:
			["Attempting to define new class over existing one when
				not looking at the original one in this browser..."
			(self confirm: ((newClassName , ' is an existing class in this system.
Redefining it might cause serious problems.
Is this really what you want to do?') asText makeBoldFrom: 1 to: newClassName size))
				ifFalse: [^ false]].
	"ar 8/29/1999: Use oldClass superclass for defining oldClass
	since oldClass superclass knows the definerClass of oldClass."
	oldClass ifNotNil:[oldClass _ oldClass superclass].
	class _ oldClass subclassDefinerClass
				evaluate: defString
				notifying: aController
				logged: true.
	(class isKindOf: Behavior)
		ifTrue: [self changed: #systemCategoryList.
				self changed: #classList.
				self clearUserEditFlag.
				self setClass: class selector: nil.
				"self clearUserEditFlag; editClass."
				^ true]
		ifFalse: [^ false]! !

Object subclass: #DAAspectClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

DAAspectClass class
	instanceVariableNames: 'Advices Pointcuts Links'!

DAAspectClass class
	instanceVariableNames: 'Advices Pointcuts Links'!

DAAspectClass subclass: #DAAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

DAAspect class
	instanceVariableNames: 'Instance'!

DAAspect class
	instanceVariableNames: 'Instance'!

!DAAspect class methodsFor: 'accessing' stamp: 'as 7/23/2007 14:43'!
adviceNames

	^ self superclass adviceNames addAll: (self advices); yourself.! !

!DAAspect class methodsFor: 'printing' stamp: 'as 7/23/2007 11:49'!
advicesString

	^ String streamContents: [
		:stream |
		self advices do: [
			:each |
			stream nextPutAll: each asString.
		] separatedBy: [ stream space. ].
	].! !

!DAAspect class methodsFor: 'fileIn/Out' stamp: 'as 7/18/2007 15:47'!
definitionST80

	| aStream |
	aStream _ WriteStream on: (String new: 300).
	aStream nextPutAll: superclass name.
	aStream nextPutAll: ' subaspect: ';
			store: self name.
	(self hasTraitComposition and: [self traitComposition notEmpty]) ifTrue: [
		aStream cr; tab; nextPutAll: 'uses: ';
			nextPutAll: self traitCompositionString].
	aStream cr; tab; nextPutAll: 'pointcutNames: ';
			store: self pointcutsString.
	aStream cr; tab; nextPutAll: 'adviceNames: ';
			store: self advicesString.
	aStream cr; tab; nextPutAll: 'linkNames: ';
			store: self linksString.
	aStream cr; tab; nextPutAll: 'variableNames: ';
			store: self instanceVariablesString.
	aStream cr; tab; nextPutAll: 'category: ';
			store: (SystemOrganization categoryOfElement: self name) asString.

	superclass ifNil: [ 
		aStream nextPutAll: '.'; cr.
		aStream nextPutAll: self name.
		aStream space; nextPutAll: 'superclass: nil'. ].

	^ aStream contents! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 7/3/2007 11:38'!
instance

	^ Instance ifNil: [ Instance _ self basicNew initialize. ].! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 7/23/2007 14:43'!
linkNames

	^ self superclass linkNames addAll: (self links); yourself.! !

!DAAspect class methodsFor: 'printing' stamp: 'as 7/23/2007 11:50'!
linksString

	^ String streamContents: [
		:stream |
		self links do: [
			:each |
			stream nextPutAll: each asString.
		] separatedBy: [ stream space. ].
	].! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 7/2/2007 10:14'!
new

	self error: 'I am singleton, use ', self class name, '>>instance'.! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 7/23/2007 14:43'!
pointcutNames

	^ self superclass pointcutNames addAll: (self pointcuts); yourself.! !

!DAAspect class methodsFor: 'printing' stamp: 'as 7/23/2007 11:50'!
pointcutsString

	^ String streamContents: [
		:stream |
		self pointcuts do: [
			:each |
			stream nextPutAll: each asString.
		] separatedBy: [ stream space. ].
	].! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 7/18/2007 15:03'!
template: categorySymbol

	^ self templateForSubclassOf: DAAspect name category: categorySymbol. ! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 7/18/2007 15:04'!
templateForSubclassOf: aClass category: aSymbol

	^ aClass asString, 'subaspect: #NameOfSubaspect
	pointcutNames: ''''
	adviceNames: ''''
	linkNames: ''''
	variableNames: ''''
	category: ''' , aSymbol asString , ''''.! !

!DAAspect methodsFor: 'advices' stamp: 'as 7/4/2007 15:34'!
advice: aSymbol

	| advice |
	advice _ nil.
	(self class isProvidedSelector: aSymbol) ifTrue: [
		advice _ aSymbol.
	].
	^ advice.! !

!DAAspect methodsFor: 'advices' stamp: 'as 7/23/2007 11:47'!
adviceNames

	^ self class adviceNames.! !

!DAAspect methodsFor: 'advices' stamp: 'as 7/4/2007 15:43'!
advices

	^ self adviceNames collect: [
		:name |
		self advice: name.
	] thenSelect: [
		:advice |
		advice notNil.
	].! !

!DAAspect methodsFor: 'installing' stamp: 'as 7/4/2007 15:26'!
install

	self links do: [
		:link |
		| pointcut advice gplink |
		pointcut _ self pointcut: link key.
		advice _ self advice: link value.
		gplink _ GPLink new metaObject: [ self perform: advice. ].
		pointcut nodes do: [ :node | node link: gplink. ].
	].! !

!DAAspect methodsFor: 'linking' stamp: 'as 7/4/2007 15:34'!
link: aSymbol

	| link |
	link _ nil.
	(self class isProvidedSelector: aSymbol) ifTrue: [
		link _ self perform: aSymbol.
		(link isKindOf: Association) ifFalse: [ link _ nil. ].
	].
	^ link.! !

!DAAspect methodsFor: 'linking' stamp: 'as 7/23/2007 11:47'!
linkNames

	^ self class linkNames.! !

!DAAspect methodsFor: 'linking' stamp: 'as 7/4/2007 15:42'!
links

	^ self linkNames collect: [
		:name |
		self link: name.
	] thenSelect: [
		:link |
		link notNil.
	].! !

!DAAspect methodsFor: 'pointcuts' stamp: 'as 7/4/2007 15:34'!
pointcut: aSymbol

	| pointcut |
	pointcut _ nil.
	(self class isProvidedSelector: aSymbol) ifTrue: [
		pointcut _ self perform: aSymbol.
		(pointcut isKindOf: DAPointcut) ifFalse: [ pointcut _ nil. ].
	].
	^ pointcut.! !

!DAAspect methodsFor: 'pointcuts' stamp: 'as 7/23/2007 11:47'!
pointcutNames

	^ self class pointcutNames.! !

!DAAspect methodsFor: 'pointcuts' stamp: 'as 7/4/2007 15:43'!
pointcuts

	^ self pointcutNames collect: [
		:name |
		self pointcut: name.
	] thenSelect: [
		:pointcut |
		pointcut notNil.
	].! !

!DAAspect methodsFor: 'installing' stamp: 'as 7/4/2007 16:26'!
uninstall

	self links do: [
		:link |
		| pointcut |
		pointcut _ self pointcut: link key.
		pointcut nodes do: [ :node | node removeAllLinks. ].
	].! !

DAAspect subclass: #DAExampleAspect
	instanceVariableNames: 'count'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DAExampleAspect methodsFor: 'advices' stamp: 'as 7/4/2007 15:24'!
a1

	count _ count + 1.! !

!DAExampleAspect methodsFor: 'accessing' stamp: 'as 7/4/2007 16:10'!
count

	^ count.! !

!DAExampleAspect methodsFor: 'initialize-release' stamp: 'as 7/4/2007 15:24'!
initialize

	count _ 0.! !

!DAExampleAspect methodsFor: 'linking' stamp: 'as 7/4/2007 13:33'!
l1

	^ #p1 -> #a1.! !

!DAExampleAspect methodsFor: 'pointcuts' stamp: 'as 7/4/2007 15:17'!
p1

	^ DAMethodExecutionPointcut onClass: DAExamples method: #example.! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 7/18/2007 20:57'!
advices

	^ Advices ifNil: [ Advices _ Set new. ].! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 7/18/2007 17:25'!
advices: aString

	Advices _ self stringToSymbols: aString.! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 7/18/2007 20:57'!
links

	^ Links ifNil: [ Links _ Set new. ].! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 7/18/2007 17:26'!
links: aString

	Links _ self stringToSymbols: aString.! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 7/23/2007 15:00'!
pointcuts

	^ Pointcuts ifNil: [ Pointcuts _ Set new. ].! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 7/18/2007 17:26'!
pointcuts: aString

	Pointcuts _ self stringToSymbols: aString.! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 7/23/2007 15:01'!
stringToSymbols: aString

	| set |
	set _ Set new.
	(aString subStrings: ' ') do: [
		:substring |
		set add: substring asSymbol.
	].
	^ set.! !

!DAAspectClass class methodsFor: 'subaspect creation' stamp: 'as 7/23/2007 11:13'!
subaspect: class pointcutNames: pointcuts adviceNames: advices linkNames: links instanceVariableNames: instVars classVariableNames: classVars poolDictionaries: pools category: cat

	| newClass |
	newClass _ self subclass: class
		instanceVariableNames: instVars
		classVariableNames: classVars
		poolDictionaries: pools
		category: cat.
	newClass
		pointcuts: pointcuts;
		advices: advices;
		links: links.
	^ newClass.! !

!DAAspectClass class methodsFor: 'subaspect creation' stamp: 'as 7/18/2007 17:04'!
subaspect: class pointcutNames: pointcuts adviceNames: advices linkNames: links variableNames: variables category: cat

	^ self
		subaspect: class
		pointcutNames: pointcuts
		adviceNames: advices
		linkNames: links
		instanceVariableNames: variables
		classVariableNames: ''
		poolDictionaries: ''
		category: cat.! !

Object subclass: #DAExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DAExamples methodsFor: 'examples' stamp: 'as 7/4/2007 17:48'!
example

	^ self.! !

Object subclass: #DAJoinpoint
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

DAJoinpoint subclass: #DAMethodExecutionJoinpoint
	instanceVariableNames: 'class method'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Joinpoints'!

!DAMethodExecutionJoinpoint class methodsFor: 'instance creation' stamp: 'as 7/17/2007 17:31'!
onClass: aClass method: aSymbol

	^ self new
		class: aClass;
		method: aSymbol;
		yourself.! !

!DAMethodExecutionJoinpoint methodsFor: 'accessing' stamp: 'as 7/17/2007 17:32'!
class: aClass

	class _ aClass.! !

!DAMethodExecutionJoinpoint methodsFor: 'accessing' stamp: 'as 7/17/2007 17:32'!
method: aSymbol

	method _ aSymbol.! !

!DAMethodExecutionJoinpoint methodsFor: 'joinpoint' stamp: 'as 7/17/2007 17:37'!
node

	^ (class >> method) methodNode.! !

Object subclass: #DAPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

DAPointcut subclass: #DACompositePointcut
	instanceVariableNames: 'children'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

DAPointcut subclass: #DAMethodExecutionPointcut
	instanceVariableNames: 'method'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAMethodExecutionPointcut class methodsFor: 'instance creation' stamp: 'as 6/27/2007 17:58'!
on: aCompiledMethod

	^ self new
		method: aCompiledMethod;
		yourself.! !

!DAMethodExecutionPointcut class methodsFor: 'instance creation' stamp: 'as 6/27/2007 18:00'!
onClass: aClass method: aSymbol

	^ self on: aClass >> aSymbol.! !

!DAMethodExecutionPointcut methodsFor: 'accessing' stamp: 'as 6/27/2007 18:00'!
method: aCompiledMethod

	method _ aCompiledMethod.! !

!DAMethodExecutionPointcut methodsFor: 'evaluation' stamp: 'as 6/27/2007 18:34'!
nodes

	^ Set new
		add: method methodNode;
		yourself.! !

!DAPointcut methodsFor: 'evaluation' stamp: 'as 6/27/2007 15:55'!
nodes

	self subclassResponsibility.! !

TestCase subclass: #DAAspectTest
	instanceVariableNames: 'example aspect'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DAAspectTest methodsFor: 'running' stamp: 'as 7/18/2007 10:37'!
removeAllLinksOn: aClass

	aClass methodDict values do: [
		:method |
		method reflectiveMethod methodNode nodesDo: [
			:node |
			node hasAnyLink ifTrue: [ node removeAllLinks. ].
			self assert: node hasAnyLink not.
		].
	].! !

!DAAspectTest methodsFor: 'running' stamp: 'as 7/18/2007 10:34'!
setUp

	super initialize.
	example _ DAExamples new.
	aspect _ DAExampleAspect instance.
	self removeAllLinksOn: DAExamples.! !

!DAAspectTest methodsFor: 'running' stamp: 'as 7/18/2007 10:34'!
tearDown

	self removeAllLinksOn: DAExamples.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 7/4/2007 17:50'!
testAspect

	| count |
	count _ aspect count.
	self shouldnt: [ aspect install. ] raise: Exception.
	example example.
	self assert: (count + 1 = aspect count).
	self shouldnt: [ aspect uninstall. ] raise: Exception.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 7/4/2007 17:49'!
testNormal

	| count |
	count _ aspect count.
	example example.
	self assert: count = aspect count.! !
