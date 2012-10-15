SystemOrganization addCategory: #'DynamicAspects-Aspects'!
SystemOrganization addCategory: #'DynamicAspects-Kernel'!
SystemOrganization addCategory: #'DynamicAspects-Geppetto'!
SystemOrganization addCategory: #'DynamicAspects-Tests'!

Object subclass: #DAAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DAAspect commentStamp: 'as 11/19/2007 12:50' prior: 0!
An aspect is in AOP (Aspect-Oriented Progamming) what and object is in OOP (Object-Oriented Programming). Instead of trying to break down a program into different objects and their corresponding classes, in AOP the entities of modularization are aspects.
An aspect usually covers a cross-cutting concern in OOP that can be implemented much easier with AOP.!

DAAspect subclass: #DAAnonymousAspect
	instanceVariableNames: 'pointcut advice control condition link'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DAAnonymousAspect commentStamp: 'as 11/19/2007 12:49' prior: 0!
An aspect that doesn't need to be defined in the browser.!

!DAAnonymousAspect class methodsFor: 'instance creation' stamp: 'as 11/19/2007 08:39'!
pointcut: aDAPointcut advice: adviceBlock control: controlBlock

	self new
		pointcut: aDAPointcut;
		advice: adviceBlock;
		control: controlBlock;
		yourself.! !

!DAAnonymousAspect methodsFor: 'accessing' stamp: 'as 11/19/2007 08:15'!
advice: aBlock

	advice _ aBlock.! !

!DAAnonymousAspect methodsFor: 'accessing' stamp: 'as 11/19/2007 08:39'!
condition: aBlock

	condition _ aBlock.! !

!DAAnonymousAspect methodsFor: 'accessing' stamp: 'as 11/19/2007 08:39'!
control: aSymbol

	control _ aSymbol.! !

!DAAnonymousAspect methodsFor: 'installing' stamp: 'as 12/12/2007 17:38'!
install

	| gplink |
	self isInstalled ifFalse: [
		pointcut dependencies do: [ :aspect | aspect install. ].
		gplink _ GPLink metaObject: advice.
		gplink aspect: self.
		condition ifNotNil: [ gplink condition: condition. ].
		[
			pointcut nodes do: [ :node | node link: gplink. ].
			link _ gplink
		] on: Exception do: [
			gplink uninstall.
			self error: 'could not install link'.
		].
	].! !

!DAAnonymousAspect methodsFor: 'testing' stamp: 'as 11/19/2007 08:28'!
isInstalled

	^ link isNil not.! !

!DAAnonymousAspect methodsFor: 'accessing' stamp: 'as 11/19/2007 08:15'!
pointcut: aDAPointcut

	pointcut _ aDAPointcut.! !

!DAAnonymousAspect methodsFor: 'installing' stamp: 'as 11/19/2007 09:06'!
uninstall

	self isInstalled ifTrue: [ link uninstall. link _ nil. ].! !

DAAnonymousAspect subclass: #DAControlFlow
	instanceVariableNames: 'active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Aspects'!

!DAControlFlow commentStamp: 'as 11/28/2007 13:28' prior: 0!
States whether the control flow is under a specified method or not.!

!DAControlFlow class methodsFor: 'instance creation' stamp: 'as 11/28/2007 10:30'!
method: aMethod

	^ self new
		method: aMethod;
		yourself.! !

!DAControlFlow methodsFor: 'initialize-release' stamp: 'as 11/28/2007 11:14'!
initialize

	active _ false.
	self advice: [ active _ active not. ].
	self control: #beforeafter.! !

!DAControlFlow methodsFor: 'testing' stamp: 'as 11/28/2007 11:14'!
isActive

	^ active.! !

!DAControlFlow methodsFor: 'pointcut' stamp: 'as 11/28/2007 10:46'!
method: aMethod

	self pointcut: (DAPointcut method: aMethod).! !

!DAAspect methodsFor: 'advices' stamp: 'as 11/19/2007 08:29'!
adviceControls

	^ #(before after instead).! !

!DAAspect methodsFor: 'installing' stamp: 'as 11/19/2007 08:17'!
install

	self subclassResponsibility.! !

!DAAspect methodsFor: 'testing' stamp: 'as 11/19/2007 08:17'!
isInstalled

	self subclassResponsibility.! !

!DAAspect methodsFor: 'installing' stamp: 'as 11/19/2007 08:17'!
uninstall

	self subclassResponsibility.! !

DAAspect subclass: #DAAspectClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

DAAspectClass class
	instanceVariableNames: 'pointcutNames'!

!DAAspectClass commentStamp: 'as 11/19/2007 12:49' prior: 0!
This makes the transition from a class to an aspect.!

DAAspectClass class
	instanceVariableNames: 'pointcutNames'!

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 10/31/2007 10:38'!
pointcutNames

	^ pointcutNames ifNil: [ pointcutNames _ Set new. ].! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 10/31/2007 14:53'!
pointcutNames: aString
	
	pointcutNames _ self stringToSymbols: aString.! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 7/23/2007 15:01'!
stringToSymbols: aString

	| set |
	set _ Set new.
	(aString subStrings: ' ') do: [
		:substring |
		set add: substring asSymbol.
	].
	^ set.! !

!DAAspectClass class methodsFor: 'subaspect creation' stamp: 'as 10/22/2007 09:26'!
subaspect: class pointcutNames: pointcuts instanceVariableNames: instVars classVariableNames: classVars poolDictionaries: pools category: cat

	| newClass |
	newClass _ self subclass: class
		instanceVariableNames: instVars
		classVariableNames: classVars
		poolDictionaries: pools
		category: cat.
	newClass
		pointcutNames: pointcuts.
	^ newClass.! !

DAAspectClass subclass: #DACodedAspect
	instanceVariableNames: 'links pc'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

DACodedAspect class
	instanceVariableNames: 'instance'!

!DACodedAspect commentStamp: 'as 12/12/2007 16:31' prior: 0!
An aspect that is defined in the browser. The pointcuts and advices can all be implemented with normal methods.

Although aspects are not necessarily objects or classes, in this implementation they are implemented as singleton classes in the traditional OOP way to get a good integration with the existing system.!

DACodedAspect class
	instanceVariableNames: 'instance'!

!DACodedAspect class methodsFor: 'accessing' stamp: 'as 10/31/2007 14:59'!
allPointcutNames

	^ self superclass pointcutNames, self pointcutNames.! !

!DACodedAspect class methodsFor: 'fileIn/Out' stamp: 'as 10/31/2007 13:58'!
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
	aStream cr; tab; nextPutAll: 'instanceVariableNames: ';
			store: self instanceVariablesString.
	aStream cr; tab; nextPutAll: 'classVariableNames: ';
			store: self classVariablesString.
	aStream cr; tab; nextPutAll: 'poolDictionaries: ';
			store: self sharedPoolsString.
	aStream cr; tab; nextPutAll: 'category: ';
			store: (SystemOrganization categoryOfElement: self name) asString.

	superclass ifNil: [ 
		aStream nextPutAll: '.'; cr.
		aStream nextPutAll: self name.
		aStream space; nextPutAll: 'superclass: nil'. ].

	^ aStream contents! !

!DACodedAspect class methodsFor: 'instance creation' stamp: 'as 10/31/2007 10:33'!
instance

	^ instance ifNil: [ instance := self basicNew initialize. ].! !

!DACodedAspect class methodsFor: 'instance creation' stamp: 'as 10/31/2007 13:59'!
new

	self error: 'I''m singleton, use ', self class name, ' >> instance'.! !

!DACodedAspect class methodsFor: 'printing' stamp: 'as 10/22/2007 09:38'!
pointcutsString

	^ String streamContents: [
		:stream |
		self pointcutNames do: [
			:each |
			stream nextPutAll: each asString.
		] separatedBy: [ stream space. ].
	].! !

!DACodedAspect class methodsFor: 'instance creation' stamp: 'as 7/18/2007 15:03'!
template: categorySymbol

	^ self templateForSubclassOf: DAAspect name category: categorySymbol. ! !

!DACodedAspect class methodsFor: 'instance creation' stamp: 'as 10/31/2007 14:00'!
templateForSubclassOf: aClass category: aSymbol

	^ aClass asString, 'subaspect: #NameOfSubaspect
	pointcutNames: ''''
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''' , aSymbol asString , ''''.! !

!DACodedAspect methodsFor: 'advices' stamp: 'as 10/31/2007 14:21'!
advices

	| possibilities |
	possibilities _ self possibleAdviceNames.
	^ self class methods select: [
		:method |
		possibilities anySatisfy: [ :pos | pos match: method selector. ].
	].! !

!DACodedAspect methodsFor: 'accessing' stamp: 'as 10/22/2007 09:56'!
allPointcutNames

	^ self class allPointcutNames.! !

!DACodedAspect methodsFor: 'advices' stamp: 'as 10/24/2007 09:51'!
controlForAdvice: aMethod

	^ self adviceControls detect: [
		:ctrl |
		aMethod selector startsWith: ctrl.
	].! !

!DACodedAspect methodsFor: 'initialize-release' stamp: 'as 10/31/2007 10:27'!
initialize

	self initializeLinks.
	pc _ DAPointcut.! !

!DACodedAspect methodsFor: 'initialize-release' stamp: 'as 11/19/2007 08:26'!
initializeLinks

	links _ IdentitySet new.! !

!DACodedAspect methodsFor: 'installing' stamp: 'as 12/12/2007 17:12'!
install

	self isInstalled ifFalse: [
		self advices do: [
			:adv |
			| pointcut |
			pointcut _ self pointcutForAdvice: adv.
			pointcut dependencies do: [ :aspect | aspect install. ].
			self installAdvice: adv pointcut: pointcut.
		].
	].! !

!DACodedAspect methodsFor: 'private' stamp: 'as 12/12/2007 17:19'!
installAdvice: advice pointcut: pointcut

	| link |
	link _ GPLink new
		metaObject: self;
		selector: advice selector;
		arguments: (self reificationsForAdvice: advice);
		control: (self controlForAdvice: advice);
		aspect: self;
		yourself.
	pointcut condition ifNotNil: [ link condition: pointcut condition. ].
	[
		pointcut nodes do: [ :node | node link: link. ].
		links add: link.
	] on: Exception do: [
		link uninstall.
		self error: 'could not install link'.
	].! !

!DACodedAspect methodsFor: 'testing' stamp: 'as 11/19/2007 08:27'!
isInstalled

	^ links isEmpty not.! !

!DACodedAspect methodsFor: 'pointcuts' stamp: 'as 10/31/2007 14:20'!
pointcut: aSymbol

	^ self perform: aSymbol.! !

!DACodedAspect methodsFor: 'pointcuts' stamp: 'as 10/31/2007 10:35'!
pointcutForAdvice: aMethod

	^ self pointcut: (
		self allPointcutNames detect: [
			:pcn |
			(aMethod selector subStrings: ':') first endsWith: pcn capitalized.
		]
	).! !

!DACodedAspect methodsFor: 'advices' stamp: 'as 10/31/2007 10:32'!
possibleAdviceNames

	| names |
	names _ Set new.
	self allPointcutNames do: [
		:pcn |
		self adviceControls do: [
			:ctrl |
			names add: ctrl, pcn capitalized, '*'.
		].
	].
	^ names.! !

!DACodedAspect methodsFor: 'advices' stamp: 'as 10/24/2007 15:28'!
reificationsForAdvice: aMethod

	^ aMethod reflectiveMethod argumentNames collect: [ :name | name asSymbol. ].! !

!DACodedAspect methodsFor: 'installing' stamp: 'as 11/19/2007 08:27'!
uninstall

	self isInstalled ifTrue: [
		links do: [ :link | link uninstall. ].
		self initializeLinks.
	].! !

DACodedAspect subclass: #DATestAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DATestAspect commentStamp: 'as 10/8/2007 10:18' prior: 0!
An aspect to run tests on.!

!DATestAspect methodsFor: 'advices' stamp: 'as 10/24/2007 15:11'!
afterExample1

	DAExamples count.! !

!DATestAspect methodsFor: 'advices' stamp: 'as 11/19/2007 13:26'!
afterOuterInner

	DAExamples count.! !

!DATestAspect methodsFor: 'advices' stamp: 'as 10/31/2007 14:39'!
beforeExample2

	DAExamples count.! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 10/31/2007 14:32'!
example1

	^ pc method: DAExamples class >> #example1.! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 10/31/2007 14:41'!
example2

	^ pc method: DAExamples class >> #example2.! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 11/19/2007 13:26'!
outerInner

	^ (pc withinMethod: DAExamples class >> #outer)
		class: 'DAExamples class';
		method: 'inner';
		yourself.! !

Object subclass: #DAExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

DAExamples class
	instanceVariableNames: 'counter'!

!DAExamples commentStamp: 'as 10/23/2007 16:14' prior: 0!
Class to test aspects on.!

DAExamples class
	instanceVariableNames: 'counter'!

!DAExamples class methodsFor: 'counting' stamp: 'as 10/23/2007 16:23'!
count

	counter _ counter + 1.! !

!DAExamples class methodsFor: 'counting' stamp: 'as 10/23/2007 16:23'!
counter

	^ counter.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 10/23/2007 16:23'!
example1

	counter _ 2.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 10/31/2007 14:39'!
example2

	counter _ 2.! !

!DAExamples class methodsFor: 'counting' stamp: 'as 10/23/2007 16:22'!
initializeCounter

	counter _ 0.! !

!DAExamples class methodsFor: 'counting' stamp: 'as 11/19/2007 13:25'!
inner! !

!DAExamples class methodsFor: 'counting' stamp: 'as 11/19/2007 13:25'!
outer

	self inner.! !

Object subclass: #DAGeppettoExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DAGeppettoExamples commentStamp: 'as 1/14/2008 16:35' prior: 0!
Dummy class to test Geppetto links on.!

!DAGeppettoExamples class methodsFor: 'examples' stamp: 'as 1/11/2008 14:53'!
example1! !

Object subclass: #DAPointcut
	instanceVariableNames: 'categoryFilter classFilter methodFilter nodeFilter categories classes methods nodes condition dependencies'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DAPointcut commentStamp: 'as 11/19/2007 12:52' prior: 0!
Pointcuts describe a set of join points. So far, the only type of join points are nodes in reflective methods.!

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 11/28/2007 13:34'!
condition: aBlock

	^ self new
		condition: aBlock;
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 11/26/2007 11:10'!
fieldAccess: fieldRegex

	^ self new
		node: [ :node | self node: node isVariable: fieldRegex. ];
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 11/26/2007 11:12'!
fieldRead: fieldRegex

	^ self new
		node: [ :node | (self node: node isVariable: fieldRegex) and: [ node isRead. ]. ];
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 11/26/2007 11:12'!
fieldWrite: fieldRegex

	^ self new
		node: [ :node | (self node: node isVariable: fieldRegex) and: [ node isWrite. ]. ];
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 11/14/2007 18:19'!
method: aMethod

	^ self new
		class: aMethod methodClass asString;
		method: aMethod selector asString;
		node: [ :node | node isMethod. ];
		yourself.! !

!DAPointcut class methodsFor: 'testing' stamp: 'as 11/26/2007 11:10'!
node: aPEProgramNode isVariable: fieldRegex

	^ aPEProgramNode isVariable and: [ aPEProgramNode name matchesRegex: fieldRegex. ].! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 12/12/2007 16:29'!
withinMethod: aMethod

	| cflow |
	cflow _ DAControlFlow method: aMethod.
	^ (self condition: [ cflow isActive. ])
		dependsOn: cflow;
		yourself.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 11/14/2007 16:58'!
and: aDAPointcut

	self shouldBeImplemented.! !

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 15:32'!
categories

	^ categories ifNil: [
		categories _ SystemOrganization categories select: [
			:each | each matchesRegex: categoryFilter.
		].
	].! !

!DAPointcut methodsFor: 'designating' stamp: 'as 11/14/2007 15:32'!
category: regexString

	categoryFilter _ regexString.! !

!DAPointcut methodsFor: 'designating' stamp: 'as 11/14/2007 15:32'!
class: regexString

	classFilter _ regexString.! !

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 15:47'!
classMatches: aClass

	^ (aClass name matchesRegex: classFilter) and: [
		self categories includes: aClass instanceSide category.
	].! !

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 15:45'!
classes

	^ classes ifNil: [
		classes _ Smalltalk allClasses select: [
			:each |
			(self classMatches: each instanceSide) or: [ self classMatches: each classSide. ].
		].
	].! !

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 16:57'!
condition

	^ condition.! !

!DAPointcut methodsFor: 'designating' stamp: 'as 11/14/2007 16:56'!
condition: aBlock

	condition _ aBlock.! !

!DAPointcut methodsFor: 'accessing' stamp: 'as 12/12/2007 16:30'!
dependencies

	^ dependencies.! !

!DAPointcut methodsFor: 'accessing' stamp: 'as 12/12/2007 16:29'!
dependsOn: aDAAspect

	dependencies add: aDAAspect.! !

!DAPointcut methodsFor: 'initialize-release' stamp: 'as 12/12/2007 16:31'!
initialize

	categoryFilter _ classFilter _ methodFilter _ '.*'.
	nodeFilter _ [:node | true].
	dependencies _ Set new.! !

!DAPointcut methodsFor: 'designating' stamp: 'as 11/14/2007 15:32'!
method: regexString

	methodFilter _ regexString.! !

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 16:08'!
methods

	^ methods ifNil: [
		| matches |
		matches _ Set new.
		self classes do: [
			:each |
			each methods do: [
				:method |
				(method selector matchesRegex: methodFilter) ifTrue: [
					matches add: method reflectiveMethod.
				].
			].
		].
		methods _ matches.
	].! !

!DAPointcut methodsFor: 'designating' stamp: 'as 11/14/2007 15:33'!
node: aBlock

	nodeFilter _ aBlock.! !

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 17:22'!
nodes

	^ nodes ifNil: [
		| matches |
		matches _ Set new.
		self methods do: [
			:each |
			matches addAll: (each nodes select: nodeFilter).
		].
		nodes _ matches.
	].! !

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 16:58'!
not

	self shouldBeImplemented.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 11/14/2007 16:58'!
or: aDAPointcut

	self shouldBeImplemented.! !

!DAPointcut methodsFor: 'caching' stamp: 'as 11/14/2007 16:54'!
reset

	categories _ classes _ methods _ nodes _ nil.! !

GPCondition subclass: #DAArgumentListGPCondition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Geppetto'!

!DAArgumentListGPCondition commentStamp: 'as 1/14/2008 16:39' prior: 0!
Used instead of GPCondition to make the GPTransformer aware of the fact that the condition wants a single argument passed, which will contain all reification arguments in a dictionary.!

!GPLink methodsFor: '*DynamicAspects' stamp: 'as 1/14/2008 10:15'!
argumentListCondition: aCondition arguments: args

	aCondition isBlock ifFalse: [ self error: 'condition needs to be a block'. ].
	aCondition numArgs = 1 ifFalse: [ self error: 'condition must have exactly 1 argument'. ].
	
	self checkReification: args.
	
	condition _ DAArgumentListGPCondition with: aCondition.
	condition arguments: args.
	self isInlineCondition ifTrue: [ self update. ].! !

!GPLink methodsFor: '*DynamicAspects' stamp: 'as 12/12/2007 15:55'!
aspect

	properties ifNil: [ ^ nil. ].
	^self properties at: #aspect ifAbsent: [ nil. ].! !

!GPLink methodsFor: '*DynamicAspects' stamp: 'as 12/12/2007 15:54'!
aspect: aDAAspect

	self properties at: #aspect put: aDAAspect.! !

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

TestCase subclass: #DAAspectTest
	instanceVariableNames: 'example aspect'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DAAspectTest commentStamp: 'as 8/14/2007 10:30' prior: 0!
Testing DAAspect.!

!DAAspectTest methodsFor: 'running' stamp: 'as 1/11/2008 15:17'!
removeAllLinksOn: aClass

	aClass methodDict values, aClass class methodDict values do: [
		:method |
		method reflectiveMethod methodNode nodesDo: [
			:node |
			node hasAnyLink ifTrue: [ node removeAllLinks. ].
			self assert: node hasAnyLink not.
		].
	].! !

!DAAspectTest methodsFor: 'running' stamp: 'as 1/11/2008 15:16'!
setUp

	super initialize.
	self removeAllLinksOn: DAExamples.
	DAExamples initializeCounter.
	DATestAspect instance install.! !

!DAAspectTest methodsFor: 'running' stamp: 'as 1/11/2008 15:16'!
tearDown

	DATestAspect instance uninstall.
	self removeAllLinksOn: DAExamples.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 11/19/2007 13:32'!
testAfter

	DAExamples example1.
	self assert: DAExamples counter = 2.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 10/31/2007 14:41'!
testBefore

	DAExamples example2.
	self assert: DAExamples counter = 2.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 11/19/2007 13:27'!
testCflow

	DAExamples inner.
	self assert: DAExamples counter = 0.
	DAExamples outer.
	self assert: DAExamples counter = 0.! !

TestCase subclass: #DACodingTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DACodingTest commentStamp: 'as 8/14/2007 10:17' prior: 0!
Test coding guidelines.!

!DACodingTest methodsFor: 'testing' stamp: 'as 8/14/2007 10:18'!
packageName

	^ 'DynamicAspects'.! !

!DACodingTest methodsFor: 'testing' stamp: 'as 8/14/2007 10:17'!
testClassComment

	"Each class should have a comment."

	(PackageInfo named: self packageName) classes do: [
		:each |
		self assert: each hasComment.
	].! !

TestCase subclass: #DAGeppettoTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DAGeppettoTests commentStamp: 'as 1/14/2008 16:36' prior: 0!
Additional test for Geppetto.!

!DAGeppettoTests methodsFor: 'running' stamp: 'as 1/11/2008 15:18'!
removeAllLinksOn: aClass

	aClass methodDict values, aClass class methodDict values do: [
		:method |
		method reflectiveMethod methodNode nodesDo: [
			:node |
			node hasAnyLink ifTrue: [ node removeAllLinks. ].
			self assert: node hasAnyLink not.
		].
	].! !

!DAGeppettoTests methodsFor: 'running' stamp: 'as 1/11/2008 14:41'!
setUp

	super initialize.
	self removeAllLinksOn: DAGeppettoExamples.! !

!DAGeppettoTests methodsFor: 'running' stamp: 'as 1/11/2008 14:41'!
tearDown

	self removeAllLinksOn: DAGeppettoExamples.! !

!DAGeppettoTests methodsFor: 'testing' stamp: 'as 1/14/2008 10:54'!
testArgumentListCondition

	| link asserted |
	asserted _ false.
	link _ GPLink metaObject: [ asserted _ true. ].
	link before.
	link argumentListCondition:
		[ :args | (args at: #object) = DAGeppettoExamples. ] arguments: #(object).
	link hookOn: (DAGeppettoExamples class >> #example1) reflectiveMethod methodNode.
	DAGeppettoExamples example1.
	self assert: asserted.! !

!DAGeppettoTests methodsFor: 'testing' stamp: 'as 1/11/2008 15:56'!
testConditionArguments

	| link asserted |
	asserted _ false.
	link _ GPLink metaObject: [ asserted _ true. ].
	link condition: [ :arg | arg == DAGeppettoExamples ] arguments: #(object).
	link hookOn: (DAGeppettoExamples class >> #example1) reflectiveMethod methodNode.
	DAGeppettoExamples example1.
	self assert: asserted.! !
