SystemOrganization addCategory: #'DynamicAspects-Pointcuts'!
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

Object subclass: #DALink
	instanceVariableNames: 'link nodes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Geppetto'!

!DALink commentStamp: 'as 1/24/2008 17:27' prior: 0!
Host a GPLink together with the nodes it should be installed on.!

!DALink class methodsFor: 'instance creation' stamp: 'as 1/25/2008 11:17'!
nodes: aCollection

	^ self new nodes: aCollection; yourself.! !

!DALink class methodsFor: 'instance creation' stamp: 'as 1/25/2008 15:23'!
nodes: aCollection condition: aDACondition

	^ self new nodes: aCollection; condition: aDACondition; yourself.! !

!DALink methodsFor: 'accessing' stamp: 'as 1/25/2008 11:53'!
condition: aDACondition

	self shouldBeImplemented.! !

!DALink methodsFor: 'initialize-release' stamp: 'as 1/24/2008 17:35'!
initialize

	link _ GPLink new.
	nodes _ OrderedCollection new.! !

!DALink methodsFor: 'accessing' stamp: 'as 1/24/2008 17:38'!
link

	^ link.! !

!DALink methodsFor: 'accessing' stamp: 'as 1/25/2008 11:17'!
nodes

	^ nodes.! !

!DALink methodsFor: 'accessing' stamp: 'as 1/25/2008 11:16'!
nodes: aCollection

	nodes _ aCollection.! !

Object subclass: #DAPointcut
	instanceVariableNames: 'parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAPointcut commentStamp: 'as 1/17/2008 14:11' prior: 0!
Pointcuts describe a set of join points. So far, the only type of join points are nodes in reflective methods.!

DAPointcut subclass: #DACompositePointcut
	instanceVariableNames: 'children'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DACompositePointcut commentStamp: 'as 1/17/2008 11:30' prior: 0!
A composition of one or two pointcuts.!

DACompositePointcut subclass: #DAAndPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAAndPointcut commentStamp: 'as 1/18/2008 10:40' prior: 0!
Returns the intersecting join points of two pointcuts.!

!DAAndPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:04'!
visitName

	^ 'and'.! !

!DACompositePointcut class methodsFor: 'instance creation' stamp: 'as 1/24/2008 16:31'!
child: aDAPointcut1 child: aDAPointcut2

	^ self new children: (Array with: aDAPointcut1 with: aDAPointcut2); yourself.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 1/24/2008 16:29'!
children: aSequenceableCollection

	children _ aSequenceableCollection.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 1/25/2008 14:30'!
left

	^ children first.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 1/25/2008 14:31'!
right

	^ children last.! !

DACompositePointcut subclass: #DAOrPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAOrPointcut commentStamp: 'as 1/18/2008 10:54' prior: 0!
Returns the unified join points of two pointcuts.!

!DAOrPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:03'!
visitName

	^ 'or'.! !

DAPointcut subclass: #DADesignatePointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DADesignatePointcut commentStamp: 'as 1/24/2008 15:45' prior: 0!
Designates join points in the system.!

DADesignatePointcut subclass: #DAConditionPointcut
	instanceVariableNames: 'condition'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAConditionPointcut commentStamp: 'as 1/24/2008 15:52' prior: 0!
Describes conditional attributes.!

!DAConditionPointcut methodsFor: 'designating' stamp: 'as 1/24/2008 16:56'!
condition: aBlockOrBoolean

	self condition: aBlockOrBoolean arguments: nil.! !

!DAConditionPointcut methodsFor: 'designating' stamp: 'as 1/24/2008 16:55'!
condition: aBlockOrBoolean arguments: aCollection

	condition _ DACondition with: aBlockOrBoolean arguments: aCollection.! !

!DAConditionPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:04'!
visitName

	^ 'condition'.! !

DADesignatePointcut subclass: #DANodePointcut
	instanceVariableNames: 'filters'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DANodePointcut commentStamp: 'as 1/24/2008 16:38' prior: 0!
Selects specific join points (nodes in reflective methods) in the system.!

!DANodePointcut methodsFor: 'filtering' stamp: 'as 1/24/2008 16:43'!
categories

	self categoryFilter ifNil: [
		^ #().
	] ifNotNil: [
		^ SystemOrganization categories select: [
			:each | each matchesRegex: self categoryFilter.
		].
	].! !

!DANodePointcut methodsFor: 'designating' stamp: 'as 1/24/2008 16:46'!
category: regexString

	self categoryFilter: regexString.
	self reset.! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 1/24/2008 16:40'!
categoryFilter

	^ filters at: #category ifAbsent: [ nil. ].! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 1/24/2008 16:48'!
categoryFilter: regexString

	filters at: #category put: regexString.! !

!DANodePointcut methodsFor: 'designating' stamp: 'as 1/24/2008 16:46'!
class: regexString

	self classFilter: regexString.
	self reset.! !

!DANodePointcut methodsFor: 'filtering' stamp: 'as 1/24/2008 16:41'!
class: aClass matches: regexString

	^ (aClass name matchesRegex: regexString) and: [
		self categories includes: aClass instanceSide category.
	].! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 1/24/2008 16:40'!
classFilter

	^ filters at: #class ifAbsent: [ nil. ].! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 1/24/2008 16:48'!
classFilter: regexString

	filters at: #class put: regexString.! !

!DANodePointcut methodsFor: 'filtering' stamp: 'as 1/24/2008 16:44'!
classes

	self classFilter ifNil: [
		^ #().
	] ifNotNil: [
		^ Smalltalk allClasses select: [
			:each |
			(self class: each instanceSide matches: self classFilter)
				or: [ self class: each classSide matches: self classFilter. ].
		].
	].! !

!DANodePointcut methodsFor: 'initialize-release' stamp: 'as 1/24/2008 16:39'!
initialize

	filters _ Dictionary new.! !

!DANodePointcut methodsFor: 'designating' stamp: 'as 1/24/2008 16:46'!
method: regexString

	self methodFilter: regexString.
	self reset.! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 1/24/2008 16:41'!
methodFilter

	^ filters at: #method ifAbsent: [ nil. ].! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 1/24/2008 16:48'!
methodFilter: regexString

	filters at: #method put: regexString.! !

!DANodePointcut methodsFor: 'filtering' stamp: 'as 1/24/2008 16:45'!
methods
	
	| methods |
	
	methods _ Set new.
	self methodFilter ifNotNil: [
		self classes do: [
			:each |
			each methods do: [
				:method |
				(method selector matchesRegex: self methodFilter) ifTrue: [
					methods add: method reflectiveMethod.
				].
			].
		].
	].
	^ methods.! !

!DANodePointcut methodsFor: 'designating' stamp: 'as 1/24/2008 16:46'!
node: aBlock

	self nodeFilter: aBlock.
	self reset.! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 1/24/2008 16:41'!
nodeFilter

	^ filters at: #node ifAbsent: [ nil. ].! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 1/24/2008 16:48'!
nodeFilter: regexString

	filters at: #node put: regexString.! !

!DANodePointcut methodsFor: 'filtering' stamp: 'as 1/24/2008 16:46'!
nodes

	| nodes |

	nodes _ Set new.
	self nodeFilter ifNotNil: [
		self methods do: [
			:each |
			nodes addAll: (each nodes select: self nodeFilter).
		].
	].
	^ nodes.! !

!DANodePointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:03'!
visitName

	^ 'node'.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:00'!
acceptVisitor: aDAPointcutVisitor

	aDAPointcutVisitor perform: ('visit', self visitName capitalized, ':') asSymbol with: self.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 1/24/2008 16:32'!
and: aDAPointcut

	^ DAAndPointcut child: self child: aDAPointcut.! !

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
	category: 'DynamicAspects-Pointcuts'!

!DAPointcutVisitor commentStamp: 'as 1/24/2008 17:04' prior: 0!
Visit a pointcut structure.!

DAPointcutVisitor subclass: #DALinkGenerator
	instanceVariableNames: 'links nodes condition stack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DALinkGenerator commentStamp: 'as 1/24/2008 17:14' prior: 0!
Goes over a pointcut structure and prepares Geppetto links for it.!

!DALinkGenerator methodsFor: 'initialize-release' stamp: 'as 1/25/2008 14:06'!
initialize

	self initializeVariables.
	stack _ Stack new.! !

!DALinkGenerator methodsFor: 'initialize-release' stamp: 'as 1/25/2008 14:09'!
initializeVariables

	links _ Dictionary new.
	nodes _ condition _ nil.! !

!DALinkGenerator methodsFor: 'stacking' stamp: 'as 1/25/2008 14:35'!
pop

	^ stack pop.! !

!DALinkGenerator methodsFor: 'stacking' stamp: 'as 1/25/2008 14:15'!
push

	stack push: { #links -> links. #nodes -> nodes. #condition -> condition. }.
	self initializeVariables.! !

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 1/25/2008 11:11'!
visitAnd: pc! !

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 1/25/2008 14:04'!
visitCondition: pc

	condition _ pc condition.! !

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 1/25/2008 14:03'!
visitNode: pc

	nodes _ pc nodes.! !

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 1/25/2008 15:51'!
visitOr: pc

	| pop |

	pc left acceptVisitor: self.
	self push.
	pc right acceptVisitor: self.
	
	pop _ self pop.
	links addAll: (pop at: #links).
	
	{ { nodes. condition. }. { pop at: #nodes. pop at: #condition. }. } do: [
		:tupel |
		| n c |
		n _ tupel first.
		c _ tupel last.
		n ifNil: [
			c ifNotNil: [ self error: 'found condition without node specification'. ].
		] ifNotNil: [
			c ifNil: [
				links add: (DALink nodes: n).
			] ifNotNil: [
				links add: (DALink nodes: n condition: c).
			].
		].
	].! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/24/2008 17:15'!
visit: aDAPointcut

	aDAPointcut acceptVisitor: self.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/24/2008 17:17'!
visitAnd: aDAAndPointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/24/2008 17:17'!
visitCondition: aDAConditionPointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/24/2008 17:17'!
visitNode: aDANodePointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 1/24/2008 17:17'!
visitOr: aDAOrPointcut

	self subclassResponsibility.! !

GPCondition subclass: #DACondition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Geppetto'!

!DACondition commentStamp: 'as 1/21/2008 08:29' prior: 0!
Used instead of GPCondition to make the GPTransformer aware of the fact that the condition wants a single argument passed, which will contain all reification arguments in a dictionary.!

!DACondition class methodsFor: 'instance creation' stamp: 'as 1/24/2008 12:24'!
with: aBlockOrBoolean

	^ self with: aBlockOrBoolean arguments: nil.! !

!DACondition class methodsFor: 'instance creation' stamp: 'as 1/21/2008 11:47'!
with: aBlockOrBoolean arguments: aCollection

	^ self new
		condition: aBlockOrBoolean;
		arguments: aCollection;
		yourself.! !

!DACondition methodsFor: 'composing' stamp: 'as 1/24/2008 13:41'!
and: aDACondition

	(condition = true) | (aDACondition = false) ifTrue: [ ^ aDACondition. ].
	(aDACondition = true) | (condition = false) ifTrue: [ ^ self. ].
	^ self combineWith: aDACondition using: #&.! !

!DACondition methodsFor: 'accessing' stamp: 'as 1/24/2008 12:15'!
arguments

	condition isBoolean ifTrue: [ ^ #(). ].
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

!DACondition methodsFor: 'private' stamp: 'as 1/24/2008 12:11'!
combineWith: aDACondition using: aSymbol

	| block args |
	
	block _ self combineBlock: condition args: arguments withBlock: aDACondition condition args: aDACondition arguments using: aSymbol.
	args _ arguments union: aDACondition arguments.
	^ self class with: block arguments: args.! !

!DACondition methodsFor: 'testing' stamp: 'as 1/24/2008 12:16'!
hasArguments

	^ arguments notNil.! !

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

!DAGeppettoTests methodsFor: 'testing' stamp: 'as 1/21/2008 08:52'!
testArgumentListCondition

	| link asserted |
	asserted _ false.
	link _ GPLink metaObject: [ asserted _ true. ].
	link before.
	link singleArgCondition:
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
