SystemOrganization addCategory: #DynamicAspects!
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

Object subclass: #DAAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects'!

!DAAspect commentStamp: 'as 11/19/2007 12:50' prior: 0!
An aspect is in AOP (Aspect-Oriented Progamming) what and object is in OOP (Object-Oriented Programming). Instead of trying to break down a program into different objects and their corresponding classes, in AOP the entities of modularization are aspects.
An aspect usually covers a cross-cutting concern in OOP that can be implemented much easier with AOP.!

DAAspect subclass: #DAAnonymousAspect
	instanceVariableNames: 'pointcut advice control condition link'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects'!

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

!DAAnonymousAspect methodsFor: 'installing' stamp: 'as 11/19/2007 09:18'!
install

	| gplink |
	self isInstalled ifFalse: [
		gplink _ GPLink metaObject: advice.
		condition ifNotNil: [ gplink condition: condition. ].
		pointcut nodes do: [ :node | node link: gplink. ].
		pointcut extraAspects do: [ :aspect | aspect install. ].
		link _ gplink.
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
	category: 'DynamicAspects'!

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
	category: 'DynamicAspects'!

DACodedAspect class
	instanceVariableNames: 'instance'!

!DACodedAspect commentStamp: 'as 11/19/2007 12:51' prior: 0!
An aspect that is defined in the browser. The pointcuts and advices can both be implemented with normal methods.

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

!DACodedAspect methodsFor: 'installing' stamp: 'as 11/19/2007 13:29'!
install

	self isInstalled ifFalse: [
		self advices do: [
			:adv |
			| link pointcut |
			pointcut _ self pointcutForAdvice: adv.
			link _ GPLink new
				metaObject: self;
				selector: adv selector;
				arguments: (self reificationsForAdvice: adv);
				control: (self controlForAdvice: adv);
				yourself.
			pointcut condition ifNotNil: [ link condition: pointcut condition. ].
			self install: link on: pointcut nodes.
		].
	].! !

!DACodedAspect methodsFor: 'installing' stamp: 'as 11/19/2007 08:27'!
install: aGPLink on: aCollection

	aCollection do: [
		:node |
		node link: aGPLink.
	].
	links add: aGPLink.! !

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

Object subclass: #DAFlag
	instanceVariableNames: 'flag'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects'!

!DAFlag commentStamp: 'as 11/19/2007 12:52' prior: 0!
A simple flag that can be on or off.!

!DAFlag class methodsFor: 'instance creation' stamp: 'as 11/19/2007 10:02'!
off

	^ self new off; yourself.! !

!DAFlag class methodsFor: 'instance creation' stamp: 'as 11/19/2007 10:02'!
on

	^ self new on; yourself.! !

!DAFlag methodsFor: 'initialize-release' stamp: 'as 11/19/2007 09:29'!
initialize

	flag _ false.! !

!DAFlag methodsFor: 'testing' stamp: 'as 11/19/2007 10:00'!
isOn

	^ flag.! !

!DAFlag methodsFor: 'flag' stamp: 'as 11/19/2007 10:00'!
off

	flag _ false.! !

!DAFlag methodsFor: 'flag' stamp: 'as 11/19/2007 10:00'!
on

	flag _ true.! !

!DAFlag methodsFor: 'flag' stamp: 'as 11/19/2007 09:30'!
switch

	flag _ flag not.! !

Object subclass: #DAPointcut
	instanceVariableNames: 'categoryFilter classFilter methodFilter nodeFilter categories classes methods nodes condition extraAspects'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects'!

!DAPointcut commentStamp: 'as 11/19/2007 12:52' prior: 0!
Pointcuts describe a set of join points. So far, the only type of join points are nodes in reflective methods.!

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 11/14/2007 18:20'!
if: aBlock

	^ self new
		condition: aBlock;
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 11/14/2007 18:19'!
method: aMethod

	^ self new
		class: aMethod methodClass asString;
		method: aMethod selector asString;
		node: [ :node | node isMethod. ];
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 11/19/2007 10:04'!
withinMethod: aMethod

	| flag aspect |
	flag _ DAFlag off.
	aspect _ DAAnonymousAspect
		pointcut: (self method: aMethod)
		advice: [ flag switch. ]
		control: #beforeafter.
	^ (self if: [ flag isOn. ])
		extraAspect: aspect;
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

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 15:32'!
category: regexString

	categoryFilter _ regexString.! !

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 15:32'!
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

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 16:56'!
condition: aBlock

	condition _ aBlock.! !

!DAPointcut methodsFor: 'accessing' stamp: 'as 11/19/2007 10:03'!
extraAspect: aDAAspect

	extraAspects add: aDAAspect.! !

!DAPointcut methodsFor: 'accessing' stamp: 'as 11/19/2007 09:18'!
extraAspects

	^ extraAspects.! !

!DAPointcut methodsFor: 'initialize-release' stamp: 'as 11/19/2007 09:18'!
initialize

	categoryFilter _ classFilter _ methodFilter _ '.*'.
	nodeFilter _ [ :node | true. ].
	extraAspects _ Set new.! !

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 15:32'!
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

!DAPointcut methodsFor: 'filtering' stamp: 'as 11/14/2007 15:33'!
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

!DAAspectTest methodsFor: 'running' stamp: 'as 10/31/2007 14:34'!
setUp

	super initialize.
	self removeAllLinksOn: DAExamples.
	DAExamples initializeCounter.
	DATestAspect instance install.! !

!DAAspectTest methodsFor: 'running' stamp: 'as 10/31/2007 14:34'!
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
