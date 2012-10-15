SystemOrganization addCategory: #'DynamicAspects-Tests'!
SystemOrganization addCategory: #'DynamicAspects-Joinpoints'!
SystemOrganization addCategory: #'DynamicAspects-Kernel'!
SystemOrganization addCategory: #'DynamicAspects-Pointcuts'!
SystemOrganization addCategory: #'DynamicAspects-Aspects'!

Object subclass: #DAAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

DAAspect class
	instanceVariableNames: 'Advices Instance Links Pointcuts'!

DAAspect class
	instanceVariableNames: 'Advices Instance Links Pointcuts'!

!DAAspect class methodsFor: 'accessing' stamp: 'as 7/3/2007 11:46'!
advices

	^ Advices.! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 6/27/2007 15:09'!
advices: aString

	Advices _ self stringToSymbols: aString.! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 7/3/2007 11:38'!
instance

	^ Instance ifNil: [ Instance _ self basicNew initialize. ].! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 7/3/2007 11:47'!
links

	^ Links.! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 7/2/2007 10:46'!
links: aString

	Links _ self stringToSymbols: aString.! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 7/2/2007 10:14'!
new

	self error: 'I am singleton, use ', self class name, '>>instance'.! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 7/3/2007 11:46'!
pointcuts

	^ Pointcuts.! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 6/27/2007 15:10'!
pointcuts: aString

	Pointcuts _ self stringToSymbols: aString.! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 6/27/2007 15:09'!
stringToSymbols: aString

	^ (aString subStrings: ' ') collect: [
		:substring |
		substring asSymbol.
	].! !

!DAAspect class methodsFor: 'subaspect creation' stamp: 'as 7/18/2007 08:45'!
subaspect: class pointcutNames: pointcuts adviceNames: advices linkNames: links instanceVariableNames:  instVars classVariableNames: classVars poolDictionaries: pools category: cat

	^ self
		subclass: class
			instanceVariableNames: instVars
			classVariableNames: classVars
			poolDictionaries: pools
			category: cat;
		pointcuts: pointcuts;
		advices: advices;
		links: links;
		yourself.! !

!DAAspect class methodsFor: 'subaspect creation' stamp: 'as 7/2/2007 10:47'!
subaspect: class pointcutNames: pointcuts adviceNames: advices linkNames: links variableNames: variables category: cat

	^ self
		subclass: class
			instanceVariableNames: variables
			classVariableNames: ''
			poolDictionaries: ''
			category: category;
		pointcuts: pointcuts;
		advices: advices;
		links: links;
		yourself.! !

!DAAspect methodsFor: 'advices' stamp: 'as 7/4/2007 15:34'!
advice: aSymbol

	| advice |
	advice _ nil.
	(self class isProvidedSelector: aSymbol) ifTrue: [
		advice _ aSymbol.
	].
	^ advice.! !

!DAAspect methodsFor: 'advices' stamp: 'as 7/3/2007 11:46'!
adviceNames

	^ self class advices.! !

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

!DAAspect methodsFor: 'linking' stamp: 'as 7/3/2007 11:46'!
linkNames

	^ self class links.! !

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

!DAAspect methodsFor: 'pointcuts' stamp: 'as 7/3/2007 11:46'!
pointcutNames

	^ self class pointcuts.! !

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
