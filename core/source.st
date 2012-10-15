SystemOrganization addCategory: #'DA-Geppetto'!
SystemOrganization addCategory: #'DA-Geppetto-Tests'!
SystemOrganization addCategory: #'DA-Kernel'!
SystemOrganization addCategory: #'DA-Kernel-Tests'!
SystemOrganization addCategory: #'DA-Pointcuts'!
SystemOrganization addCategory: #'DA-Pointcuts-Tests'!
SystemOrganization addCategory: #'DA-Testing'!
SystemOrganization addCategory: #'DA-Tests'!
SystemOrganization addCategory: #'DA-Utilities'!
SystemOrganization addCategory: #'DA-Utilities-Tests'!

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

Object subclass: #DAClassMethodDescription
	instanceVariableNames: 'className methodName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities'!

!DAClassMethodDescription commentStamp: 'as 2/28/2008 16:02' prior: 0!
I store a description of a method and it's class or just of a method, instead of the objects itself. Each time I'm asked for the method/class I will re-evaluate and return the proper object. This protects against method/class recompilations.!

!DAClassMethodDescription class methodsFor: 'instance creation' stamp: 'as 2/28/2008 16:03'!
class: aClass

	^ self new class: aClass; yourself.! !

!DAClassMethodDescription class methodsFor: 'instance creation' stamp: 'as 2/28/2008 16:05'!
method: aMethod

	^ self new method: aMethod; yourself.! !

!DAClassMethodDescription methodsFor: 'accessing' stamp: 'as 2/28/2008 16:05'!
class

	^ Smalltalk at: className.! !

!DAClassMethodDescription methodsFor: 'accessing' stamp: 'as 2/28/2008 16:05'!
class: aClass

	className _ aClass name asSymbol.! !

!DAClassMethodDescription methodsFor: 'accessing' stamp: 'as 2/28/2008 16:05'!
method

	^ self class >> methodName.! !

!DAClassMethodDescription methodsFor: 'accessing' stamp: 'as 2/28/2008 16:05'!
method: aMethod

	self class: aMethod methodClass.
	methodName _ aMethod selector.! !

Object subclass: #DACondition
	instanceVariableNames: 'negated'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Geppetto'!

!DACondition commentStamp: 'as 3/7/2008 09:48' prior: 0!
Extends GPCondition by the ability to combine multiple block conditions.!

DACondition subclass: #DAAndCondition
	instanceVariableNames: 'left right'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Geppetto'!

!DAAndCondition commentStamp: 'as 3/7/2008 10:46' prior: 0!
Combines two conditions with a logical 'and'.!

!DAAndCondition class methodsFor: 'instance creation' stamp: 'as 3/10/2008 13:42'!
with: aDACondition1 with: aDACondition2

	^ self new condition: aDACondition1 condition: aDACondition2; yourself.! !

!DAAndCondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:25'!
andMessage

	^ #and:.! !

!DAAndCondition methodsFor: 'private' stamp: 'as 3/10/2008 16:56'!
args: anArray forCond: aDACondition

	^ (aDACondition arguments inject: OrderedCollection new into: [
		:col :arg |
		col add: (anArray at: (self arguments indexOf: arg)).
		col.
	]) asArray.! !

!DAAndCondition methodsFor: 'accessing' stamp: 'as 3/10/2008 15:57'!
arguments

	| args |

	args _ left arguments asOrderedCollection.
	right arguments do: [ :arg | (args includes: arg) ifFalse: [ args add: arg. ]. ].
	^ args.! !

!DAAndCondition methodsFor: 'accessing' stamp: 'as 3/10/2008 13:55'!
condition: aDACondition1 condition: aDACondition2

	left _ aDACondition1.
	right _ aDACondition2.! !

!DAAndCondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:36'!
doValue

	^ left value perform: self andMessage with: right value.! !

!DAAndCondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 16:23'!
doValueWithArguments: anArray
	
	^ (self valueForCond: left args: anArray)
		perform: self andMessage
		with: (self valueForCond: right args: anArray).! !

!DAAndCondition methodsFor: 'initialize-release' stamp: 'as 3/10/2008 15:50'!
initialize

	super initialize.! !

!DAAndCondition methodsFor: 'accessing' stamp: 'as 3/10/2008 14:00'!
numArgs

	^ self arguments size.! !

!DAAndCondition methodsFor: 'private' stamp: 'as 3/10/2008 16:26'!
valueForCond: aDACondition args: anArray

	| args |
	
	args _ self args: anArray forCond: aDACondition.
	args isEmpty ifTrue: [
		^ aDACondition value.
	] ifFalse: [
		^ aDACondition valueWithArguments: args.
	].! !

DACondition subclass: #DABlockCondition
	instanceVariableNames: 'block arguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Geppetto'!

!DABlockCondition commentStamp: 'as 3/7/2008 10:45' prior: 0!
Contains a single block as condition.!

!DABlockCondition class methodsFor: 'instance creation' stamp: 'as 3/10/2008 14:43'!
block: aBlock

	^ self block: aBlock arguments: nil.! !

!DABlockCondition class methodsFor: 'instance creation' stamp: 'as 3/10/2008 14:44'!
block: aBlock arguments: args

	^ self new block: aBlock; arguments: args; yourself.! !

!DABlockCondition methodsFor: 'accessing' stamp: 'as 3/10/2008 14:51'!
arguments

	^ arguments ifNil: [ block blockArgNames. ].! !

!DABlockCondition methodsFor: 'accessing' stamp: 'as 3/10/2008 14:50'!
arguments: args

	arguments _ args.! !

!DABlockCondition methodsFor: 'accessing' stamp: 'as 3/10/2008 14:45'!
block: aBlock

	block _ aBlock.! !

!DABlockCondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:52'!
doValue

	^ block value.! !

!DABlockCondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:52'!
doValueWithArguments: anArray

	^ block valueWithArguments: anArray.! !

!DABlockCondition methodsFor: 'accessing' stamp: 'as 3/10/2008 14:51'!
numArgs

	^ block numArgs.! !

DACondition subclass: #DABooleanCondition
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Geppetto'!

!DABooleanCondition commentStamp: 'as 3/10/2008 13:40' prior: 0!
Contains a single boolean value as condition.!

!DABooleanCondition class methodsFor: 'instance creation' stamp: 'as 3/10/2008 14:54'!
value: aBoolean

	^ self new value: aBoolean; yourself.! !

!DABooleanCondition methodsFor: 'accessing' stamp: 'as 3/10/2008 14:55'!
arguments

	^ #().! !

!DABooleanCondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:55'!
doValue

	^ value.! !

!DABooleanCondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:56'!
doValueWithArguments: anArray

	^ self doValue.! !

!DABooleanCondition methodsFor: 'accessing' stamp: 'as 3/10/2008 14:55'!
numArgs

	^ 0.! !

!DABooleanCondition methodsFor: 'accessing' stamp: 'as 3/10/2008 14:54'!
value: aBoolean

	value _ aBoolean.! !

!DACondition class methodsFor: 'instance creation' stamp: 'as 3/10/2008 15:20'!
with: aBlockOrBoolean

	^ self with: aBlockOrBoolean arguments: nil.! !

!DACondition class methodsFor: 'instance creation' stamp: 'as 3/10/2008 16:17'!
with: aBlockOrBoolean arguments: args

	aBlockOrBoolean isBlock ifTrue: [
		^ DABlockCondition block: aBlockOrBoolean arguments: args.
	].

	aBlockOrBoolean isBoolean ifTrue: [
		args ifNotNil: [ self error: 'a boolean condition can''t take arguments'. ].
		^ DABooleanCondition value: aBlockOrBoolean.
	].

	self error: 'condition must either be a block or a boolean value'.! !

!DACondition methodsFor: 'composing' stamp: 'as 3/7/2008 10:00'!
and: aDACondition

	^ DAAndCondition with: self with: aDACondition.! !

!DACondition methodsFor: 'accessing' stamp: 'as 3/7/2008 10:18'!
arguments

	self subclassResponsibility.! !

!DACondition methodsFor: 'pretending' stamp: 'as 3/10/2008 15:01'!
blockArgNames

	^ self arguments.! !

!DACondition methodsFor: 'accessing' stamp: 'as 3/7/2008 10:17'!
condition

	"Disables inlining in GPTransformer."

	^ self.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:35'!
doValue

	self subclassResponsibility.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:35'!
doValueWithArguments: anArray

	self subclassResponsibility.! !

!DACondition methodsFor: 'initialize-release' stamp: 'as 2/8/2008 10:21'!
initialize

	negated _ false.! !

!DACondition methodsFor: 'pretending' stamp: 'as 3/10/2008 15:01'!
isBlock

	^ true.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:34'!
negatedValue: aBoolean

	^ aBoolean xor: negated.! !

!DACondition methodsFor: 'negating' stamp: 'as 2/8/2008 10:21'!
not

	negated _ negated not.! !

!DACondition methodsFor: 'accessing' stamp: 'as 3/7/2008 10:17'!
numArgs

	self subclassResponsibility.! !

!DACondition methodsFor: 'accessing' stamp: 'as 1/24/2008 12:15'!
reifications

	^ self arguments.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:35'!
value

	^ self negatedValue: self doValue.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 13:33'!
value: anObject

	^ self valueWithArguments: { anObject. }.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 13:34'!
value: anObjectA value: anObjectB

	^ self valueWithArguments: { anObjectA. anObjectB. }.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 13:34'!
value: anObjectA value: anObjectB value: anObjectC

	^ self valueWithArguments: { anObjectA. anObjectB. anObjectC. }.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 13:34'!
value: anObjectA value: anObjectB value: anObjectC value: anObjectD

	^ self valueWithArguments: { anObjectA. anObjectB. anObjectC. anObjectD. }.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:17'!
valueSelector

	self numArgs = 0 ifTrue: [ ^ #value. ].
	
	^ (String streamContents: [
		:stream | 
		stream nextPutAll: 'value:'.
		(self numArgs - 1) timesRepeat: [
			stream nextPutAll: 'value:'
		].
	]) asSymbol.! !

!DACondition methodsFor: 'evaluating' stamp: 'as 3/10/2008 14:35'!
valueWithArguments: anArray

	^ self negatedValue: (self doValueWithArguments: anArray).! !

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

Object subclass: #DAFilter
	instanceVariableNames: 'block negated'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities'!

!DAFilter commentStamp: 'as 2/21/2008 15:04' prior: 0!
Simply a block used as filter with an attribute that indicates if it's meaning is negated or not.!

!DAFilter class methodsFor: 'instance creation' stamp: 'as 2/21/2008 16:30'!
block: aBlock

	^ self new block: aBlock; yourself.! !

!DAFilter class methodsFor: 'instance creation' stamp: 'as 2/22/2008 11:15'!
category: regexString

	^ self string: regexString.! !

!DAFilter class methodsFor: 'instance creation' stamp: 'as 2/22/2008 11:15'!
class: regexString

	^ self name: regexString.! !

!DAFilter class methodsFor: 'instance creation' stamp: 'as 2/22/2008 11:16'!
method: regexString

	^ self selector: regexString.! !

!DAFilter class methodsFor: 'instance creation' stamp: 'as 2/22/2008 11:50'!
name: aString

	^ self symbol: #name matches: aString.! !

!DAFilter class methodsFor: 'instance creation' stamp: 'as 2/22/2008 11:16'!
node: aBlock

	^ self block: aBlock.! !

!DAFilter class methodsFor: 'instance creation' stamp: 'as 2/22/2008 11:50'!
selector: aSymbol

	^ self symbol: #selector matches: aSymbol.! !

!DAFilter class methodsFor: 'instance creation' stamp: 'as 2/21/2008 17:55'!
string: aString

	^ self block: [
		:each |
		aString match: each.
	].! !

!DAFilter class methodsFor: 'instance creation' stamp: 'as 2/22/2008 11:50'!
symbol: aSymbol matches: aString

	^ self block: [
		:each |
		aString match: (each perform: aSymbol).
	].! !

!DAFilter methodsFor: 'accessing' stamp: 'as 2/21/2008 15:05'!
block

	^ block.! !

!DAFilter methodsFor: 'accessing' stamp: 'as 2/21/2008 15:05'!
block: aBlock

	block _ aBlock.! !

!DAFilter methodsFor: 'initialize-release' stamp: 'as 2/21/2008 15:04'!
initialize

	negated _ false.! !

!DAFilter methodsFor: 'testing' stamp: 'as 2/21/2008 15:53'!
isNegated

	^ negated.! !

!DAFilter methodsFor: 'testing' stamp: 'as 2/21/2008 15:52'!
matches: anObject

	^ (block value: anObject) xor: negated.! !

!DAFilter methodsFor: 'negating' stamp: 'as 2/21/2008 15:04'!
negate

	negated _ negated not.! !

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

!DALink methodsFor: 'aliases' stamp: 'as 2/21/2008 16:13'!
category: aDAFilter

	self filterAt: #category put: aDAFilter.! !

!DALink methodsFor: 'aliases' stamp: 'as 2/22/2008 11:45'!
class: aDAFilter

	self filterAt: #class put: aDAFilter.! !

!DALink methodsFor: 'filtering' stamp: 'as 2/22/2008 11:46'!
class: aClass matches: aDAFilter

	^ (aDAFilter matches: aClass) and: [
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

!DALink methodsFor: 'defaults' stamp: 'as 2/22/2008 11:18'!
defaultFiltersAt: aSymbol

	aSymbol = #category ifTrue: [ ^ { DAFilter string: '*'. }. ].
	aSymbol = #class ifTrue: [ ^ { DAFilter name: '*'. }. ].
	aSymbol = #method ifTrue: [ ^ { DAFilter selector: '*'. }. ].
	aSymbol = #node ifTrue: [ ^ { DAFilter node: [ :node | node isMethod. ]. }. ].
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

!DALink methodsFor: 'filtering' stamp: 'as 2/22/2008 11:46'!
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
				filter matches: method.
			].
		].
		methods addAll: classMethods.
	].
	^ methods collect: [ :each | each reflectiveMethod. ].! !

!DALink methodsFor: 'filtering' stamp: 'as 2/21/2008 16:11'!
filterNode

	| nodes methodNodes |

	nodes _ Set new.
	(self cacheAt: #method) do: [
		:each |
		methodNodes _ each nodes.
		(self defaultOrFiltersAt: #node) do: [
			:filter |
			methodNodes _ methodNodes select: [ :node | filter matches: node. ].
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

!DALink methodsFor: 'aliases' stamp: 'as 2/22/2008 11:53'!
method: aDAFilter

	self filterAt: #method put: aDAFilter.! !

!DALink methodsFor: 'aliases' stamp: 'as 2/4/2008 17:48'!
methods

	^ self cacheAt: #method.! !

!DALink methodsFor: 'aliases' stamp: 'as 2/22/2008 11:53'!
node: aDAFilter

	self filterAt: #node put: aDAFilter.! !

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
	category: 'DA-Pointcuts'!

!DAPointcut commentStamp: 'as 1/17/2008 14:11' prior: 0!
Pointcuts describe a set of join points. So far, the only type of join points are nodes in reflective methods.!

DAPointcut subclass: #DACompositePointcut
	instanceVariableNames: 'children'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DACompositePointcut commentStamp: 'as 2/8/2008 11:26' prior: 0!
A composition of two pointcuts.!

DACompositePointcut subclass: #DAAndPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

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
	category: 'DA-Pointcuts'!

!DAOrPointcut commentStamp: 'as 1/31/2008 17:06' prior: 0!
Selects all join points that fullfill either's pointcut requirements.!

!DAOrPointcut methodsFor: 'inverting' stamp: 'as 2/5/2008 15:42'!
invert

	^ DAAndPointcut children: children.! !

!DAOrPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:03'!
visitName

	^ 'or'.! !

DAPointcut subclass: #DAConditionPointcut
	instanceVariableNames: 'condition'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

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

!DAConditionPointcut methodsFor: 'designating' stamp: 'as 3/10/2008 15:09'!
condition: aBlockOrBoolean arguments: args

	condition _ DACondition with: aBlockOrBoolean arguments: args.! !

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
	category: 'DA-Pointcuts'!

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

!DAControlFlowPointcut methodsFor: 'private' stamp: 'as 3/10/2008 17:01'!
conditionBlock

	^ [
		:context |
		| context m nesting result |
		context _ context sender.
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

DAPointcut subclass: #DAFilterPointcut
	instanceVariableNames: 'filter inverted'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DAFilterPointcut commentStamp: 'as 1/31/2008 16:58' prior: 0!
Specifies a filter for designating join points.!

DAFilterPointcut subclass: #DACategoryPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DACategoryPointcut commentStamp: 'as 1/31/2008 16:39' prior: 0!
Filter for categories.!

!DACategoryPointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:29'!
visitName

	^ 'category'.! !

DAFilterPointcut subclass: #DAClassPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DAClassPointcut commentStamp: 'as 1/31/2008 16:40' prior: 0!
Filter for classes.!

!DAClassPointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:46'!
visitName

	^ 'class'.! !

!DAFilterPointcut class methodsFor: 'instance creation' stamp: 'as 2/21/2008 17:11'!
filter: aDAFilter

	^ self new filter: aDAFilter; yourself.! !

!DAFilterPointcut methodsFor: 'accessing' stamp: 'as 1/31/2008 16:59'!
filter

	^ filter.! !

!DAFilterPointcut methodsFor: 'accessing' stamp: 'as 2/21/2008 16:20'!
filter: aDAFilter

	filter _ aDAFilter.! !

!DAFilterPointcut methodsFor: 'inverting' stamp: 'as 2/11/2008 08:46'!
not

	filter negate.! !

DAFilterPointcut subclass: #DAMethodPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DAMethodPointcut commentStamp: 'as 1/31/2008 16:42' prior: 0!
Filter for methods.!

!DAMethodPointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:47'!
visitName

	^ 'method'.! !

DAFilterPointcut subclass: #DANodePointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DANodePointcut commentStamp: 'as 1/31/2008 16:41' prior: 0!
Filter the nodes within a reflective method (sub-method level).!

!DANodePointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:48'!
visitName

	^ 'node'.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/3/2008 11:54'!
call: aMethod

	| methodDescr |
	
	methodDescr _ DAClassMethodDescription method: aMethod.
	^ (self method: aMethod) and: (
		self if: [
			:args |
			(args at: #class) name = methodDescr method.
		] arguments: #(class)
	).! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/21/2008 17:29'!
category: aSymbol

	^ self categoryName: aSymbol.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/22/2008 12:35'!
categoryName: regexString

	^ DACategoryPointcut categoryName: (DAFilter category: regexString).! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/21/2008 17:28'!
cflow: aMethod

	^ DAControlFlowPointcut method: aMethod.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 13:31'!
cflow: aMethod level: anInteger

	^ DAControlFlowPointcut method: aMethod level: anInteger.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/21/2008 17:29'!
class: aClass

	^ self className: aClass name.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/22/2008 12:35'!
className: regexString

	^ DAClassPointcut filter: (DAFilter class: regexString).! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/3/2008 11:55'!
classWithBehavior: aClass

	| classDescr |
	
	classDescr _ DAClassMethodDescription class: aClass.
	^ DAClassPointcut filter: (
		DAFilter block: [
			:class |
			class includesBehavior: classDescr class.
		]
	).! !

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

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/3/2008 12:00'!
globalVariable

	^ self node: [
		:node |
		node isVariable and: [ node isGlobal. ].
	].! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:23'!
if: aBlockOrBoolean

	^ DAConditionPointcut condition: aBlockOrBoolean.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 11:24'!
if: aBlockOrBoolean arguments: aCollection

	^ DAConditionPointcut condition: aBlockOrBoolean arguments: aCollection.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/3/2008 11:59'!
instanceVariable

	^ self node: [
		:node |
		node isVariable and: [ node isInstance. ].
	].! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/25/2008 15:48'!
message: regexString

	^ self node: [ :node | node isMessage and: [ regexString matches: node selector. ]. ].! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/21/2008 17:30'!
method: aMethod

	^ (DAClassPointcut class: aMethod methodClass) and: (self methodName: aMethod selector).! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/22/2008 12:36'!
methodName: regexString

	^ DAMethodPointcut filter: (DAFilter method: regexString).! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/22/2008 12:36'!
node: aBlock

	^ DANodePointcut filter: (DAFilter node: aBlock).! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/3/2008 11:59'!
tempVariable

	^ self node: [
		:node |
		node isVariable and: [ node isTemp. ].
	].! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 13:30'!
within: aMethod

	^ DAControlFlowPointcut method: aMethod level: 1.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:00'!
acceptVisitor: aDAPointcutVisitor

	aDAPointcutVisitor perform: ('visit', self visitName capitalized, ':') asSymbol with: self.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 1/24/2008 16:32'!
and: aDAPointcut

	^ DAAndPointcut child: self child: aDAPointcut.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 2/25/2008 09:53'!
genLinks

	^ self visitor visit: self; yourself.! !

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

!DAPointcut methodsFor: 'visiting' stamp: 'as 2/25/2008 09:53'!
visitor

	^ DALinkGenerator new.! !

Object subclass: #DAPointcutVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

!DAPointcutVisitor commentStamp: 'as 1/24/2008 17:04' prior: 0!
Visit a pointcut structure.!

DAPointcutVisitor subclass: #DALinkGenerator
	instanceVariableNames: 'links stack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

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

!DALinkGenerator methodsFor: 'visiting' stamp: 'as 2/21/2008 16:31'!
visitNode: pc

	links add: (DALink new node: pc filter).! !

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

!GPCondition class methodsFor: '*DA' stamp: 'as 3/6/2008 15:26'!
condition: aBooleanOrBlock arguments: args

	^ self new condition: aBooleanOrBlock; arguments: args; yourself.! !

!GPLink methodsFor: '*DA' stamp: 'as 12/12/2007 15:55'!
aspect

	properties ifNil: [ ^ nil. ].
	^self properties at: #aspect ifAbsent: [ nil. ].! !

!GPLink methodsFor: '*DA' stamp: 'as 12/12/2007 15:54'!
aspect: aDAAspect

	self properties at: #aspect put: aDAAspect.! !

!GPLink methodsFor: '*DA' stamp: 'as 3/10/2008 15:03'!
conditionObject: aDACondition

	condition _ aDACondition.! !

!Collection methodsFor: '*DA' stamp: 'as 1/31/2008 15:23'!
selfIfEmpty: aBlock

	self isEmpty ifTrue: [ ^ aBlock value. ] ifFalse: [ ^ self. ].! !

!BlockContext methodsFor: '*DA' stamp: 'as 3/3/2008 16:17'!
and: aBlock

	^ DACombinedBlock block: self block: aBlock message: #and:.! !

TestCase subclass: #DAAndPointcutTest
	instanceVariableNames: 'pointcut'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts-Tests'!

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
	category: 'DA-Pointcuts-Tests'!

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

TestCase subclass: #DAFilterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities-Tests'!

!DAFilterTest commentStamp: 'as 2/11/2008 08:40' prior: 0!
Testing DARegexFilter.!

!DAFilterTest methodsFor: 'testing' stamp: 'as 2/21/2008 17:55'!
testNegation

	| filter |

	filter _ DAFilter string: 'abc'.
	self assert: (filter matches: 'abc').
	filter negate.
	self deny: (filter matches: 'abc').! !

TestCase subclass: #DALinkGeneratorTest
	instanceVariableNames: 'generator pc'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel-Tests'!

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

!DALinkTest methodsFor: 'testing' stamp: 'as 2/22/2008 12:05'!
testAndingLinks

	| link2 link3 |

	link
		category: (DAFilter category: 'DA-Geppetto-Tests');
		class: (DAFilter class: 'DALinkTest').
	link2 _ DALink new
		method: (DAFilter method: 'testAndingLinks');
		node: (DAFilter node: [ :node | node isMethodNode. ]);
		yourself.
	link3 _ link and: link2.
	self assert: (link3 methods includes: (DALinkTest >> #testAndingLinks) reflectiveMethod).! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/22/2008 12:01'!
testFilteringCategories

	link category: (DAFilter category: 'DA*').
	self assert: (link categories includes: #'DA-Geppetto-Tests').! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/22/2008 12:04'!
testFilteringClasses

	link
		category: (DAFilter category: 'DA-Geppetto-Tests');
		class: (DAFilter class: 'DALinkTest').
	self assert: (link classes includes: DALinkTest).! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/22/2008 12:02'!
testFilteringMethods

	link
		category: (DAFilter category: 'DA-Geppetto-Tests');
		class: (DAFilter class: 'DALinkTest');
		method: (DAFilter method: 'testFilteringMethods').
	self assert: (link methods includes: (DALinkTest >> #testFilteringMethods) reflectiveMethod).! !

!DALinkTest methodsFor: 'testing' stamp: 'as 2/22/2008 12:04'!
testFilteringNodes

	link
		category: (DAFilter category: 'DA-Geppetto-Tests');
		class: (DAFilter class: 'DALinkTest');
		method: (DAFilter method: 'testFilteringNodes');
		node: (DAFilter node: [ :node | node isCascade. ]).
	self assert: (link nodes size = 1).! !

TestCase subclass: #DAOrPointcutTest
	instanceVariableNames: 'pointcut'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts-Tests'!

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

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/10/2008 16:49'!
testCombiningBlocks

	| cond1 cond2 combCond |
	
	cond1 _ DACondition
		with: [ :arg1 | arg1 = 1. ]
		arguments: #(arg1).
	cond2 _ DACondition
		with: [ :arg2 | arg2 = 2. ]
		arguments: #(arg2).
	combCond _ cond1 and: cond2.
	self assert: combCond arguments size = 2.
	self assert: (combCond arguments includes: #arg1).
	self assert: (combCond arguments includes: #arg2).
	self assert: (combCond value: 1 value: 2).! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/10/2008 16:07'!
testCombiningBooleanWithBlock

	| combCond |
	
	blockCond arguments: #(object class).
	combCond _ trueCond and: blockCond.
	self assert: combCond arguments asArray = blockCond arguments asArray.! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/10/2008 16:07'!
testCombiningBooleans

	self assert: (trueCond and: falseCond) value = false.
	self assert: (falseCond and: trueCond) value = false.
	self assert: (falseCond and: falseCond) value = false.
	self assert: (trueCond and: trueCond) value = true.! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/10/2008 16:56'!
testDeployment

	| link asserted condition |
	asserted _ false.
	link _ GPLink metaObject: [ asserted _ true. ].
	self cleanup: link.
	link before.
	condition _ DACondition
		with: [ :object | object = DAExamples. ]
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
	category: 'DA-Pointcuts-Tests'!

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

!DATestingWithLinks methodsFor: 'running' stamp: 'as 2/11/2008 15:06'!
setUp

	links _ Set new.! !

!DATestingWithLinks methodsFor: 'running' stamp: 'as 2/11/2008 15:07'!
tearDown

	links do: [ :link | link uninstall. ].! !
