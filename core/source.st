SystemOrganization addCategory: #'DynamicAspects-Geppetto'!
SystemOrganization addCategory: #'DynamicAspects-Geppetto-Tests'!
SystemOrganization addCategory: #'DynamicAspects-Kernel'!
SystemOrganization addCategory: #'DynamicAspects-Kernel-Tests'!
SystemOrganization addCategory: #'DynamicAspects-Pointcut'!
SystemOrganization addCategory: #'DynamicAspects-Pointcut-Tests'!
SystemOrganization addCategory: #'DynamicAspects-Testing'!
SystemOrganization addCategory: #'DynamicAspects-Tests'!
SystemOrganization addCategory: #'DynamicAspects-Utilities-Tests'!
SystemOrganization addCategory: #'DynamicAspects-Utilities'!

!String methodsFor: '*DynamicAspects' stamp: 'as 2/11/2008 08:14'!
asRegexFilter

	^ DARegexFilter new: self.! !

Object subclass: #DAAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DAAspect commentStamp: 'as 11/19/2007 12:50' prior: 0!
An aspect is in AOP (Aspect-Oriented Progamming) what and object is in OOP (Object-Oriented Programming). Instead of trying to break down a program into different objects and their corresponding classes, in AOP the entities of modularization are aspects.
An aspect usually covers a cross-cutting concern in OOP that can be implemented much easier with AOP.!

DAAspect subclass: #DAAnonymousAspect
	instanceVariableNames: 'pointcuts advices controls links'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DAAnonymousAspect commentStamp: 'as 11/19/2007 12:49' prior: 0!
An aspect that doesn't need to be defined in the browser.!

!DAAnonymousAspect methodsFor: 'accessing' stamp: 'as 1/14/2008 16:55'!
addAdvice: aBlock

	advices add: aBlock.! !

!DAAnonymousAspect methodsFor: 'accessing' stamp: 'as 1/17/2008 11:28'!
addAdvice: adviceBlock control: aSymbol pointcut: aDAPointcut

	self
		addAdvice: adviceBlock;
		addControl: aSymbol;
		addPointcut: aDAPointcut.! !

!DAAnonymousAspect methodsFor: 'accessing' stamp: 'as 1/14/2008 16:55'!
addControl: aSymbol

	controls add: aSymbol.! !

!DAAnonymousAspect methodsFor: 'accessing' stamp: 'as 1/14/2008 16:56'!
addPointcut: aDAPointcut

	pointcuts add: aDAPointcut.! !

!DAAnonymousAspect methodsFor: 'initialize-release' stamp: 'as 1/17/2008 10:43'!
initialize

	advices _ OrderedCollection new.
	pointcuts _ OrderedCollection new.
	controls _ OrderedCollection new.
	links _ OrderedCollection new.! !

!DAAnonymousAspect methodsFor: 'installing' stamp: 'as 1/21/2008 08:51'!
install

	| link |
	self isInstalled ifFalse: [
		1 to: pointcuts size do: [
			:i |
			| pointcut |
			pointcut _ pointcuts at: i.
			link _ GPLink metaObject: (advices at: i).
			link aspect: self.
			pointcut condition ifNotNil: [
				pointcut conditionArguments ifNil: [
					link condition: pointcut condition.
				] ifNotNil: [
					link singleArgCondition: pointcut condition
						arguments: pointcut conditionArguments.
				].
			].
			[
				(pointcuts at: i) nodes do: [ :node | node link: link. ].
				links add: link.
			] on: Exception do: [
				link uninstall.
				self uninstall.
				self error: 'could not install link'.
			].
		].
	].! !

!DAAnonymousAspect methodsFor: 'testing' stamp: 'as 1/14/2008 16:56'!
isInstalled

	^ links isEmpty not.! !

!DAAnonymousAspect methodsFor: 'installing' stamp: 'as 1/14/2008 16:55'!
uninstall

	self isInstalled ifTrue: [
		links do: [ :link | link uninstall. ].
		links removeAll: links.
	].! !

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

!DACodedAspect methodsFor: 'installing' stamp: 'as 1/17/2008 15:42'!
install

	self isInstalled ifFalse: [
		self advices do: [
			:adv |
			| pointcut |
			pointcut _ self pointcutForAdvice: adv.
			self installAdvice: adv pointcut: pointcut.
		].
	].! !

!DACodedAspect methodsFor: 'private' stamp: 'as 1/21/2008 08:51'!
installAdvice: advice pointcut: pointcut

	| link |
	link _ GPLink new
		metaObject: self;
		selector: advice selector;
		arguments: (self reificationsForAdvice: advice);
		control: (self controlForAdvice: advice);
		aspect: self;
		yourself.
	pointcut condition ifNotNil: [
		pointcut conditionArguments ifNil: [
			link condition: pointcut condition.
		] ifNotNil: [
			link singleArgCondition: pointcut condition
				arguments: pointcut conditionArguments.
		].
	].
	[
		pointcut nodes do: [ :node | node link: link. ].
		links add: link.
	] on: Exception do: [
		link uninstall.
		self uninstall.
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
	category: 'DynamicAspects-Testing'!

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
	category: 'DynamicAspects-Testing'!

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
	category: 'DynamicAspects-Testing'!

!DAGeppettoExamples commentStamp: 'as 1/14/2008 16:35' prior: 0!
Dummy class to test Geppetto links on.!

!DAGeppettoExamples class methodsFor: 'examples' stamp: 'as 1/11/2008 14:53'!
example1! !

Object subclass: #DALink
	instanceVariableNames: 'link filters cache'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Geppetto'!

!DALink commentStamp: 'as 1/31/2008 11:18' prior: 0!
Host a GPLink together with a description of the nodes it should be installed on.!

!DALink methodsFor: 'composing' stamp: 'as 2/4/2008 17:41'!
and: aDALink

	| andLink |
	
	andLink _ self class new.
	andLink condition: (self combineCondition: aDALink).
	self keys do: [
		:key |
		andLink filtersAt: key put: (self filtersAt: key), (aDALink filtersAt: key).
	].		
	^ andLink.! !

!DALink methodsFor: 'caching' stamp: 'as 2/4/2008 17:30'!
cacheAt: aSymbol

	^ (cache at: aSymbol) ifNil: [ cache at: aSymbol put: (self filter: aSymbol). ].! !

!DALink methodsFor: 'aliases' stamp: 'as 2/4/2008 17:48'!
categories

	^ self cacheAt: #category.! !

!DALink methodsFor: 'aliases' stamp: 'as 2/8/2008 11:54'!
category: aRegexFilter

	self filterAt: #category put: aRegexFilter.! !

!DALink methodsFor: 'aliases' stamp: 'as 2/8/2008 11:55'!
class: aRegexFilter

	self filterAt: #class put: aRegexFilter.! !

!DALink methodsFor: 'filtering' stamp: 'as 2/8/2008 11:18'!
class: aClass matches: aRegexFilter

	^ (aRegexFilter matches: aClass name) and: [
		(self cacheAt: #category) includes: aClass instanceSide category.
	].! !

!DALink methodsFor: 'aliases' stamp: 'as 2/4/2008 17:48'!
classes

	^ self cacheAt: #class.! !

!DALink methodsFor: 'private' stamp: 'as 1/27/2008 17:25'!
combineCondition: aDALink

	self hasCondition ifTrue: [
		aDALink hasCondition ifTrue: [
			^ self condition and: aDALink condition.
		] ifFalse: [
			^ self condition.
		].
	] ifFalse: [
		aDALink hasCondition ifTrue: [
			^ aDALink condition.
		] ifFalse: [
			^ nil.
		].
	].! !

!DALink methodsFor: 'accessing' stamp: 'as 1/27/2008 17:16'!
condition

	^ link condition.! !

!DALink methodsFor: 'accessing' stamp: 'as 1/27/2008 16:09'!
condition: aDACondition

	link conditionObject: aDACondition.! !

!DALink methodsFor: 'defaults' stamp: 'as 2/11/2008 10:12'!
defaultFiltersAt: aSymbol

	aSymbol = #category ifTrue: [ ^ { '*' asRegexFilter }. ].
	aSymbol = #class ifTrue: [ ^ { '*' asRegexFilter }. ].
	aSymbol = #method ifTrue: [ ^ { '*' asRegexFilter }. ].
	aSymbol = #node ifTrue: [ ^ { [ :node | node isMethod. ] }. ].
	^ #().! !

!DALink methodsFor: 'accessing' stamp: 'as 2/4/2008 17:21'!
defaultOrFiltersAt: aSymbol

	^ (filters at: aSymbol) selfIfEmpty: [ self defaultFiltersAt: aSymbol. ].! !

!DALink methodsFor: 'filtering' stamp: 'as 2/4/2008 17:55'!
filter: aSymbol

	^ self perform: (#filter, aSymbol capitalized) asSymbol.! !

!DALink methodsFor: 'accessing' stamp: 'as 2/8/2008 11:53'!
filterAt: aSymbol put: aRegexFilter

	(filters at: aSymbol) add: aRegexFilter.
	self reset.! !

!DALink methodsFor: 'filtering' stamp: 'as 2/11/2008 08:30'!
filterCategory

	| categories |

	categories _ SystemOrganization categories.
	(self defaultOrFiltersAt: #category) do: [
		:filter |
		categories _ categories select: [
			:each | filter matches: each.
		].
	].
	^ categories.! !

!DALink methodsFor: 'filtering' stamp: 'as 2/4/2008 17:26'!
filterClass

	| classes |
	
	classes _ Smalltalk allClasses collect: [ :each | each instanceSide. ].
	classes addAll: (Smalltalk allClasses collect: [ :each | each classSide. ]).
	(self defaultOrFiltersAt: #class) do: [
		:filter |
		classes _ classes select: [
			:each |
			self class: each matches: filter.
		].
	].
	^ classes.! !

!DALink methodsFor: 'filtering' stamp: 'as 2/8/2008 11:18'!
filterMethod
	
	| methods classMethods |
	
	methods _ Set new.
	(self cacheAt: #class) do: [
		:each |
		classMethods _ each methods.
		(self defaultOrFiltersAt: #method) do: [
			:filter |
			classMethods _ classMethods select: [
				:method |
				filter matches: method selector.
			].
		].
		methods addAll: classMethods.
	].
	^ methods collect: [ :each | each reflectiveMethod. ].! !

!DALink methodsFor: 'filtering' stamp: 'as 2/4/2008 17:27'!
filterNode

	| nodes methodNodes |

	nodes _ Set new.
	(self cacheAt: #method) do: [
		:each |
		methodNodes _ each nodes.
		(self defaultOrFiltersAt: #node) do: [
			:filter |
			methodNodes _ methodNodes select: filter.
		].
		nodes addAll: methodNodes.
	].
	^ nodes.! !

!DALink methodsFor: 'accessing' stamp: 'as 2/4/2008 16:58'!
filtersAt: aSymbol

	^ filters at: aSymbol.! !

!DALink methodsFor: 'accessing' stamp: 'as 2/4/2008 17:00'!
filtersAt: aSymbol put: aCollection

	filters at: aSymbol put: aCollection.
	self reset.! !

!DALink methodsFor: 'testing' stamp: 'as 1/27/2008 17:19'!
hasCondition

	^ link hasCondition.! !

!DALink methodsFor: 'initialize-release' stamp: 'as 2/4/2008 15:49'!
initialize

	link _ GPLink new.
	filters _ Dictionary new.
	cache _ Dictionary new.
	self initializeFilters.
	self initializeCache.! !

!DALink methodsFor: 'initialize-release' stamp: 'as 2/4/2008 17:31'!
initializeCache

	self keys do: [
		:key |
		cache at: key put: nil.
	].! !

!DALink methodsFor: 'initialize-release' stamp: 'as 2/4/2008 16:00'!
initializeFilters

	self keys do: [
		:key |
		filters at: key put: Set new.
	].! !

!DALink methodsFor: 'initialize-release' stamp: 'as 2/4/2008 16:00'!
keys

	^ #(category class method node).! !

!DALink methodsFor: 'accessing' stamp: 'as 1/24/2008 17:38'!
link

	^ link.! !

!DALink methodsFor: 'aliases' stamp: 'as 2/8/2008 11:55'!
method: aRegexFilter

	self filterAt: #method put: aRegexFilter.! !

!DALink methodsFor: 'aliases' stamp: 'as 2/4/2008 17:48'!
methods

	^ self cacheAt: #method.! !

!DALink methodsFor: 'aliases' stamp: 'as 2/4/2008 17:47'!
node: aBlock

	self filterAt: #node put: aBlock.! !

!DALink methodsFor: 'aliases' stamp: 'as 2/4/2008 17:48'!
nodes

	^ self cacheAt: #node.! !

!DALink methodsFor: 'caching' stamp: 'as 2/4/2008 15:50'!
reset

	self initializeCache.! !

Object subclass: #DAPointcut
	instanceVariableNames: 'parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DAPointcut commentStamp: 'as 1/17/2008 14:11' prior: 0!
Pointcuts describe a set of join points. So far, the only type of join points are nodes in reflective methods.!

DAPointcut subclass: #DACompositePointcut
	instanceVariableNames: 'children'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DACompositePointcut commentStamp: 'as 2/8/2008 11:26' prior: 0!
A composition of two pointcuts.!

DACompositePointcut subclass: #DAAndPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DAAndPointcut commentStamp: 'as 1/31/2008 17:05' prior: 0!
Selects all join points that fullfill all requirements of two pointcuts.!

!DAAndPointcut methodsFor: 'inverting' stamp: 'as 2/5/2008 15:42'!
invert

	^ DAOrPointcut children: children.! !

!DAAndPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:04'!
visitName

	^ 'and'.! !

!DACompositePointcut class methodsFor: 'instance creation' stamp: 'as 1/24/2008 16:31'!
child: aDAPointcut1 child: aDAPointcut2

	^ self new children: (Array with: aDAPointcut1 with: aDAPointcut2); yourself.! !

!DACompositePointcut class methodsFor: 'instance creation' stamp: 'as 2/5/2008 15:42'!
children: aCollection

	^ self new children: aCollection; yourself.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 2/1/2008 14:36'!
children: aSequenceableCollection

	children _ aSequenceableCollection.
	children do: [ :each | each parent: self. ].! !

!DACompositePointcut methodsFor: 'inverting' stamp: 'as 2/8/2008 10:36'!
invert

	self subclassResponsibility.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 1/25/2008 14:30'!
left

	^ children first.! !

!DACompositePointcut methodsFor: 'inverting' stamp: 'as 2/5/2008 15:40'!
not

	| inverted |

	children do: [ :child | child not. ].
	inverted _ self invert.
	self hasParent ifTrue: [ parent replace: self with: inverted. ].
	^ inverted.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 2/4/2008 21:32'!
replace: oldDAPointcut with: newDAPointcut

	children replaceAll: oldDAPointcut with: newDAPointcut.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 1/25/2008 14:31'!
right

	^ children last.! !

DACompositePointcut subclass: #DAOrPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DAOrPointcut commentStamp: 'as 1/31/2008 17:06' prior: 0!
Selects all join points that fullfill either's pointcut requirements.!

!DAOrPointcut methodsFor: 'inverting' stamp: 'as 2/5/2008 15:42'!
invert

	^ DAAndPointcut children: children.! !

!DAOrPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:03'!
visitName

	^ 'or'.! !

DAPointcut subclass: #DADesignatePointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DADesignatePointcut commentStamp: 'as 1/24/2008 15:45' prior: 0!
Designates join points in the system.!

DADesignatePointcut subclass: #DAConditionPointcut
	instanceVariableNames: 'condition'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DAConditionPointcut commentStamp: 'as 1/24/2008 15:52' prior: 0!
Describes conditional attributes.!

!DAConditionPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:22'!
condition: aBlockOrBoolean

	^ self new condition: aBlockOrBoolean; yourself.! !

!DAConditionPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:23'!
condition: aBlockOrBoolean arguments: aCollection

	^ self new condition: aBlockOrBoolean arguments: aCollection; yourself.! !

!DAConditionPointcut methodsFor: 'accessing' stamp: 'as 2/1/2008 14:31'!
condition

	^ condition.! !

!DAConditionPointcut methodsFor: 'designating' stamp: 'as 1/27/2008 19:48'!
condition: aBlockOrBoolean

	condition _ DACondition with: aBlockOrBoolean.! !

!DAConditionPointcut methodsFor: 'designating' stamp: 'as 1/24/2008 16:55'!
condition: aBlockOrBoolean arguments: aCollection

	condition _ DACondition with: aBlockOrBoolean arguments: aCollection.! !

!DAConditionPointcut methodsFor: 'inverting' stamp: 'as 2/8/2008 10:40'!
not

	condition not.! !

!DAConditionPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:04'!
visitName

	^ 'condition'.! !

DAConditionPointcut subclass: #DAControlFlowPointcut
	instanceVariableNames: 'selector classKey isMeta level'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DAControlFlowPointcut commentStamp: 'as 2/1/2008 11:31' prior: 0!
The join points must be within a specific method call.!

!DAControlFlowPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:32'!
condition: aBlockOrBoolean

	self shouldNotImplement.! !

!DAControlFlowPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:32'!
condition: aBlockOrBoolean arguments: aCollection

	self shouldNotImplement.! !

!DAControlFlowPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 14:30'!
method: aMethod

	^ self new method: aMethod; yourself.! !

!DAControlFlowPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 14:30'!
method: aMethod level: anInteger

	anInteger > 1 ifFalse: [ self error: 'the nesting level must be greater than 1'. ].
	^ self new method: aMethod level: anInteger; yourself.! !

!DAControlFlowPointcut methodsFor: 'private' stamp: 'as 2/4/2008 10:43'!
conditionBlock

	^ [
		:args |
		| context m nesting result |
		context _ (args at: #context) sender.
		m _ self method.
		nesting _ 1.
		result _ false.
		[ (level isNil or: [ nesting <= level. ]) & (context notNil) & result not. ] whileTrue: [
			context method reflectiveMethod = m ifTrue: [ result _ true. ].
			context _ context sender.
		].
		result.
	].! !

!DAControlFlowPointcut methodsFor: 'initialize-release' stamp: 'as 2/6/2008 20:07'!
initialize

	super initialize.
	condition _ DACondition with: self conditionBlock arguments: #(context).! !

!DAControlFlowPointcut methodsFor: 'accessing' stamp: 'as 2/1/2008 13:27'!
level: anInteger

	level _ anInteger.! !

!DAControlFlowPointcut methodsFor: 'accessing' stamp: 'as 2/2/2008 11:08'!
method

	| class |

	class _ Smalltalk at: classKey.
	isMeta ifTrue: [ class _ class classSide. ].
	^ (class >> selector) reflectiveMethod.! !

!DAControlFlowPointcut methodsFor: 'accessing' stamp: 'as 2/2/2008 11:07'!
method: aMethod

	selector _ aMethod selector.
	classKey _ aMethod methodClass instanceSide name.
	isMeta _ aMethod methodClass isMeta.! !

DADesignatePointcut subclass: #DAFilterPointcut
	instanceVariableNames: 'filter inverted'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DAFilterPointcut commentStamp: 'as 1/31/2008 16:58' prior: 0!
Specifies a filter for designating join points.!

DAFilterPointcut subclass: #DACategoryPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DACategoryPointcut commentStamp: 'as 1/31/2008 16:39' prior: 0!
Filter for categories.!

!DACategoryPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:20'!
category: aSymbol

	^ self filter: aSymbol.! !

!DACategoryPointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:29'!
visitName

	^ 'category'.! !

DAFilterPointcut subclass: #DAClassPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DAClassPointcut commentStamp: 'as 1/31/2008 16:40' prior: 0!
Filter for classes.!

!DAClassPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:20'!
class: aClass

	^ self filter: aClass name.! !

!DAClassPointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:46'!
visitName

	^ 'class'.! !

!DAFilterPointcut class methodsFor: 'instance creation' stamp: 'as 2/8/2008 11:25'!
filter: regexOrFilter

	^ self new filter: regexOrFilter; yourself.! !

!DAFilterPointcut methodsFor: 'accessing' stamp: 'as 1/31/2008 16:59'!
filter

	^ filter.! !

!DAFilterPointcut methodsFor: 'accessing' stamp: 'as 2/11/2008 08:12'!
filter: regexString

	filter _ regexString asRegexFilter.! !

!DAFilterPointcut methodsFor: 'inverting' stamp: 'as 2/11/2008 08:46'!
not

	filter negate.! !

DAFilterPointcut subclass: #DAMethodPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DAMethodPointcut commentStamp: 'as 1/31/2008 16:42' prior: 0!
Filter for methods.!

!DAMethodPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:25'!
method: aMethod

	^ self filter: aMethod selector.! !

!DAMethodPointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:47'!
visitName

	^ 'method'.! !

DADesignatePointcut subclass: #DANodePointcut
	instanceVariableNames: 'condition inverted'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DANodePointcut commentStamp: 'as 1/31/2008 16:41' prior: 0!
Filter the nodes within a reflective method (sub-method level).!

!DANodePointcut class methodsFor: 'instance creation' stamp: 'as 2/8/2008 11:34'!
condition: aBlock

	^ self new condition: aBlock; yourself.! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 2/8/2008 11:37'!
condition

	inverted ifTrue: [ ^ self invertedBlock. ] ifFalse: [ ^ condition. ].! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 2/8/2008 11:34'!
condition: aBlock

	condition _ aBlock.! !

!DANodePointcut methodsFor: 'initialize-release' stamp: 'as 2/8/2008 11:32'!
initialize

	inverted _ false.! !

!DANodePointcut methodsFor: 'private' stamp: 'as 2/8/2008 11:37'!
invertedBlock

	^ [ :arg | (condition value: arg) not. ].! !

!DANodePointcut methodsFor: 'inverting' stamp: 'as 2/8/2008 11:33'!
not

	inverted _ inverted not.! !

!DANodePointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:48'!
visitName

	^ 'node'.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:20'!
category: aSymbol

	^ DACategoryPointcut category: aSymbol.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 1/31/2008 17:17'!
categoryName: regexString

	^ DACategoryPointcut filter: regexString.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 13:29'!
cflow: aMethod

	^ DAControlFlowPointcut method: aMethod.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 13:31'!
cflow: aMethod level: anInteger

	^ DAControlFlowPointcut method: aMethod level: anInteger.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:20'!
class: aClass

	^ DAClassPointcut class: aClass.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 1/31/2008 17:17'!
className: regexString

	^ DAClassPointcut filter: regexString.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:23'!
if: aBlockOrBoolean

	^ DAConditionPointcut condition: aBlockOrBoolean.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:24'!
if: aBlockOrBoolean arguments: aCollection

	^ DAConditionPointcut condition: aBlockOrBoolean arguments: aCollection.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:25'!
method: aMethod

	^ (DAClassPointcut class: aMethod methodClass) and: (DAMethodPointcut method: aMethod).! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 1/31/2008 17:17'!
methodName: regexString

	^ DAMethodPointcut filter: regexString.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 1/31/2008 17:18'!
node: aBlock

	^ DANodePointcut filter: aBlock.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 13:30'!
within: aMethod

	^ DAControlFlowPointcut method: aMethod level: 1.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:00'!
acceptVisitor: aDAPointcutVisitor

	aDAPointcutVisitor perform: ('visit', self visitName capitalized, ':') asSymbol with: self.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 1/24/2008 16:32'!
and: aDAPointcut

	^ DAAndPointcut child: self child: aDAPointcut.! !

!DAPointcut methodsFor: 'testing' stamp: 'as 2/4/2008 21:16'!
hasParent

	^ parent notNil.! !

!DAPointcut methodsFor: 'inverting' stamp: 'as 2/4/2008 21:33'!
not

	self subclassResponsibility.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 1/24/2008 16:32'!
or: aDAPointcut

	^ DAOrPointcut child: self child: aDAPointcut.! !

!DAPointcut methodsFor: 'accessing' stamp: 'as 1/17/2008 16:56'!
parent

	^ parent.! !

!DAPointcut methodsFor: 'accessing' stamp: 'as 1/17/2008 16:56'!
parent: aDACompositePointcut

	parent _ aDACompositePointcut.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:00'!
visitName

	self subclassResponsibility.! !

Object subclass: #DAPointcutVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DAPointcutVisitor commentStamp: 'as 1/24/2008 17:04' prior: 0!
Visit a pointcut structure.!

DAPointcutVisitor subclass: #DALinkGenerator
	instanceVariableNames: 'links stack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut'!

!DALinkGenerator commentStamp: 'as 1/24/2008 17:14' prior: 0!
Goes over a pointcut structure and prepares Geppetto links for it.!

!DALinkGenerator methodsFor: 'initialize-release' stamp: 'as 1/25/2008 14:06'!
initialize

	self initializeVariables.
	stack _ Stack new.! !

!DALinkGenerator methodsFor: 'initialize-release' stamp: 'as 1/27/2008 16:18'!
initializeVariables

	links _ OrderedCollection new.! !

!DALinkGenerator methodsFor: 'accessing' stamp: 'as 2/1/2008 14:21'!
links

	^ links.! !

!DALinkGenerator methodsFor: 'stacking' stamp: 'as 1/25/2008 14:35'!
pop

	^ stack pop.! !

!DALinkGenerator methodsFor: 'stacking' stamp: 'as 1/27/2008 16:23'!
push

	stack push: links.
	self initializeVariables.! !

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 1/27/2008 17:07'!
visitAnd: pc

	pc left acceptVisitor: self.
	self push.
	pc right acceptVisitor: self.
	self push.
	self pop do: [
		:leftLink |
		self pop do: [
			:rightLink |
			links add: (leftLink and: rightLink).
		].
	].! !

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 1/31/2008 10:59'!
visitCategory: pc

	links add: (DALink new category: pc filter).! !

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 1/31/2008 10:59'!
visitClass: pc

	links add: (DALink new class: pc filter).! !

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 1/31/2008 10:54'!
visitCondition: pc

	links add: (DALink new condition: pc condition).! !

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 1/31/2008 10:59'!
visitMethod: pc

	links add: (DALink new method: pc filter).! !

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 2/8/2008 11:40'!
visitNode: pc

	links add: (DALink new node: pc condition).! !

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 1/27/2008 16:23'!
visitOr: pc

	pc left acceptVisitor: self.
	self push.
	pc right acceptVisitor: self.
	links addAll: self pop.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/24/2008 17:15'!
visit: aDAPointcut

	aDAPointcut acceptVisitor: self.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/24/2008 17:17'!
visitAnd: aDAAndPointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/28/2008 08:49'!
visitCategory: aDACategoryPointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/28/2008 08:49'!
visitClass: aDAClassPointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/24/2008 17:17'!
visitCondition: aDAConditionPointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/28/2008 08:49'!
visitMethod: aDAMethodPointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/24/2008 17:17'!
visitNode: aDANodePointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/24/2008 17:17'!
visitOr: aDAOrPointcut

	self subclassResponsibility.! !

Object subclass: #DARegexFilter
	instanceVariableNames: 'regex negated'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Utilities'!

!DARegexFilter commentStamp: 'as 2/8/2008 13:56' prior: 0!
A regular expression (string) with an attribute that indicates if it is negated or not.!

!DARegexFilter class methodsFor: 'instance creation' stamp: 'as 2/8/2008 13:48'!
new: regexString

	^ self new regex: regexString; yourself.! !

!DARegexFilter methodsFor: 'initialize-release' stamp: 'as 2/8/2008 10:58'!
initialize

	negated _ false.! !

!DARegexFilter methodsFor: 'testing' stamp: 'as 2/8/2008 10:58'!
isNegated

	^ negated.! !

!DARegexFilter methodsFor: 'regex' stamp: 'as 2/11/2008 10:10'!
matches: aString

	| match |

	match _ regex match: aString.
	self isNegated ifTrue: [ match _ match not. ].
	^ match.! !

!DARegexFilter methodsFor: 'negating' stamp: 'as 2/11/2008 08:46'!
negate

	negated _ negated not.! !

!DARegexFilter methodsFor: 'accessing' stamp: 'as 2/8/2008 13:53'!
regex

	^ regex.! !

!DARegexFilter methodsFor: 'accessing' stamp: 'as 2/8/2008 13:53'!
regex: regexString

	regex _ regexString.! !

Object subclass: #DATest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Testing'!

!DATest commentStamp: 'as 2/1/2008 10:56' prior: 0!
Things that can't be tested in a workspace.!

!DATest class methodsFor: 'as yet unclassified' stamp: 'as 2/1/2008 11:12'!
context1

	^ self context2.! !

!DATest class methodsFor: 'as yet unclassified' stamp: 'as 2/1/2008 11:12'!
context2

	^ self context3.! !

!DATest class methodsFor: 'as yet unclassified' stamp: 'as 2/1/2008 11:12'!
context3

	^ thisContext.! !

GPCondition subclass: #DACondition
	instanceVariableNames: 'negated'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Geppetto'!

!DACondition commentStamp: 'as 2/4/2008 10:35' prior: 0!
Used instead of GPCondition. The GPTransformer will pass a single argument, which contains all reification arguments in a dictionary. This allows easier combination of blocks and thus conditions. It is difficult to combine blocks with variable number of arguments.!

!DACondition class methodsFor: 'instance creation' stamp: 'as 1/24/2008 12:24'!
with: aBlockOrBoolean

	^ self with: aBlockOrBoolean arguments: nil.! !

!DACondition class methodsFor: 'instance creation' stamp: 'as 1/21/2008 11:47'!
with: aBlockOrBoolean arguments: aCollection

	^ self new
		condition: aBlockOrBoolean;
		arguments: aCollection;
		yourself.! !

!DACondition methodsFor: 'composing' stamp: 'as 2/8/2008 10:26'!
and: aDACondition

	(self condition = true) | (aDACondition condition = false) ifTrue: [ ^ aDACondition. ].
	(aDACondition condition = true) | (self condition = false) ifTrue: [ ^ self. ].
	^ self combineWith: aDACondition using: #&.! !

!DACondition methodsFor: 'accessing' stamp: 'as 2/4/2008 10:32'!
arguments

	arguments ifNotNil: [ ^ arguments. ].
	^ #().! !

!DACondition methodsFor: 'private' stamp: 'as 1/24/2008 11:56'!
combineBlock: firstBlock args: firstCollection withBlock: secondBlock args: secondCollection using: aSymbol

	^ [
		:args |
		| args1 args2 |
		
		args1 _ args associationsSelect: [ :asc | firstCollection includes: asc key. ].
		args2 _ args associationsSelect: [ :asc | secondCollection includes: asc key. ].
		(firstBlock value: args1) perform: aSymbol with: (secondBlock value: args2).
	].! !

!DACondition methodsFor: 'private' stamp: 'as 1/27/2008 19:09'!
combineWith: aDACondition using: aSymbol

	| block args |
	
	block _ self
		combineBlock: condition
		args: self arguments
		withBlock: aDACondition condition
		args: aDACondition arguments
		using: aSymbol.
	args _ self arguments union: aDACondition arguments.
	^ self class with: block arguments: args.! !

!DACondition methodsFor: 'accessing' stamp: 'as 2/8/2008 10:25'!
condition

	negated ifTrue: [ ^ self negatedCondition. ].
	^ condition.! !

!DACondition methodsFor: 'testing' stamp: 'as 1/24/2008 12:16'!
hasArguments

	^ arguments notNil.! !

!DACondition methodsFor: 'initialize-release' stamp: 'as 2/8/2008 10:21'!
initialize

	negated _ false.! !

!DACondition methodsFor: 'private' stamp: 'as 2/8/2008 10:27'!
negatedCondition

	^ [ :args | (condition value: args) not. ].! !

!DACondition methodsFor: 'negating' stamp: 'as 2/8/2008 10:21'!
not

	negated _ negated not.! !

!DACondition methodsFor: 'accessing' stamp: 'as 1/24/2008 12:15'!
reifications

	^ self arguments.! !

!GPLink methodsFor: '*DynamicAspects' stamp: 'as 12/12/2007 15:55'!
aspect

	properties ifNil: [ ^ nil. ].
	^self properties at: #aspect ifAbsent: [ nil. ].! !

!GPLink methodsFor: '*DynamicAspects' stamp: 'as 12/12/2007 15:54'!
aspect: aDAAspect

	self properties at: #aspect put: aDAAspect.! !

!GPLink methodsFor: '*DynamicAspects' stamp: 'as 1/25/2008 11:58'!
conditionObject: aGPCondition

	condition _ aGPCondition.! !

!GPTransformer methodsFor: '*DynamicAspects' stamp: 'as 1/14/2008 16:28'!
genConditionArgumentsFor: aCollection

	| messages dictionary |
	
	messages _ OrderedCollection new.
	dictionary _ RBMessageNode
		receiver: (RBGlobalVariableNode named: 'Dictionary')
		selector: #new.
	aCollection do: [
		:reification |
		| arguments |
		arguments _ OrderedCollection new.
		arguments add: (RBLiteralNode value: reification).
		arguments add: (table at: reification).
		messages add: (
			RBMessageNode
				receiver: dictionary
				selector: #at:put:
				arguments: arguments
		).
	].
	messages add: (RBMessageNode receiver: dictionary selector: #yourself).
	^ OrderedCollection new add: (RBCascadeNode messages: messages); yourself.! !

!GPTransformer methodsFor: '*DynamicAspects' stamp: 'as 1/21/2008 08:52'!
transform
	"Main transformation method"

	| newNode |
	(link isInlineCondition and: [link condition condition = false]) ifTrue: [^self]. "nothing to do..."
	self setupTable.
	link hasCondition ifFalse: [self addPreamble: node].
	self genInitialHook.
	self patchArguments.
	(link condition isKindOf: DACondition) ifTrue: [
		self wrapSingleArgCondition.
	] ifFalse: [
		self wrapCondition.
	].
	self wrapContext.
	link requestsContinuation ifTrue: [self wrapContinuation].
	link requestsResult ifTrue: [self wrapResult].
	newNode _ self insertCode.
	newNode ifNotNil: [node _ newNode].! !

!GPTransformer methodsFor: '*DynamicAspects' stamp: 'as 1/21/2008 08:53'!
wrapSingleArgCondition
	
	|  ifSelector ifArguments condReceiver condSelector condArguments blockBody blockBody2 |
	
	link hasCondition ifFalse: [^self]. "no condition"
	(link isInlineCondition and: [link condition condition = true]) ifTrue: [^self].  "no condition needed"
	
	condReceiver _ (link isInlineCondition ifTrue: [link condition condition] ifFalse: [link]) asLiteralNode.
	condSelector _ self genSelectorFor: link condition condition.
	
	(condSelector numArgs = 0) ifTrue: [condArguments  _ #()].
	(condSelector numArgs > 0) ifTrue: [
			condArguments _ self genConditionArgumentsFor: link condition reifications.
	].
													
	ifSelector _  link isInstead ifTrue: [#ifTrue:ifFalse:] ifFalse:[#ifTrue:].
	
	blockBody _ hook asSequenceNode.
	self addPreamble: hook.
	
	blockBody2 _ (node isKindOf: RBMethodNode) ifTrue: [node body] ifFalse: [node copy asSequenceNode].
	
	ifArguments _ link isInstead
				ifTrue: [{RBBlockNode body: blockBody. RBBlockNode body: blockBody2 }]
				ifFalse: [{RBBlockNode body: blockBody}].		
	
	hook _ RBMessageNode
			receiver: (RBMessageNode 
							receiver: condReceiver
							selector: condSelector
							arguments: condArguments)
			selector: ifSelector
			arguments: ifArguments.
	! !

!Collection methodsFor: '*DynamicAspects' stamp: 'as 1/31/2008 15:23'!
selfIfEmpty: aBlock

	self isEmpty ifTrue: [ ^ aBlock value. ] ifFalse: [ ^ self. ].! !

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

TestCase subclass: #DAConditionTest
	instanceVariableNames: 'trueCond falseCond blockCond'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Geppetto-Tests'!

!DAConditionTest commentStamp: 'as 1/27/2008 17:41' prior: 0!
Testing DACondition.!

!DAConditionTest methodsFor: 'running' stamp: 'as 1/27/2008 19:33'!
setUp

	trueCond _ DACondition with: true.
	falseCond _ DACondition with: false.
	blockCond _ DACondition with: [ :args | true. ].! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 1/27/2008 19:28'!
testCombiningBlocks

	| cond1 cond2 combCond blockArgs |
	
	cond1 _ DACondition
		with: [ :args | args includesKey: #arg1. ]
		arguments: #(arg1).
	cond2 _ DACondition
		with: [ :args | args includesKey: #arg2. ]
		arguments: #(arg2).
	combCond _ cond1 and: cond2.
	self assert: combCond arguments size = 2.
	self assert: (combCond arguments includes: #arg1).
	self assert: (combCond arguments includes: #arg2).
	blockArgs _ Dictionary new at: #arg1 put: nil; at: #arg2 put: nil; yourself.
	self assert: (combCond value: blockArgs).! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 1/27/2008 18:58'!
testCombiningBooleanWithBlock

	| combCond |
	
	blockCond arguments: #(object class).
	combCond _ trueCond and: blockCond.
	self assert: combCond arguments = blockCond arguments.
	self assert: combCond condition = blockCond condition.
	combCond _ blockCond and: falseCond.
	self assert: combCond condition = false.! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 1/27/2008 17:56'!
testCombiningBooleans

	self assert: (trueCond and: falseCond) condition = false.
	self assert: (falseCond and: trueCond) condition = false.
	self assert: (falseCond and: falseCond) condition = false.
	self assert: (trueCond and: trueCond) condition = true.! !

TestCase subclass: #DALinkTest
	instanceVariableNames: 'link'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Geppetto-Tests'!

!DALinkTest commentStamp: 'as 1/31/2008 14:14' prior: 0!
Testing DALink.!

!DALinkTest methodsFor: 'running' stamp: 'as 1/31/2008 14:17'!
setUp

	link _ DALink new.! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/11/2008 08:17'!
testAndingLinks

	| link2 link3 |

	link
		category: 'DynamicAspects-Geppetto-Tests' asRegexFilter;
		class: 'DALinkTest' asRegexFilter.
	link2 _ DALink new
		method: 'testAndingLinks' asRegexFilter;
		node: [ :node | node isMethodNode. ];
		yourself.
	link3 _ link and: link2.
	self assert: (link3 methods includes: (DALinkTest >> #testAndingLinks) reflectiveMethod).! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/11/2008 10:05'!
testFilteringCategories

	link category: 'DynamicAspects*' asRegexFilter.
	self assert: (link categories includes: #'DynamicAspects-Geppetto-Tests').! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/11/2008 08:18'!
testFilteringClasses

	link category: 'DynamicAspects-Geppetto-Tests' asRegexFilter; class: 'DALinkTest' asRegexFilter.
	self assert: (link classes includes: DALinkTest).! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/11/2008 08:18'!
testFilteringMethods

	link
		category: 'DynamicAspects-Geppetto-Tests' asRegexFilter;
		class: 'DALinkTest' asRegexFilter;
		method: 'testFilteringMethods' asRegexFilter.
	self assert: (link methods includes: (DALinkTest >> #testFilteringMethods) reflectiveMethod).! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/11/2008 08:19'!
testFilteringNodes

	link
		category: 'DynamicAspects-Geppetto-Tests' asRegexFilter;
		class: 'DALinkTest' asRegexFilter;
		method: 'testFilteringNodes' asRegexFilter;
		node: [ :node | node isCascade. ].
	self assert: (link nodes size = 1).! !

TestCase subclass: #DARegexFilterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Utilities-Tests'!

!DARegexFilterTest commentStamp: 'as 2/11/2008 08:40' prior: 0!
Testing DARegexFilter.!

!DARegexFilterTest methodsFor: 'testing' stamp: 'as 2/11/2008 08:47'!
testNegation

	| filter |

	filter _ 'abc' asRegexFilter.
	self assert: (filter matches: 'abc').
	filter negate.
	self deny: (filter matches: 'abc').! !

TestCase subclass: #DATestingWithLinks
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DATestingWithLinks commentStamp: 'as 2/1/2008 13:57' prior: 0!
A test that uses Geppetto links.

This provides link cleanup at start/finish for any subclassed test.!

DATestingWithLinks subclass: #DAAspectTest
	instanceVariableNames: 'example aspect'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel-Tests'!

!DAAspectTest commentStamp: 'as 8/14/2007 10:30' prior: 0!
Testing DAAspect.!

!DAAspectTest methodsFor: 'running' stamp: 'as 2/1/2008 14:14'!
setUp

	super setUp.
	self removeAllLinksOn: DAExamples.
	DAExamples initializeCounter.
	DATestAspect instance install.! !

!DAAspectTest methodsFor: 'running' stamp: 'as 2/1/2008 14:14'!
tearDown

	super tearDown.
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

DATestingWithLinks subclass: #DAControlFowPointcutTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcut-Tests'!

!DAControlFowPointcutTest commentStamp: 'as 2/1/2008 13:32' prior: 0!
Testing DAControlFlowPointcut.!

!DAControlFowPointcutTest methodsFor: 'running' stamp: 'as 2/1/2008 14:12'!
setUp

	super setUp.
	self removeAllLinksOn: DAExamples.! !

!DAControlFowPointcutTest methodsFor: 'running' stamp: 'as 2/1/2008 14:13'!
tearDown

	super tearDown.
	self removeAllLinksOn: DAExamples.! !

!DAControlFowPointcutTest methodsFor: 'testing' stamp: 'as 2/1/2008 15:40'!
testSimple

	| pc visitor link asserted |
	pc _ (DAPointcut cflow: DAExamples class >> #outer) and:
		(DAPointcut method: DAExamples class >> #inner).
	visitor _ DALinkGenerator new.
	visitor visit: pc.
	self assert: visitor links size = 1.
	link _ visitor links first.
	link link metaObject: [ asserted _ true. ].
	link nodes do: [ :each | each link: link link. ].
	asserted _ false.
	DAExamples outer.
	self assert: asserted.! !

DATestingWithLinks subclass: #DAGeppettoTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Geppetto-Tests'!

!DAGeppettoTests commentStamp: 'as 1/14/2008 16:36' prior: 0!
Additional test for Geppetto.!

!DAGeppettoTests methodsFor: 'running' stamp: 'as 2/1/2008 14:15'!
setUp

	super setUp.
	self removeAllLinksOn: DAGeppettoExamples.! !

!DAGeppettoTests methodsFor: 'running' stamp: 'as 2/1/2008 14:15'!
tearDown

	super tearDown.
	self removeAllLinksOn: DAGeppettoExamples.! !

!DAGeppettoTests methodsFor: 'testing' stamp: 'as 2/1/2008 10:09'!
testArgumentListCondition

	| link asserted condition |
	asserted _ false.
	link _ GPLink metaObject: [ asserted _ true. ].
	link before.
	condition _ DACondition
		with: [ :args | (args at: #object) = DAGeppettoExamples. ]
		arguments: #(object).
	link conditionObject: condition.
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

!DATestingWithLinks methodsFor: 'running' stamp: 'as 2/1/2008 13:58'!
removeAllLinksOn: aClass

	aClass methodDict values, aClass class methodDict values do: [
		:method |
		method reflectiveMethod methodNode nodesDo: [
			:node |
			node hasAnyLink ifTrue: [ node removeAllLinks. ].
			self assert: node hasAnyLink not.
		].
	].! !
