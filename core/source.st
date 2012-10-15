SystemOrganization addCategory: #'DA-Geppetto'!
SystemOrganization addCategory: #'DA-Geppetto-Tests'!
SystemOrganization addCategory: #'DA-Kernel'!
SystemOrganization addCategory: #'DA-Kernel-Tests'!
SystemOrganization addCategory: #'DA-Pointcut'!
SystemOrganization addCategory: #'DA-Pointcut-Tests'!
SystemOrganization addCategory: #'DA-Testing'!
SystemOrganization addCategory: #'DA-Tests'!
SystemOrganization addCategory: #'DA-Utilities'!
SystemOrganization addCategory: #'DA-Utilities-Tests'!

!String methodsFor: '*DA' stamp: 'as 2/11/2008 08:14'!
asRegexFilter

	^ DARegexFilter new: self.! !

TestResource subclass: #DATestAspectResource
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Testing'!

!DATestAspectResource commentStamp: 'as 2/18/2008 10:35' prior: 0!
The test aspect should be installed/uninstalled once for all tests that run on it.!

!DATestAspectResource methodsFor: 'running' stamp: 'as 2/18/2008 10:45'!
removeAllLinksOn: aClass

	aClass methodDict values, aClass class methodDict values do: [
		:method |
		method reflectiveMethod methodNode nodesDo: [
			:node |
			node hasAnyLink ifTrue: [ node removeAllLinks. ].
			self assert: node hasAnyLink not.
		].
	].! !

!DATestAspectResource methodsFor: 'running' stamp: 'as 2/18/2008 17:09'!
setUp

	DATestAspect instance uninstall.
	self removeAllLinksOn: DAExamples.
	DATestAspect instance install.! !

!DATestAspectResource methodsFor: 'running' stamp: 'as 2/18/2008 10:46'!
tearDown

	DATestAspect instance uninstall.
	self removeAllLinksOn: DAExamples.! !

Object subclass: #DAExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Testing'!

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

!DAExamples class methodsFor: 'counting' stamp: 'as 2/18/2008 14:06'!
counter: aNumber

	counter _ aNumber.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 2/14/2008 17:21'!
exampleAfter

	counter _ 2.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 2/14/2008 17:21'!
exampleBefore

	counter _ 2.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 2/15/2008 13:32'!
exampleCondition

	self count.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 2/18/2008 13:32'!
exampleFieldRead

	^ counter.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 2/18/2008 14:06'!
exampleFieldWrite

	counter _ 1.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 2/14/2008 17:25'!
exampleForward

	self exampleNoop.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 2/15/2008 13:29'!
exampleInstead

	self count.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 2/14/2008 17:25'!
exampleNoop! !

!DAExamples class methodsFor: 'examples' stamp: 'as 2/18/2008 17:07'!
exampleParameters

	^ counter.! !

!DAExamples class methodsFor: 'counting' stamp: 'as 10/23/2007 16:22'!
initializeCounter

	counter _ 0.! !

Object subclass: #DALink
	instanceVariableNames: 'link filters cache'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Geppetto'!

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

!DALink methodsFor: 'installation' stamp: 'as 2/11/2008 11:56'!
install

	self nodes do: [ :node | link hookOn: node. ].! !

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

!DALink methodsFor: 'installation' stamp: 'as 2/11/2008 10:54'!
uninstall

	link uninstall.! !

Object subclass: #DAPointcut
	instanceVariableNames: 'parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcut'!

!DAPointcut commentStamp: 'as 1/17/2008 14:11' prior: 0!
Pointcuts describe a set of join points. So far, the only type of join points are nodes in reflective methods.!

DAPointcut subclass: #DACompositePointcut
	instanceVariableNames: 'children'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcut'!

!DACompositePointcut commentStamp: 'as 2/8/2008 11:26' prior: 0!
A composition of two pointcuts.!

DACompositePointcut subclass: #DAAndPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcut'!

!DAAndPointcut commentStamp: 'as 1/31/2008 17:05' prior: 0!
Selects all join points that fullfill all requirements of two pointcuts.!

!DAAndPointcut methodsFor: 'inverting' stamp: 'as 2/5/2008 15:42'!
invert

	^ DAOrPointcut children: children.! !

!DAAndPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:04'!
visitName

	^ 'and'.! !

!DACompositePointcut class methodsFor: 'instance creation' stamp: 'as 2/11/2008 17:33'!
child: aDAPointcut1 child: aDAPointcut2

	^ self new children: { aDAPointcut1. aDAPointcut2. }; yourself.! !

!DACompositePointcut class methodsFor: 'instance creation' stamp: 'as 2/5/2008 15:42'!
children: aCollection

	^ self new children: aCollection; yourself.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 2/11/2008 19:09'!
children

	^ children.! !

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
	category: 'DA-Pointcut'!

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
	category: 'DA-Pointcut'!

!DADesignatePointcut commentStamp: 'as 1/24/2008 15:45' prior: 0!
Designates join points in the system.!

DADesignatePointcut subclass: #DAConditionPointcut
	instanceVariableNames: 'condition'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcut'!

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
	category: 'DA-Pointcut'!

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
	category: 'DA-Pointcut'!

!DAFilterPointcut commentStamp: 'as 1/31/2008 16:58' prior: 0!
Specifies a filter for designating join points.!

DAFilterPointcut subclass: #DACategoryPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcut'!

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
	category: 'DA-Pointcut'!

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
	category: 'DA-Pointcut'!

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
	category: 'DA-Pointcut'!

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

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/15/2008 11:57'!
call: aSymbol

	^ self node: [ :node | node isMessage & (node selector = aSymbol). ].! !

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

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/18/2008 10:07'!
fieldRead: aString

	^ self node: [
		:node |
		| return |
		return _ node isVariable and: [ node name = aString. ].
		(node parent isKindOf: RBProgramNode) ifTrue: [
			| parent |
			parent _ node parent.
			parent isAssignment ifTrue: [
				return _ return &
					(parent variable ~~ node) & (parent value == node).
			].
		].
		return.
	].! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/18/2008 09:07'!
fieldWrite: aString

	^ self node: [
		:node |
		node isAssignment and: [
			node variable name = aString.
		].
	].! !

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

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/15/2008 13:38'!
node: aBlock

	^ DANodePointcut condition: aBlock.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 13:30'!
within: aMethod

	^ DAControlFlowPointcut method: aMethod level: 1.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:00'!
acceptVisitor: aDAPointcutVisitor

	aDAPointcutVisitor perform: ('visit', self visitName capitalized, ':') asSymbol with: self.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 1/24/2008 16:32'!
and: aDAPointcut

	^ DAAndPointcut child: self child: aDAPointcut.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 2/11/2008 10:22'!
genLinks

	^ DALinkGenerator new visit: self; yourself.! !

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
	category: 'DA-Pointcut'!

!DAPointcutVisitor commentStamp: 'as 1/24/2008 17:04' prior: 0!
Visit a pointcut structure.!

DAPointcutVisitor subclass: #DALinkGenerator
	instanceVariableNames: 'links stack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcut'!

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

Object subclass: #DAProtoAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

!DAProtoAspect commentStamp: 'as 11/19/2007 12:50' prior: 0!
An aspect is in AOP (Aspect-Oriented Progamming) what and object is in OOP (Object-Oriented Programming). Instead of trying to break down a program into different objects and their corresponding classes, in AOP the entities of modularization are aspects.
An aspect usually covers a cross-cutting concern in OOP that can be implemented much easier with AOP.!

DAProtoAspect subclass: #DAAspect
	instanceVariableNames: 'links pc'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

DAAspect class
	instanceVariableNames: 'instance'!

!DAAspect commentStamp: 'as 2/14/2008 11:44' prior: 0!
An aspect that is defined in the browser. The pointcuts and advices are all implemented as normal methods.

Although aspects are not necessarily objects or classes, in this implementation they are implemented as singleton classes in the traditional OOP way to get a good integration with the existing system.!

DAAspect class
	instanceVariableNames: 'instance'!

!DAAspect class methodsFor: 'instance creation' stamp: 'as 2/11/2008 16:03'!
instance

	^ instance ifNil: [ instance _ self basicNew initialize. ].! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 10/31/2007 13:59'!
new

	self error: 'I''m singleton, use ', self class name, ' >> instance'.! !

!DAAspect methodsFor: 'advices' stamp: 'as 2/11/2008 15:46'!
advices

	| possibilities |
	possibilities _ self possibleAdviceNames.
	^ self class methods select: [
		:method |
		possibilities anySatisfy: [
			:pos |
			pos match: (method selector subStrings: ':') first.
		].
	].! !

!DAAspect methodsFor: 'accessing' stamp: 'as 10/22/2007 09:56'!
allPointcutNames

	^ self class allPointcutNames.! !

!DAAspect methodsFor: 'advices' stamp: 'as 10/24/2007 09:51'!
controlForAdvice: aMethod

	^ self adviceControls detect: [
		:ctrl |
		aMethod selector startsWith: ctrl.
	].! !

!DAAspect methodsFor: 'initialize-release' stamp: 'as 10/31/2007 10:27'!
initialize

	self initializeLinks.
	pc _ DAPointcut.! !

!DAAspect methodsFor: 'initialize-release' stamp: 'as 11/19/2007 08:26'!
initializeLinks

	links _ IdentitySet new.! !

!DAAspect methodsFor: 'installing' stamp: 'as 1/17/2008 15:42'!
install

	self isInstalled ifFalse: [
		self advices do: [
			:adv |
			| pointcut |
			pointcut _ self pointcutForAdvice: adv.
			self installAdvice: adv pointcut: pointcut.
		].
	].! !

!DAAspect methodsFor: 'private' stamp: 'as 2/18/2008 16:46'!
installAdvice: advice pointcut: pointcut

	pointcut genLinks links do: [
		:link |
		[
			link link
				metaObject: self;
				selector: advice selector;
				arguments: (self reificationsForAdvice: advice);
				control: (self controlForAdvice: advice);
				aspect: self.
			link install.
			links add: link.
		] on: Exception do: [
			:e |
			link uninstall.
			self uninstall.
			e signal.
		].
	].! !

!DAAspect methodsFor: 'testing' stamp: 'as 2/11/2008 11:13'!
isInstalled

	^ links notEmpty.! !

!DAAspect methodsFor: 'pointcuts' stamp: 'as 10/31/2007 14:20'!
pointcut: aSymbol

	^ self perform: aSymbol.! !

!DAAspect methodsFor: 'pointcuts' stamp: 'as 10/31/2007 10:35'!
pointcutForAdvice: aMethod

	^ self pointcut: (
		self allPointcutNames detect: [
			:pcn |
			(aMethod selector subStrings: ':') first endsWith: pcn capitalized.
		]
	).! !

!DAAspect methodsFor: 'advices' stamp: 'as 2/11/2008 15:42'!
possibleAdviceNames

	| names |
	names _ Set new.
	self allPointcutNames do: [
		:pcn |
		self adviceControls do: [
			:ctrl |
			names add: ctrl, pcn capitalized.
		].
	].
	^ names.! !

!DAAspect methodsFor: 'advices' stamp: 'as 10/24/2007 15:28'!
reificationsForAdvice: aMethod

	^ aMethod reflectiveMethod argumentNames collect: [ :name | name asSymbol. ].! !

!DAAspect methodsFor: 'installing' stamp: 'as 11/19/2007 08:27'!
uninstall

	self isInstalled ifTrue: [
		links do: [ :link | link uninstall. ].
		self initializeLinks.
	].! !

DAAspect subclass: #DATestAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Testing'!

!DATestAspect commentStamp: 'as 10/8/2007 10:18' prior: 0!
An aspect to run tests on.!

!DATestAspect class methodsFor: 'pointcuts' stamp: 'as 2/18/2008 14:14'!
pointcutNames

	^ #(exampleBefore
		exampleAfter
		exampleInstead
		exampleForward
		exampleFieldRead
		exampleFieldWrite
		exampleParameters).! !

!DATestAspect methodsFor: 'advices' stamp: 'as 2/14/2008 17:23'!
afterExampleAfter

	DAExamples count.! !

!DATestAspect methodsFor: 'advices' stamp: 'as 2/14/2008 17:23'!
beforeExampleBefore

	DAExamples count.! !

!DATestAspect methodsFor: 'advices' stamp: 'as 2/14/2008 17:23'!
beforeExampleForward

	DAExamples count.! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 2/14/2008 17:23'!
exampleAfter

	^ pc method: DAExamples class >> #exampleAfter.! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 2/14/2008 17:22'!
exampleBefore

	^ pc method: DAExamples class >> #exampleBefore.! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 2/18/2008 13:59'!
exampleFieldRead

	^ (pc method: DAExamples class >> #exampleFieldRead) and: (pc fieldRead: 'counter').! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 2/18/2008 14:07'!
exampleFieldWrite

	^ (pc method: DAExamples class >> #exampleFieldWrite) and: (pc fieldWrite: 'counter').! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 2/14/2008 17:27'!
exampleForward

	^ (pc cflow: DAExamples class >> #exampleForward) and:
		(pc method: DAExamples class >> #exampleNoop).! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 2/15/2008 13:29'!
exampleInstead

	^ pc method: DAExamples class >> #exampleInstead.! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 2/18/2008 17:07'!
exampleParameters

	^ (pc method: DAExamples class >> #exampleParameters) and: (pc fieldRead: 'counter').! !

!DATestAspect methodsFor: 'advices' stamp: 'as 2/18/2008 13:31'!
insteadExampleFieldRead

	^ 2.! !

!DATestAspect methodsFor: 'advices' stamp: 'as 2/18/2008 14:06'!
insteadExampleFieldWrite

	DAExamples counter: 2.! !

!DATestAspect methodsFor: 'advices' stamp: 'as 2/18/2008 09:00'!
insteadExampleInstead

	"do nothing"! !

!DATestAspect methodsFor: 'advices' stamp: 'as 2/18/2008 16:52'!
insteadExampleParameters: object class: class control: control

	^ Dictionary new
		at: #object put:object;
		at: #class put: class;
		at: #control put: control;
		yourself.! !

!DAProtoAspect class methodsFor: 'pointcuts' stamp: 'as 2/15/2008 10:46'!
allPointcutNames

	^ self superclass pointcutNames, self pointcutNames.! !

!DAProtoAspect class methodsFor: 'pointcuts' stamp: 'as 2/15/2008 10:41'!
pointcutNames

	^ #().! !

!DAProtoAspect methodsFor: 'advices' stamp: 'as 11/19/2007 08:29'!
adviceControls

	^ #(before after instead).! !

!DAProtoAspect methodsFor: 'installing' stamp: 'as 11/19/2007 08:17'!
install

	self subclassResponsibility.! !

!DAProtoAspect methodsFor: 'testing' stamp: 'as 11/19/2007 08:17'!
isInstalled

	self subclassResponsibility.! !

!DAProtoAspect methodsFor: 'installing' stamp: 'as 11/19/2007 08:17'!
uninstall

	self subclassResponsibility.! !

Object subclass: #DARegexFilter
	instanceVariableNames: 'regex negated'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities'!

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

GPCondition subclass: #DACondition
	instanceVariableNames: 'negated'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Geppetto'!

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

!DACondition methodsFor: 'private' stamp: 'as 2/11/2008 17:01'!
negatedCondition

	condition isBoolean ifTrue: [ ^ condition not. ].
	^ [ :args | (condition value: args) not. ].! !

!DACondition methodsFor: 'negating' stamp: 'as 2/8/2008 10:21'!
not

	negated _ negated not.! !

!DACondition methodsFor: 'accessing' stamp: 'as 1/24/2008 12:15'!
reifications

	^ self arguments.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 2/11/2008 17:07'!
value

	^ self condition value.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 2/11/2008 17:07'!
value: anObject

	^ self condition value: anObject.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 2/11/2008 17:08'!
value: anObjectA value: anObjectB

	^ self condition value: anObjectA value: anObjectB.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 2/11/2008 17:08'!
value: anObjectA value: anObjectB value: anObjectC

	^ self condition value: anObjectA value: anObjectB value: anObjectC.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 2/11/2008 17:08'!
value: anObjectA value: anObjectB value: anObjectC value: anObjectD

	^ self condition value: anObjectA value: anObjectB value: anObjectC value: anObjectD.! !

!GPLink methodsFor: '*DA' stamp: 'as 12/12/2007 15:55'!
aspect

	properties ifNil: [ ^ nil. ].
	^self properties at: #aspect ifAbsent: [ nil. ].! !

!GPLink methodsFor: '*DA' stamp: 'as 12/12/2007 15:54'!
aspect: aDAAspect

	self properties at: #aspect put: aDAAspect.! !

!GPLink methodsFor: '*DA' stamp: 'as 1/25/2008 11:58'!
conditionObject: aGPCondition

	condition _ aGPCondition.! !

!GPTransformer methodsFor: '*DA' stamp: 'as 1/14/2008 16:28'!
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

!GPTransformer methodsFor: '*DA' stamp: 'as 1/21/2008 08:52'!
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

!GPTransformer methodsFor: '*DA' stamp: 'as 1/21/2008 08:53'!
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

!Collection methodsFor: '*DA' stamp: 'as 1/31/2008 15:23'!
selfIfEmpty: aBlock

	self isEmpty ifTrue: [ ^ aBlock value. ] ifFalse: [ ^ self. ].! !

TestCase subclass: #DAAndPointcutTest
	instanceVariableNames: 'pointcut'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcut-Tests'!

!DAAndPointcutTest commentStamp: 'as 2/11/2008 17:31' prior: 0!
Testing DAAndPointcut.!

!DAAndPointcutTest methodsFor: 'running' stamp: 'as 2/11/2008 17:55'!
setUp

	pointcut _ (DAPointcut class: self class) and: (DAPointcut class: self class).! !

!DAAndPointcutTest methodsFor: 'testing' stamp: 'as 2/11/2008 17:47'!
testInverting

	pointcut_ pointcut not.
	self assert: (pointcut isKindOf: DAOrPointcut).
	self assert: pointcut left filter isNegated.
	self assert: pointcut right filter isNegated.! !

TestCase subclass: #DACodingTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

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

TestCase subclass: #DACompositePointcutTest
	instanceVariableNames: 'pointcut'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcut-Tests'!

!DACompositePointcutTest commentStamp: 'as 2/11/2008 19:06' prior: 0!
Testing DACompositePointcut.!

!DACompositePointcutTest methodsFor: 'running' stamp: 'as 2/11/2008 19:08'!
setUp

	pointcut _ DACompositePointcut child: DAPointcut new child: DAPointcut new.! !

!DACompositePointcutTest methodsFor: 'testing' stamp: 'as 2/11/2008 19:09'!
testParent

	pointcut children do: [
		:child |
		self assert: child parent == pointcut.
	].! !

TestCase subclass: #DALinkGeneratorTest
	instanceVariableNames: 'generator pc'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcut-Tests'!

!DALinkGeneratorTest commentStamp: 'as 2/11/2008 19:10' prior: 0!
Testing DALinkGenerator.!

!DALinkGeneratorTest methodsFor: 'running' stamp: 'as 2/14/2008 11:36'!
setUp

	generator _ DALinkGenerator new.
	pc _ DAPointcut.! !

TestCase subclass: #DALinkTest
	instanceVariableNames: 'link'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Geppetto-Tests'!

!DALinkTest commentStamp: 'as 1/31/2008 14:14' prior: 0!
Testing DALink.!

!DALinkTest methodsFor: 'running' stamp: 'as 1/31/2008 14:17'!
setUp

	link _ DALink new.! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/18/2008 10:15'!
testAndingLinks

	| link2 link3 |

	link
		category: 'DA-Geppetto-Tests' asRegexFilter;
		class: 'DALinkTest' asRegexFilter.
	link2 _ DALink new
		method: 'testAndingLinks' asRegexFilter;
		node: [ :node | node isMethodNode. ];
		yourself.
	link3 _ link and: link2.
	self assert: (link3 methods includes: (DALinkTest >> #testAndingLinks) reflectiveMethod).! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/18/2008 10:17'!
testFilteringCategories

	link category: 'DA*' asRegexFilter.
	self assert: (link categories includes: #'DA-Geppetto-Tests').! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/18/2008 10:16'!
testFilteringClasses

	link category: 'DA-Geppetto-Tests' asRegexFilter; class: 'DALinkTest' asRegexFilter.
	self assert: (link classes includes: DALinkTest).! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/18/2008 10:16'!
testFilteringMethods

	link
		category: 'DA-Geppetto-Tests' asRegexFilter;
		class: 'DALinkTest' asRegexFilter;
		method: 'testFilteringMethods' asRegexFilter.
	self assert: (link methods includes: (DALinkTest >> #testFilteringMethods) reflectiveMethod).! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/18/2008 10:16'!
testFilteringNodes

	link
		category: 'DA-Geppetto-Tests' asRegexFilter;
		class: 'DALinkTest' asRegexFilter;
		method: 'testFilteringNodes' asRegexFilter;
		node: [ :node | node isCascade. ].
	self assert: (link nodes size = 1).! !

TestCase subclass: #DAOrPointcutTest
	instanceVariableNames: 'pointcut'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcut-Tests'!

!DAOrPointcutTest commentStamp: 'as 2/11/2008 19:04' prior: 0!
Testing DAOrPointcut.!

!DAOrPointcutTest methodsFor: 'running' stamp: 'as 2/11/2008 19:04'!
setUp

	pointcut _ (DAPointcut class: self class) or: (DAPointcut class: self class).! !

!DAOrPointcutTest methodsFor: 'testing' stamp: 'as 2/11/2008 19:05'!
testInverting

	pointcut_ pointcut not.
	self assert: (pointcut isKindOf: DAAndPointcut).
	self assert: pointcut left filter isNegated.
	self assert: pointcut right filter isNegated.! !

TestCase subclass: #DARegexFilterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities-Tests'!

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
	instanceVariableNames: 'links'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Testing'!

!DATestingWithLinks commentStamp: 'as 2/1/2008 13:57' prior: 0!
A test that uses Geppetto links.

This provides link cleanup at start/finish for any subclassed test.!

DATestingWithLinks subclass: #DAAspectTest
	instanceVariableNames: 'example aspect'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel-Tests'!

!DAAspectTest commentStamp: 'as 8/14/2007 10:30' prior: 0!
Testing DAAspect.!

!DAAspectTest class methodsFor: 'testing' stamp: 'as 2/18/2008 10:31'!
isAbstract

	^ false.! !

!DAAspectTest class methodsFor: 'accessing' stamp: 'as 2/18/2008 11:05'!
resources

	^ {DATestAspectResource}.! !

!DAAspectTest methodsFor: 'running' stamp: 'as 2/18/2008 10:47'!
setUp

	super setUp.
	DAExamples initializeCounter.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 2/14/2008 17:29'!
testAfter

	DAExamples exampleAfter.
	self assert: DAExamples counter = 3.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 2/14/2008 17:28'!
testBefore

	DAExamples exampleBefore.
	self assert: DAExamples counter = 2.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 2/14/2008 17:26'!
testCflow

	DAExamples exampleNoop.
	self assert: DAExamples counter = 0.
	DAExamples exampleForward.
	self assert: DAExamples counter = 1.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 2/18/2008 14:04'!
testFieldRead

	self assert: DAExamples exampleFieldRead = 2.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 2/18/2008 14:07'!
testFieldWrite

	DAExamples exampleFieldWrite.
	self assert: DAExamples counter = 2.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 2/15/2008 13:34'!
testInstead

	DAExamples exampleInstead.
	self assert: DAExamples counter = 0.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 2/18/2008 17:06'!
testParameters

	| pars |
	
	pars _ DAExamples exampleParameters.
	self assert: (pars at: #class) == DAExamples class.
	self assert: (pars at: #object) == DAExamples.
	self assert: (pars at: #control) == #instead.! !

DATestingWithLinks subclass: #DAConditionTest
	instanceVariableNames: 'trueCond falseCond blockCond'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Geppetto-Tests'!

!DAConditionTest commentStamp: 'as 1/27/2008 17:41' prior: 0!
Testing DACondition.!

!DAConditionTest class methodsFor: 'testing' stamp: 'as 2/18/2008 10:31'!
isAbstract

	^ false.! !

!DAConditionTest methodsFor: 'running' stamp: 'as 2/11/2008 17:20'!
setUp

	super setUp.
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

!DAConditionTest methodsFor: 'testing' stamp: 'as 2/14/2008 17:52'!
testDeployment

	| link asserted condition |
	asserted _ false.
	link _ GPLink metaObject: [ asserted _ true. ].
	self cleanup: link.
	link before.
	condition _ DACondition
		with: [ :args | (args at: #object) = DAExamples. ]
		arguments: #(object).
	link conditionObject: condition.
	link hookOn: (DAExamples class >> #exampleCondition) reflectiveMethod methodNode.
	DAExamples exampleCondition.
	self assert: asserted.! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 2/11/2008 17:10'!
testNegatingBlock

	blockCond not.
	self deny: (blockCond value: nil).! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 2/11/2008 17:09'!
testNegatingBoolean

	trueCond not.
	self deny: trueCond.! !

DATestingWithLinks subclass: #DAControlFowPointcutTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcut-Tests'!

!DAControlFowPointcutTest commentStamp: 'as 2/1/2008 13:32' prior: 0!
Testing DAControlFlowPointcut.!

!DAControlFowPointcutTest class methodsFor: 'testing' stamp: 'as 2/18/2008 10:32'!
isAbstract

	^ false.! !

!DAControlFowPointcutTest methodsFor: 'testing' stamp: 'as 2/14/2008 17:53'!
testDeployment

	| pc visitor link asserted |
	pc _ (DAPointcut cflow: DAExamples class >> #exampleForward) and:
		(DAPointcut method: DAExamples class >> #exampleNoop).
	visitor _ DALinkGenerator new.
	visitor visit: pc.
	self assert: visitor links size = 1.
	link _ visitor links first.
	self cleanup: link.
	link link metaObject: [ asserted _ true. ].
	link nodes do: [ :each | each link: link link. ].
	asserted _ false.
	DAExamples exampleNoop.
	self deny: asserted.
	DAExamples exampleForward.
	self assert: asserted.! !

!DATestingWithLinks class methodsFor: 'testing' stamp: 'as 2/18/2008 10:30'!
isAbstract

	^ true.! !

!DATestingWithLinks methodsFor: 'running' stamp: 'as 2/11/2008 15:11'!
cleanup: aGPLink

	"Register aGPLink for cleanup in #tearDown"
	
	links add: aGPLink.! !

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

!DATestingWithLinks methodsFor: 'running' stamp: 'as 2/11/2008 15:06'!
setUp

	links _ Set new.! !

!DATestingWithLinks methodsFor: 'running' stamp: 'as 2/11/2008 15:07'!
tearDown

	links do: [ :link | link uninstall. ].! !
