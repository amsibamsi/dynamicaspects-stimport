SystemOrganization addCategory: #'DynamicAspects-Kernel'!
SystemOrganization addCategory: #'DynamicAspects-Pointcuts'!
SystemOrganization addCategory: #'DynamicAspects-Tests'!

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

Object subclass: #DAAdviceWrapper
	instanceVariableNames: 'metaObject selector reifications context'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DAAdviceWrapper class methodsFor: 'instance creation' stamp: 'as 10/2/2007 13:19'!
metaObject: anObject selector: aSymbol reifications: aCollection

	self new
		metaObject: anObject;
		selector: aSymbol;
		reifications: aCollection;
		yourself.! !

!DAAdviceWrapper methodsFor: 'system primitives' stamp: 'as 10/2/2007 14:48'!
advice: aMessage

	aMessage arguments withIndexDo: [
		:arg :index |
		context at: (reifications at: index) put: arg.
	].
	metaObject perform: selector with: context.! !

!DAAdviceWrapper methodsFor: 'system primitives' stamp: 'as 10/2/2007 16:08'!
doesNotUnderstand: aMessage

	aMessage selector = self selector ifTrue: [
		self advice: aMessage
	] ifFalse: [
		^ super doesNotUnderstand: aMessage.
	].! !

!DAAdviceWrapper methodsFor: 'initialize-release' stamp: 'as 10/2/2007 13:20'!
initialize

	context _ Dictionary new.! !

!DAAdviceWrapper methodsFor: 'accessing' stamp: 'as 10/2/2007 14:47'!
metaObject: anObject selector: aSymbol reifications: aCollection

	metaObject _ anObject.
	selector _ aSymbol.
	reifications _ aCollection.! !

!DAAdviceWrapper methodsFor: 'system primitives' stamp: 'as 10/2/2007 16:08'!
selector

	| name sel |
	name _ 'with:'.
	sel _ name.
	context keys size timesRepeat: [ sel _ sel, name. ].
	^ sel asSymbol.! !

Object subclass: #DAAspectClass
	instanceVariableNames: 'links'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

DAAspectClass class
	instanceVariableNames: 'AdviceNames PointcutNames LinkNames'!

!DAAspectClass commentStamp: 'as 8/14/2007 10:04' prior: 0!
This makes the transition from an object to an aspect.!

DAAspectClass class
	instanceVariableNames: 'AdviceNames PointcutNames LinkNames'!

DAAspectClass subclass: #DAAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

DAAspect class
	instanceVariableNames: 'Instance'!

!DAAspect commentStamp: 'as 9/26/2007 14:44' prior: 0!
An aspect is in AOP (Aspect-Oriented Progamming) what and object is in OOP (Object-Oriented Programming). Instead of trying to break down a program into different objects and their corresponding classes, in AOP the entities of modularization are aspects.
An aspect usually covers a cross-cutting concern in OOP that can be implemented much easier with AOP.

Although aspects are not necessarily objects or classes, in this implementation they are implemented as singleton classes in the traditional OOP way to get a good integration with the existing system.!

DAAspect class
	instanceVariableNames: 'Instance'!

!DAAspect class methodsFor: 'printing' stamp: 'as 9/10/2007 17:14'!
advicesString

	^ String streamContents: [
		:stream |
		self adviceNames do: [
			:each |
			stream nextPutAll: each asString.
		] separatedBy: [ stream space. ].
	].! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 9/10/2007 17:12'!
allAdviceNames

	^ self superclass adviceNames addAll: self adviceNames; yourself.! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 9/10/2007 17:13'!
allLinkNames

	^ self superclass linkNames addAll: self linkNames; yourself.! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 9/10/2007 17:13'!
allPointcutNames

	^ self superclass pointcutNames addAll: self pointcutNames; yourself.! !

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

!DAAspect class methodsFor: 'printing' stamp: 'as 9/10/2007 17:14'!
linksString

	^ String streamContents: [
		:stream |
		self linkNames do: [
			:each |
			stream nextPutAll: each asString.
		] separatedBy: [ stream space. ].
	].! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 8/14/2007 09:43'!
new

	self error: 'I''m singleton, use ', self class name, '>>instance'.! !

!DAAspect class methodsFor: 'printing' stamp: 'as 9/10/2007 17:14'!
pointcutsString

	^ String streamContents: [
		:stream |
		self pointcutNames do: [
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

!DAAspect methodsFor: 'advices' stamp: 'as 9/26/2007 15:01'!
advices

	^ self allAdvices.! !

!DAAspect methodsFor: 'accessing' stamp: 'as 9/10/2007 17:16'!
allAdviceNames

	^ self class allAdviceNames.! !

!DAAspect methodsFor: 'accessing' stamp: 'as 9/10/2007 17:16'!
allLinkNames

	^ self class allLinkNames.! !

!DAAspect methodsFor: 'accessing' stamp: 'as 9/10/2007 17:16'!
allPointcutNames

	^ self class allPointcutNames.! !

!DAAspect methodsFor: 'initialize-release' stamp: 'as 10/2/2007 15:08'!
initialize

	links _ Set new.! !

!DAAspect methodsFor: 'installing' stamp: 'as 10/2/2007 16:09'!
install

	self links do: [
		:link |
		| pointcut visitor advice gplink |
		pointcut _ self pointcut: (link at: #pointcut).
		visitor _ DANodeCollector new.
		visitor visit: pointcut.
		gplink _ GPLink new.
		gplink arguments: (visitor reifications addAll: (link at: #reifications ifAbsent: {})).
		gplink control: visitor control.
		visitor condition isBlock ifTrue: [ gplink condition: visitor condition. ].
		advice _ DAAdviceWrapper metaObject: self selector: (link at: #advice) reifications: gplink arguments.
		gplink metaObject: advice; selector: advice selector.
		visitor nodes do: [
			:node |
			node link: gplink.
		].
		links add: gplink.
	].! !

!DAAspect methodsFor: 'linking' stamp: 'as 9/26/2007 15:06'!
link: aSymbol

	^ self perform: aSymbol.! !

!DAAspect methodsFor: 'linking' stamp: 'as 9/26/2007 15:07'!
links

	^ self allLinks collect: [
		:name |
		self link: name.
	].! !

!DAAspect methodsFor: 'pointcuts' stamp: 'as 9/26/2007 15:09'!
pointcut: aSymbol

	^ self perform: (aSymbol, #:) asSymbol with: DAPointcutBuilder.! !

!DAAspect methodsFor: 'pointcuts' stamp: 'as 9/26/2007 15:05'!
pointcuts

	^ self allPointcuts collect: [
		:name |
		self pointcut: name.
	].! !

!DAAspect methodsFor: 'installing' stamp: 'as 9/26/2007 15:07'!
uninstall

	"broken"
	
	"self links do: [
		:link |
		| pointcut |
		pointcut _ self pointcut: link key.
		pointcut nodes do: [ :node | node removeAllLinks. ].
	]."! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 9/10/2007 17:05'!
adviceNames

	^ AdviceNames ifNil: [ AdviceNames _ Set new. ].! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 9/10/2007 17:10'!
adviceNames: aString

	AdviceNames _ self stringToSymbols: aString.! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 9/10/2007 17:11'!
linkNames

	^ LinkNames ifNil: [ LinkNames _ Set new. ].! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 9/10/2007 17:11'!
linkNames: aString

	LinkNames _ self stringToSymbols: aString.! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 9/10/2007 17:11'!
pointcutNames

	^ PointcutNames ifNil: [ PointcutNames _ Set new. ].! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 9/10/2007 17:11'!
pointcutNames: aString

	PointcutNames _ self stringToSymbols: aString.! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 7/23/2007 15:01'!
stringToSymbols: aString

	| set |
	set _ Set new.
	(aString subStrings: ' ') do: [
		:substring |
		set add: substring asSymbol.
	].
	^ set.! !

!DAAspectClass class methodsFor: 'subaspect creation' stamp: 'as 9/10/2007 17:11'!
subaspect: class pointcutNames: pointcuts adviceNames: advices linkNames: links instanceVariableNames: instVars classVariableNames: classVars poolDictionaries: pools category: cat

	| newClass |
	newClass _ self subclass: class
		instanceVariableNames: instVars
		classVariableNames: classVars
		poolDictionaries: pools
		category: cat.
	newClass
		pointcutNames: pointcuts;
		adviceNames: advices;
		linkNames: links.
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

Object subclass: #DAPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DAPointcut commentStamp: 'as 9/12/2007 15:21' prior: 0!
Pointcuts are used to describe a set of join points. So far, the only type of join points are nodes from in reflective method.!

DAPointcut subclass: #DACompositePointcut
	instanceVariableNames: 'children'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DACompositePointcut commentStamp: 'as 9/18/2007 16:38' prior: 0!
A composition of one or more pointcuts, which can be compositions as well.!

DACompositePointcut subclass: #DAAndCompositePointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAAndCompositePointcut commentStamp: 'as 8/16/2007 15:00' prior: 0!
Logical And of 2 pointcuts.!

!DAAndCompositePointcut methodsFor: 'visiting' stamp: 'as 9/18/2007 17:35'!
visitName

	^ 'and'.! !

!DACompositePointcut class methodsFor: 'instance creation' stamp: 'as 9/18/2007 16:45'!
child: aDAPointcut

	^ self new
		children: {aDAPointcut};
		yourself.! !

!DACompositePointcut class methodsFor: 'instance creation' stamp: 'as 9/18/2007 16:44'!
child: firstDAPointcut child: secondDAPointcut

	^ self new
		children: {firstDAPointcut. secondDAPointcut};
		yourself.! !

!DACompositePointcut class methodsFor: 'instance creation' stamp: 'as 9/18/2007 16:44'!
children: aCollection

	^ self new
		children: aCollection;
		yourself.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 9/18/2007 16:40'!
children: aCollection

	children _ aCollection.! !

DACompositePointcut subclass: #DAOrCompositePointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAOrCompositePointcut commentStamp: 'as 8/16/2007 15:01' prior: 0!
Logical Or of 2 poincuts.!

!DAOrCompositePointcut methodsFor: 'visiting' stamp: 'as 9/18/2007 17:35'!
visitName

	^ 'or'.! !

DACompositePointcut subclass: #DAWithinPointcut
	instanceVariableNames: 'category class'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAWithinPointcut commentStamp: 'as 9/26/2007 15:25' prior: 0!
Specify a location within categories, classes and methods.!

!DAWithinPointcut methodsFor: 'evaluating' stamp: 'as 9/18/2007 15:47'!
categories

	^ self categoriesMatching: category.! !

!DAWithinPointcut methodsFor: 'accessing' stamp: 'as 9/18/2007 15:45'!
category

	^ category ifNil: [ category _ '*'. ].! !

!DAWithinPointcut methodsFor: 'accessing' stamp: 'as 9/18/2007 15:44'!
category: aString

	category _ aString.! !

!DAWithinPointcut methodsFor: 'accessing' stamp: 'as 9/18/2007 15:46'!
class

	^ class ifNil: [ class _ '*'. ].! !

!DAWithinPointcut methodsFor: 'accessing' stamp: 'as 9/18/2007 15:45'!
class: aString

	class _ aString.! !

!DAWithinPointcut methodsFor: 'evaluating' stamp: 'as 9/18/2007 15:47'!
classes

	^ self classesMatching: self class inCategoriesMatching: category.! !

!DAWithinPointcut methodsFor: 'visiting' stamp: 'as 9/18/2007 17:35'!
visitName

	^ 'within'.! !

DAPointcut subclass: #DAMethodExecutionPointcut
	instanceVariableNames: 'methodString'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAMethodExecutionPointcut commentStamp: 'as 8/16/2007 15:00' prior: 0!
A method that is being executed.!

!DAMethodExecutionPointcut class methodsFor: 'instance creation' stamp: 'as 9/18/2007 15:33'!
methods: aString

	^ self new
		methodString: aString;
		yourself.! !

!DAMethodExecutionPointcut methodsFor: 'evaluating' stamp: 'as 9/18/2007 15:34'!
methodString: aString

	methodString _ aString.! !

!DAMethodExecutionPointcut methodsFor: 'accessing' stamp: 'as 9/18/2007 15:34'!
methods

	^ self methodsMatching: methodString inClassesMatching: '*' inCategoriesMatching: '*'.! !

!DAMethodExecutionPointcut methodsFor: 'visiting' stamp: 'as 9/18/2007 17:37'!
visitName

	^ 'methodExecution'.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 9/18/2007 17:43'!
acceptVisitor: aDAPointcutVisitor

	aDAPointcutVisitor perform: ('visit', self visitName capitalized) asSymbol with: self.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 9/18/2007 16:46'!
and: aDAPointcut

	^ DAAndCompositePointcut child: self child: aDAPointcut.! !

!DAPointcut methodsFor: 'searching classes' stamp: 'as 8/23/2007 11:06'!
categoriesMatching: aString

	^ SystemOrganization categoriesMatching: aString.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 9/18/2007 17:02'!
category: aString

	^ self category: aString class: nil.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 9/18/2007 17:02'!
category: categoryString class: classString

	^ (DAWithinPointcut child: self)
		category: categoryString;
		class: classString;
		yourself.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 9/18/2007 17:03'!
class: aString

	^ self category: nil class: aString.! !

!DAPointcut methodsFor: 'searching classes' stamp: 'as 8/23/2007 14:20'!
classesInCategory: aSymbol

	^ (SystemOrganization listAtCategoryNamed: aSymbol)
		collect: [ :each | Smalltalk at: each. ].! !

!DAPointcut methodsFor: 'searching classes' stamp: 'as 8/23/2007 14:40'!
classesMatching: aString in: aCollection

	^ aCollection select: [
		:each |
		aString match: each name asString.
	].! !

!DAPointcut methodsFor: 'searching classes' stamp: 'as 8/23/2007 14:20'!
classesMatching: classString inCategoriesMatching: categoryString

	| candidates |
	candidates _ Set new.
	(self categoriesMatching: categoryString) do: [
		:each |
		candidates addAll: (self classesInCategory: each).
	].
	^ self classesMatching: classString in: candidates.! !

!DAPointcut methodsFor: 'searching classes' stamp: 'as 8/23/2007 14:42'!
methodsMatching: methodString inClassesMatching: classString inCategoriesMatching: categoryString

	| candidates |
	candidates _ Set new.
	(self classesMatching: classString inCategoriesMatching: categoryString) do: [
		:each |
		candidates addAll: each methods.
	].
	^ candidates select: [ :each | methodString match: each selector asString. ].! !

!DAPointcut methodsFor: 'composing' stamp: 'as 9/18/2007 16:46'!
or: aDAPointcut

	^ DAOrCompositePointcut child: self child: aDAPointcut.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 9/18/2007 17:34'!
visitName

	self subclassResponsibility.! !

Object subclass: #DAPointcutBuilder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DAPointcutBuilder commentStamp: 'as 9/26/2007 15:24' prior: 0!
A convenience class with class-side shortcuts for creating pointcuts.!

!DAPointcutBuilder class methodsFor: 'pointcuts' stamp: 'as 9/26/2007 15:09'!
execution: aString

	^ DAMethodExecutionPointcut methods: aString.! !

Object subclass: #DAPointcutVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DAPointcutVisitor commentStamp: 'as 9/26/2007 15:24' prior: 0!
Generic visitor for a pointcut structure.!

DAPointcutVisitor subclass: #DANodeCollector
	instanceVariableNames: 'nodes control condition reifications'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DANodeCollector commentStamp: 'as 9/26/2007 15:23' prior: 0!
Visit a pointcut structure and collect all corresponding nodes in the reflective system.!

!DANodeCollector methodsFor: 'nodes' stamp: 'as 10/2/2007 16:02'!
addNode: aRBProgramNode

	nodes add: aRBProgramNode.! !

!DANodeCollector methodsFor: 'nodes' stamp: 'as 9/18/2007 18:16'!
addNodes: aCollection

	nodes addAll: aCollection.! !

!DANodeCollector methodsFor: 'link options' stamp: 'as 10/2/2007 16:11'!
addReification: aSymbol

	reifications add: aSymbol.! !

!DANodeCollector methodsFor: 'accessing' stamp: 'as 10/2/2007 16:07'!
condition

	^ condition.! !

!DANodeCollector methodsFor: 'accessing' stamp: 'as 10/2/2007 16:07'!
condition: aBlock

	condition _ aBlock.! !

!DANodeCollector methodsFor: 'accessing' stamp: 'as 10/2/2007 16:06'!
control

	^ control.! !

!DANodeCollector methodsFor: 'accessing' stamp: 'as 10/2/2007 16:06'!
control: aSymbol

	control _ aSymbol.! !

!DANodeCollector methodsFor: 'initialize-release' stamp: 'as 10/2/2007 16:01'!
initialize

	nodes _ Set new.
	reifications _ OrderedCollection new.! !

!DANodeCollector methodsFor: 'accessing' stamp: 'as 9/26/2007 15:10'!
nodes

	^ nodes.! !

!DANodeCollector methodsFor: 'accessing' stamp: 'as 10/2/2007 16:10'!
reifications

	^ reifications.! !

!DANodeCollector methodsFor: 'visiting' stamp: 'as 9/18/2007 17:58'!
visitMethodExecution: pointcut

	self addNodes:
		(pointcut methods collect: [ :each | each methodNode. ]).! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 9/18/2007 17:43'!
visit: aDAPointcut

	aDAPointcut acceptVisitor: self.! !

TestCase subclass: #DAAspectTest
	instanceVariableNames: 'example aspect'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DAAspectTest commentStamp: 'as 8/14/2007 10:30' prior: 0!
Testing DAAspect.!

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

!DAAspectTest methodsFor: 'running' stamp: 'as 8/16/2007 15:52'!
setUp

	"super initialize.
	example _ DAExamples new.
	aspect _ DAExampleAspect instance.
	self removeAllLinksOn: DAExamples."! !

!DAAspectTest methodsFor: 'running' stamp: 'as 8/16/2007 15:52'!
tearDown

	"self removeAllLinksOn: DAExamples."! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 8/16/2007 15:52'!
testAspect

	"| count |
	count _ aspect count.
	self shouldnt: [ aspect install. ] raise: Exception.
	example example.
	self assert: (count + 1 = aspect count).
	self shouldnt: [ aspect uninstall. ] raise: Exception."! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 8/16/2007 15:52'!
testNormal

	"| count |
	count _ aspect count.
	example example.
	self assert: count = aspect count."! !

TestCase subclass: #DACodingTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DACodingTest commentStamp: 'as 8/14/2007 10:17' prior: 0!
Test coding guidelines.!

!DACodingTest methodsFor: 'running' stamp: 'as 8/14/2007 10:18'!
packageName

	^ 'DynamicAspects'.! !

!DACodingTest methodsFor: 'running' stamp: 'as 8/14/2007 10:17'!
testClassComment

	"Each class should have a comment."

	(PackageInfo named: self packageName) classes do: [
		:each |
		self assert: each hasComment.
	].! !
