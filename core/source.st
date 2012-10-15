SystemOrganization addCategory: #'DA-Context'!
SystemOrganization addCategory: #'DA-Condition'!
SystemOrganization addCategory: #'DA-Kernel'!
SystemOrganization addCategory: #'DA-Pointcuts'!
SystemOrganization addCategory: #'DA-Tests'!
SystemOrganization addCategory: #'DA-Utilities'!

Object subclass: #DAClassMethodDescription
	instanceVariableNames: 'className methodName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities'!

!DAClassMethodDescription commentStamp: 'as 3/25/2008 18:06' prior: 0!
I store a description of a method and it's class or just of a class, instead of the objects itself. Each time I'm asked for the method/class I will re-evaluate and return the proper object. This helps in case of method/class recompilations.!

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
	category: 'DA-Condition'!

!DACondition commentStamp: 'as 3/7/2008 09:48' prior: 0!
Extends GPCondition by the ability to combine multiple block conditions.!

DACondition subclass: #DAAndCondition
	instanceVariableNames: 'left right'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Condition'!

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

!DAAndCondition methodsFor: 'accessing' stamp: 'as 3/25/2008 14:27'!
arguments

	"The order in which the arguments of both conditions are merged is important."

	| args |

	args _ left arguments asOrderedCollection.
	right arguments do: [ :arg | (args includes: arg) ifFalse: [ args add: arg. ]. ].
	^ args asArray.! !

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
	category: 'DA-Condition'!

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
	category: 'DA-Condition'!

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

Object subclass: #DAContext
	instanceVariableNames: 'parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

DAContext subclass: #DAActiveContext
	instanceVariableNames: 'active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

!DAActiveContext methodsFor: 'activating' stamp: 'as 4/8/2008 16:54'!
activate

	self setActive: true.! !

!DAActiveContext methodsFor: 'activating' stamp: 'as 4/8/2008 16:54'!
deactivate

	self setActive: false.! !

!DAActiveContext methodsFor: 'initialize-release' stamp: 'as 4/8/2008 16:54'!
initialize

	active _ false.! !

!DAActiveContext methodsFor: 'testing' stamp: 'as 4/8/2008 16:56'!
isActive

	^ active.! !

!DAActiveContext methodsFor: 'activating' stamp: 'as 4/8/2008 16:54'!
setActive: aBoolean

	active _ aBoolean.! !

DAContext subclass: #DAComposedContext
	instanceVariableNames: 'children'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

DAComposedContext subclass: #DAAndContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

!DAAndContext methodsFor: 'testing' stamp: 'as 4/8/2008 17:05'!
isActive

	^ children inject: true into: [ :active :child | active & child isActive. ].! !

!DAComposedContext class methodsFor: 'instance creation' stamp: 'as 4/8/2008 17:08'!
context: aDAContext

	^ self contexts: { aDAContext. }.! !

!DAComposedContext class methodsFor: 'instance creation' stamp: 'as 4/8/2008 17:07'!
contexts: aCollection

	^ self new children: aCollection.! !

!DAComposedContext methodsFor: 'accessing' stamp: 'as 4/8/2008 17:08'!
children

	^ children.! !

!DAComposedContext methodsFor: 'accessing' stamp: 'as 4/8/2008 16:59'!
children: aCollection

	children _ aCollection.
	self setParent: aCollection.! !

!DAComposedContext methodsFor: 'initialize-release' stamp: 'as 4/8/2008 16:57'!
initialize

	children _ Set new.! !

!DAComposedContext methodsFor: 'private' stamp: 'as 4/8/2008 17:00'!
setParent: aCollection

	aCollection do: [ :each | each parent: self. ].! !

DAComposedContext subclass: #DANotContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

!DANotContext methodsFor: 'private' stamp: 'as 4/8/2008 17:15'!
child

	^ children first.! !

!DANotContext methodsFor: 'testing' stamp: 'as 4/8/2008 17:15'!
isActive

	^ self child isActive not.! !

!DANotContext methodsFor: 'composing' stamp: 'as 4/8/2008 17:15'!
not

	^ self child.! !

DAComposedContext subclass: #DAOrContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

!DAOrContext methodsFor: 'testing' stamp: 'as 4/8/2008 17:10'!
isActive

	^ children inject: false into: [ :active :child | active | child isActive. ].! !

!DAContext methodsFor: 'composing' stamp: 'as 4/8/2008 17:14'!
and: aDAContext

	^ DAAndContext contexts: { self. aDAContext. }.! !

!DAContext methodsFor: 'testing' stamp: 'as 4/8/2008 16:49'!
isActive

	self subclassResponsibility.! !

!DAContext methodsFor: 'composing' stamp: 'as 4/8/2008 17:14'!
not

	^ DANotContext context: self.! !

!DAContext methodsFor: 'testing' stamp: 'as 4/8/2008 16:50'!
notActive

	self isActive not.! !

!DAContext methodsFor: 'composing' stamp: 'as 4/8/2008 17:14'!
or: aDAContext

	^ DAOrContext contexts: { self. aDAContext. }.! !

!DAContext methodsFor: 'accessing' stamp: 'as 4/8/2008 17:01'!
parent

	^ parent.! !

!DAContext methodsFor: 'accessing' stamp: 'as 4/8/2008 17:01'!
parent: aDAContext

	parent _ aDAContext.! !

Object subclass: #DAExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAExamples commentStamp: 'as 4/4/2008 15:03' prior: 0!
Examples to test aspects, hooks and links on.!

!DAExamples class methodsFor: 'examples' stamp: 'as 4/4/2008 15:04'!
noop! !

Object subclass: #DAFilter
	instanceVariableNames: 'block negated'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities'!

!DAFilter commentStamp: 'as 3/25/2008 17:45' prior: 0!
A simple block used as filter with an attribute that indicates if it's meaning is negated or not.!

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

!DAFilter methodsFor: 'negating' stamp: 'as 4/7/2008 15:40'!
not

	negated _ negated not.! !

Object subclass: #DAHook
	instanceVariableNames: 'pointcut scope control links mo moDict selector arguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

!DAHook commentStamp: 'as 3/19/2008 17:38' prior: 0!
Connects pointcuts with advices.!

!DAHook class methodsFor: 'defaults' stamp: 'as 3/20/2008 16:08'!
defaultControl

	^ #before.! !

!DAHook class methodsFor: 'defaults' stamp: 'as 4/3/2008 09:22'!
defaultScope

	^ #hook.! !

!DAHook class methodsFor: 'instance creation' stamp: 'as 4/7/2008 14:38'!
on: aDAPointcut do: aBlock

	^ (self on: aDAPointcut do: aBlock) selector: aBlock valueSelector; yourself.! !

!DAHook class methodsFor: 'instance creation' stamp: 'as 4/7/2008 14:37'!
on: aDAPointcut do: anObject with: aSymbol

	^ self new
		pointcut: aDAPointcut;
		control: self defaultControl;
		metaObject: anObject;
		scope: self defaultScope;
		selector: aSymbol;
		yourself.! !

!DAHook methodsFor: 'accessing' stamp: 'as 4/7/2008 13:55'!
arguments

	^ arguments.! !

!DAHook methodsFor: 'accessing' stamp: 'as 4/7/2008 13:54'!
arguments: anArray

	arguments _ anArray.! !

!DAHook methodsFor: 'accessing' stamp: 'as 3/20/2008 16:03'!
control

	^ control.! !

!DAHook methodsFor: 'accessing' stamp: 'as 3/20/2008 16:03'!
control: aSymbol

	control _ aSymbol.! !

!DAHook methodsFor: 'initialize-release' stamp: 'as 4/8/2008 17:30'!
initialize

	links _ Set new.
	self initializeMoDict.! !

!DAHook methodsFor: 'initialize-release' stamp: 'as 4/7/2008 14:17'!
initializeMoDict

	moDict _ Dictionary new.! !

!DAHook methodsFor: 'installation' stamp: 'as 4/7/2008 14:17'!
install

	self isInstalled ifFalse: [
		pointcut joinPoints do: [
			:jp |
			| link |
			link _ self newLink: jp.
			link hookOnJoinPoint: jp.
			links add: link.
		].
	].
		! !

!DAHook methodsFor: 'testing' stamp: 'as 3/23/2008 16:56'!
isInstalled

	^ links notEmpty.! !

!DAHook methodsFor: 'accessing' stamp: 'as 3/25/2008 09:20'!
links

	^ links.! !

!DAHook methodsFor: 'accessing' stamp: 'as 4/7/2008 13:54'!
metaObject

	^ mo.! !

!DAHook methodsFor: 'accessing' stamp: 'as 4/7/2008 13:54'!
metaObject: anObject

	mo _ anObject.! !

!DAHook methodsFor: 'accessing' stamp: 'as 4/7/2008 13:54'!
metaObjects

	^ metaObjects.! !

!DAHook methodsFor: 'private' stamp: 'as 4/8/2008 17:32'!
newLink: aDAJoinPoint

	| link |

	link _ GPLink new
		selector: selector;
		control: control;
		hook: self;
		yourself.
	arguments ifNotNil: [ link arguments: arguments. ].
	aDAJoinPoint condition ifNotNil: [ link conditionObject: aDAJoinPoint condition. ].
	aDAJoinPoint context ifNotNil: [ link addOnActiveContext: aDAJoinPoint context. ].
	self setMetaObject: link.
	
	^ link.! !

!DAHook methodsFor: 'accessing' stamp: 'as 3/20/2008 16:03'!
pointcut

	^ pointcut.! !

!DAHook methodsFor: 'accessing' stamp: 'as 3/20/2008 16:03'!
pointcut: aDAPointcut

	pointcut _ aDAPointcut.! !

!DAHook methodsFor: 'installation' stamp: 'as 4/7/2008 13:51'!
reinstall

	self uninstall; install.! !

!DAHook methodsFor: 'installation' stamp: 'as 4/7/2008 14:19'!
reset

	self initializeMoDict.
	pointcut reset.! !

!DAHook methodsFor: 'accessing' stamp: 'as 3/20/2008 16:02'!
scope

	^ scope.! !

!DAHook methodsFor: 'accessing' stamp: 'as 3/20/2008 16:02'!
scope: aSymbol

	scope _ aSymbol.! !

!DAHook methodsFor: 'accessing' stamp: 'as 4/7/2008 13:55'!
selector

	^ selector.! !

!DAHook methodsFor: 'accessing' stamp: 'as 4/7/2008 13:55'!
selector: aSymbol

	selector _ aSymbol.! !

!DAHook methodsFor: 'private' stamp: 'as 4/7/2008 14:19'!
setMetaObject: aGPLink

	scope = #hook ifTrue: [
		"Only one meta object."
		aGPLink metaObject: mo.
	] ifFalse: [
		"The link's dictionary of meta objects is hosted by the hook
		 and is the same for all links."
		aGPLink
			scope: scope;
			metaObjectCreator: mo;
			metaObject: moDict.
	].! !

!DAHook methodsFor: 'installation' stamp: 'as 3/23/2008 17:04'!
uninstall

	self isInstalled ifTrue: [
		links do: [ :link | link uninstall. ].
	].! !

!DAHook methodsFor: 'installation' stamp: 'as 4/7/2008 14:10'!
update

	self isInstalled ifTrue: [ self reinstall. ].! !

Object subclass: #DAJoinPoint
	instanceVariableNames: 'condition context filters cache'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

!DAJoinPoint commentStamp: 'as 3/25/2008 15:06' prior: 0!
Describes and caches the concrete nodes in the sysem that a pointcut describes. The evaluation of a pointcut will result in one or more join points.!

!DAJoinPoint methodsFor: 'composing' stamp: 'as 4/7/2008 15:56'!
and: aDAJoinPoint

	| jp |
	
	jp _ self class new.
	jp condition: (self combineCondition: jp).
	jp context: (self combineContext: jp).
	self keys do: [
		:key |
		jp filtersAt: key put: (self filtersAt: key), (aDAJoinPoint filtersAt: key).
	].		
	^ jp.! !

!DAJoinPoint methodsFor: 'caching' stamp: 'as 2/4/2008 17:30'!
cacheAt: aSymbol

	^ (cache at: aSymbol) ifNil: [ cache at: aSymbol put: (self filter: aSymbol). ].! !

!DAJoinPoint methodsFor: 'aliases' stamp: 'as 2/4/2008 17:48'!
categories

	^ self cacheAt: #category.! !

!DAJoinPoint methodsFor: 'aliases' stamp: 'as 2/21/2008 16:13'!
category: aDAFilter

	self filterAt: #category put: aDAFilter.! !

!DAJoinPoint methodsFor: 'aliases' stamp: 'as 2/22/2008 11:45'!
class: aDAFilter

	self filterAt: #class put: aDAFilter.! !

!DAJoinPoint methodsFor: 'filtering' stamp: 'as 2/22/2008 11:46'!
class: aClass matches: aDAFilter

	^ (aDAFilter matches: aClass) and: [
		(self cacheAt: #category) includes: aClass instanceSide category.
	].! !

!DAJoinPoint methodsFor: 'aliases' stamp: 'as 2/4/2008 17:48'!
classes

	^ self cacheAt: #class.! !

!DAJoinPoint methodsFor: 'private' stamp: 'as 3/25/2008 18:04'!
combineCondition: aDAJoinPoint

	self hasCondition ifTrue: [
		aDAJoinPoint hasCondition ifTrue: [
			^ self condition and: aDAJoinPoint condition.
		] ifFalse: [
			^ self condition.
		].
	] ifFalse: [
		aDAJoinPoint hasCondition ifTrue: [
			^ aDAJoinPoint condition.
		] ifFalse: [
			^ nil.
		].
	].! !

!DAJoinPoint methodsFor: 'private' stamp: 'as 4/7/2008 15:57'!
combineContext: aDAJoinPoint

	self hasContext ifTrue: [
		aDAJoinPoint hasContext ifTrue: [
			^ self context and: aDAJoinPoint context.
		] ifFalse: [
			^ self context.
		].
	] ifFalse: [
		aDAJoinPoint hasContext ifTrue: [
			^ aDAJoinPoint context.
		] ifFalse: [
			^ nil.
		].
	].! !

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 3/19/2008 14:59'!
condition

	^ condition.! !

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 3/19/2008 15:00'!
condition: aDACondition

	condition _ aDACondition.! !

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 4/7/2008 15:54'!
context

	^ context.! !

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 4/7/2008 15:54'!
context: aContext

	context _ aContext.! !

!DAJoinPoint methodsFor: 'defaults' stamp: 'as 2/22/2008 11:18'!
defaultFiltersAt: aSymbol

	aSymbol = #category ifTrue: [ ^ { DAFilter string: '*'. }. ].
	aSymbol = #class ifTrue: [ ^ { DAFilter name: '*'. }. ].
	aSymbol = #method ifTrue: [ ^ { DAFilter selector: '*'. }. ].
	aSymbol = #node ifTrue: [ ^ { DAFilter node: [ :node | node isMethod. ]. }. ].
	^ #().! !

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 2/4/2008 17:21'!
defaultOrFiltersAt: aSymbol

	^ (filters at: aSymbol) selfIfEmpty: [ self defaultFiltersAt: aSymbol. ].! !

!DAJoinPoint methodsFor: 'filtering' stamp: 'as 2/4/2008 17:55'!
filter: aSymbol

	^ self perform: (#filter, aSymbol capitalized) asSymbol.! !

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 3/25/2008 17:44'!
filterAt: aSymbol put: aRegexFilter

	(filters at: aSymbol) add: aRegexFilter.! !

!DAJoinPoint methodsFor: 'filtering' stamp: 'as 2/11/2008 08:30'!
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

!DAJoinPoint methodsFor: 'filtering' stamp: 'as 2/4/2008 17:26'!
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

!DAJoinPoint methodsFor: 'filtering' stamp: 'as 3/28/2008 12:56'!
filterMethod
	
	| methods classMethods |
	
	methods _ IdentitySet new.
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

!DAJoinPoint methodsFor: 'filtering' stamp: 'as 3/28/2008 12:58'!
filterNode

	| nodes methodNodes |

	nodes _ IdentitySet new.
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

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 2/4/2008 16:58'!
filtersAt: aSymbol

	^ filters at: aSymbol.! !

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 3/25/2008 17:44'!
filtersAt: aSymbol put: aCollection

	filters at: aSymbol put: aCollection.! !

!DAJoinPoint methodsFor: 'testing' stamp: 'as 3/19/2008 15:00'!
hasCondition

	^ condition notNil.! !

!DAJoinPoint methodsFor: 'testing' stamp: 'as 4/7/2008 15:55'!
hasContext

	^ context notNil.! !

!DAJoinPoint methodsFor: 'initialize-release' stamp: 'as 3/19/2008 15:01'!
initialize

	filters _ Dictionary new.
	cache _ Dictionary new.
	self initializeFilters.
	self initializeCache.! !

!DAJoinPoint methodsFor: 'initialize-release' stamp: 'as 2/4/2008 17:31'!
initializeCache

	self keys do: [
		:key |
		cache at: key put: nil.
	].! !

!DAJoinPoint methodsFor: 'initialize-release' stamp: 'as 2/4/2008 16:00'!
initializeFilters

	self keys do: [
		:key |
		filters at: key put: Set new.
	].! !

!DAJoinPoint methodsFor: 'initialize-release' stamp: 'as 2/4/2008 16:00'!
keys

	^ #(category class method node).! !

!DAJoinPoint methodsFor: 'aliases' stamp: 'as 2/22/2008 11:53'!
method: aDAFilter

	self filterAt: #method put: aDAFilter.! !

!DAJoinPoint methodsFor: 'aliases' stamp: 'as 3/28/2008 12:35'!
methods

	^ self cacheAt: #method.! !

!DAJoinPoint methodsFor: 'aliases' stamp: 'as 2/22/2008 11:53'!
node: aDAFilter

	self filterAt: #node put: aDAFilter.! !

!DAJoinPoint methodsFor: 'aliases' stamp: 'as 2/4/2008 17:48'!
nodes

	^ self cacheAt: #node.! !

!DAJoinPoint methodsFor: 'caching' stamp: 'as 2/4/2008 15:50'!
reset

	self initializeCache.! !

Object subclass: #DAPointcut
	instanceVariableNames: 'parent evaluator joinPoints'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

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

!DAAndPointcut methodsFor: 'negating' stamp: 'as 4/7/2008 15:45'!
negate

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

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 1/25/2008 14:30'!
left

	^ children first.! !

!DACompositePointcut methodsFor: 'negating' stamp: 'as 4/7/2008 15:45'!
negate

	self subclassResponsibility.! !

!DACompositePointcut methodsFor: 'negating' stamp: 'as 4/7/2008 15:45'!
not

	| negated |

	children do: [ :child | child not. ].
	negated _ self negate.
	self hasParent ifTrue: [ parent replace: self with: negated. ].
	^ negated.! !

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

!DAOrPointcut methodsFor: 'negating' stamp: 'as 4/7/2008 15:45'!
negate

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

!DAConditionPointcut methodsFor: 'negating' stamp: 'as 2/8/2008 10:40'!
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

DAPointcut subclass: #DAContextPointcut
	instanceVariableNames: 'context'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DAContextPointcut commentStamp: 'as 4/7/2008 15:20' prior: 0!
Describes contextual attributes.!

!DAContextPointcut class methodsFor: 'instance creation' stamp: 'as 4/7/2008 16:53'!
context: aContext

	^ self new context: aContext; yourself.! !

!DAContextPointcut methodsFor: 'accessing' stamp: 'as 4/7/2008 15:22'!
context

	^ context.! !

!DAContextPointcut methodsFor: 'accessing' stamp: 'as 4/8/2008 17:18'!
context: aDAContext

	context _ aDAContext.! !

!DAContextPointcut methodsFor: 'negating' stamp: 'as 4/8/2008 17:20'!
not

	context _ context not.! !

!DAContextPointcut methodsFor: 'visiting' stamp: 'as 4/7/2008 15:21'!
visitName

	^ 'context'.! !

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

!DACategoryPointcut class methodsFor: 'instance creation' stamp: 'as 3/25/2008 17:55'!
name: regexString

	^ self filter: (DAFilter category: regexString).! !

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

!DAClassPointcut class methodsFor: 'instance creation' stamp: 'as 3/25/2008 17:57'!
name: regexString

	^ self filter: (DAFilter class: regexString).! !

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

!DAFilterPointcut methodsFor: 'negating' stamp: 'as 4/7/2008 15:40'!
not

	filter not.! !

DAFilterPointcut subclass: #DAMethodPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DAMethodPointcut commentStamp: 'as 1/31/2008 16:42' prior: 0!
Filter for methods.!

!DAMethodPointcut class methodsFor: 'instance creation' stamp: 'as 3/25/2008 17:58'!
name: regexString

	^ self filter: (DAFilter method: regexString).! !

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

!DANodePointcut class methodsFor: 'instance creation' stamp: 'as 3/25/2008 17:59'!
block: aBlock

	^ self filter: (DAFilter node: aBlock).! !

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

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/25/2008 17:51'!
categoryName: regexString

	^ DACategoryPointcut name: regexString.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/21/2008 17:28'!
cflow: aMethod

	^ DAControlFlowPointcut method: aMethod.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 13:31'!
cflow: aMethod level: anInteger

	^ DAControlFlowPointcut method: aMethod level: anInteger.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/21/2008 17:29'!
class: aClass

	^ self className: aClass name.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 4/1/2008 15:50'!
class: aClass method: aSymbol

	^ self method: aClass >> aSymbol.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/25/2008 17:56'!
className: regexString

	^ DAClassPointcut name: regexString.! !

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

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 4/8/2008 17:19'!
context: aDAContext

	^ DAContextPointcut context: aDAContext.! !

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

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/25/2008 17:58'!
methodName: regexString

	^ DAMethodPointcut name: regexString.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/25/2008 17:59'!
node: aBlock

	^ DANodePointcut block: aBlock.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/3/2008 11:59'!
tempVariable

	^ self node: [
		:node |
		node isVariable and: [ node isTemp. ].
	].! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/1/2008 13:30'!
within: aMethod

	^ DAControlFlowPointcut method: aMethod level: 1.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 3/19/2008 15:19'!
acceptVisitor: aDAPointcutEvaluator

	aDAPointcutEvaluator perform: ('visit', self visitName capitalized, ':') asSymbol with: self.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 1/24/2008 16:32'!
and: aDAPointcut

	^ DAAndPointcut child: self child: aDAPointcut.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 3/19/2008 15:19'!
evaluator

	^ evaluator ifNil: [ evaluator _ DAPointcutEvaluator new. ].! !

!DAPointcut methodsFor: 'testing' stamp: 'as 2/4/2008 21:16'!
hasParent

	^ parent notNil.! !

!DAPointcut methodsFor: 'accessing' stamp: 'as 3/19/2008 15:29'!
joinPoints

	self evaluator hasEvaluated ifFalse: [ self evaluator visit: self. ].
	^ self evaluator joinPoints.! !

!DAPointcut methodsFor: 'accessing' stamp: 'as 3/31/2008 16:58'!
nodes

	^ self joinPoints inject: IdentitySet new into: [ :col :jp | col addAll: jp nodes; yourself. ].! !

!DAPointcut methodsFor: 'negating' stamp: 'as 2/4/2008 21:33'!
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

!DAPointcut methodsFor: 'caching' stamp: 'as 3/19/2008 15:25'!
reset

	self evaluator reset.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 1/24/2008 17:00'!
visitName

	self subclassResponsibility.! !

Object subclass: #DAPointcutEvaluator
	instanceVariableNames: 'joinPoints stack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

!DAPointcutEvaluator commentStamp: 'as 3/19/2008 15:46' prior: 0!
Goes over a pointcut structure and evaluates the corresponding join points.!

!DAPointcutEvaluator methodsFor: 'testing' stamp: 'as 3/31/2008 15:18'!
hasEvaluated

	^ joinPoints notNil.! !

!DAPointcutEvaluator methodsFor: 'initialize-release' stamp: 'as 3/19/2008 15:08'!
initialize

	joinPoints _ nil.
	stack _ Stack new.! !

!DAPointcutEvaluator methodsFor: 'initialize-release' stamp: 'as 3/19/2008 15:08'!
initializeJoinPoints

	joinPoints _ OrderedCollection new.! !

!DAPointcutEvaluator methodsFor: 'accessing' stamp: 'as 3/25/2008 17:38'!
joinPoints

	^ joinPoints.! !

!DAPointcutEvaluator methodsFor: 'stacking' stamp: 'as 1/25/2008 14:35'!
pop

	^ stack pop.! !

!DAPointcutEvaluator methodsFor: 'stacking' stamp: 'as 3/31/2008 15:18'!
push

	stack push: joinPoints.
	self initializeJoinPoints.! !

!DAPointcutEvaluator methodsFor: 'caching' stamp: 'as 3/19/2008 14:40'!
reset

	self initialize.! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 4/2/2008 16:41'!
visit: aDAPointcut

	self reset.
	self initializeJoinPoints.
	aDAPointcut acceptVisitor: self.! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 3/25/2008 18:02'!
visitAnd: pc

	pc left acceptVisitor: self.
	self push.
	pc right acceptVisitor: self.
	self push.
	self pop do: [
		:left |
		self pop do: [
			:right |
			joinPoints add: (left and: right).
		].
	].! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 3/19/2008 15:12'!
visitCategory: pc

	joinPoints add: (DAJoinPoint new category: pc filter).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 3/19/2008 15:12'!
visitClass: pc

	joinPoints add: (DAJoinPoint new class: pc filter).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 3/19/2008 15:15'!
visitCondition: pc

	joinPoints add: (DAJoinPoint new condition: pc condition).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 4/8/2008 17:19'!
visitContext: pc

	joinPoints add: (DAJoinPoint new context: pc context).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 3/19/2008 15:16'!
visitMethod: pc

	joinPoints add: (DAJoinPoint new method: pc filter).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 3/19/2008 15:16'!
visitNode: pc

	joinPoints add: (DAJoinPoint new node: pc filter).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 3/19/2008 15:16'!
visitOr: pc

	pc left acceptVisitor: self.
	self push.
	pc right acceptVisitor: self.
	joinPoints addAll: self pop.! !

!GPLink methodsFor: '*DA' stamp: 'as 3/10/2008 15:03'!
conditionObject: aDACondition

	condition _ aDACondition.! !

!GPLink methodsFor: '*DA' stamp: 'as 3/25/2008 15:08'!
hook

	properties ifNil: [ ^ nil. ].
	^self properties at: #hook ifAbsent: [ nil. ].! !

!GPLink methodsFor: '*DA' stamp: 'as 4/4/2008 15:02'!
hook: aDAHook

	self properties at: #hook put: aDAHook.! !

!GPLink methodsFor: '*DA' stamp: 'as 3/23/2008 16:58'!
hookOnJoinPoint: aDAJoinPoint

	aDAJoinPoint nodes do: [
		:node |
		self hookOn: node.
	].! !

!Behavior methodsFor: '*DA' stamp: 'as 3/31/2008 15:13'!
>>> selector 

	^ (self >> selector) reflectiveMethod.
! !

!Collection methodsFor: '*DA' stamp: 'as 3/31/2008 15:57'!
includesExactly: aCollection

	"Answer whether both collections include exactly the same elements."
	
	^ (self includesAllOf: aCollection) & (aCollection includesAllOf: self).! !

!Collection methodsFor: '*DA' stamp: 'as 1/31/2008 15:23'!
selfIfEmpty: aBlock

	self isEmpty ifTrue: [ ^ aBlock value. ] ifFalse: [ ^ self. ].! !

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

TestCase subclass: #DAConditionTest
	instanceVariableNames: 'trueBool falseBool trueBlock falseBlock altTrueBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAConditionTest commentStamp: 'as 1/27/2008 17:41' prior: 0!
Testing DACondition.!

!DAConditionTest class methodsFor: 'testing' stamp: 'as 2/18/2008 10:31'!
isAbstract

	^ false.! !

!DAConditionTest methodsFor: 'running' stamp: 'as 3/25/2008 13:36'!
altBlockArgs

	^ #(class).! !

!DAConditionTest methodsFor: 'running' stamp: 'as 3/25/2008 13:36'!
blockArgs

	^ #(object).! !

!DAConditionTest methodsFor: 'running' stamp: 'as 3/25/2008 13:36'!
setUp

	trueBool _ DACondition with: true.
	falseBool _ DACondition with: false.
	trueBlock _ DACondition with: [ :arg | true. ] arguments: self blockArgs.
	falseBlock _ DACondition with: [ :arg | false. ] arguments: self blockArgs.
	altTrueBlock _ DACondition with: [ :arg | true. ] arguments: self altBlockArgs.
	! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:46'!
testArgsBlock

	self assert: trueBlock arguments = self blockArgs.
	self assert: falseBlock arguments = self blockArgs.! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 14:28'!
testCombiningArgs

	| cond |
	
	cond _ trueBlock and: falseBlock.
	self assert: cond arguments = self blockArgs.
	cond _ trueBlock and: altTrueBlock.
	self assert: cond arguments = (self blockArgs, self altBlockArgs).! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:31'!
testCombiningBlocks

	| cond |
	
	cond _ trueBlock and: falseBlock.
	self deny: (cond value: nil).! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:42'!
testCombiningBooleanWithBlock

	| cond |
	
	cond _ trueBool and: trueBlock.
	self assert: (cond value: nil).
	self assert: (cond arguments = self blockArgs).! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:26'!
testCombiningBooleans

	| cond |
	cond _ trueBool and: falseBool.
	self deny: cond value.! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:34'!
testCommutativeBlocks

	| val1 val2 |

	val1 _ (trueBlock and: falseBool) value: nil.
	val2 _ (falseBool and: trueBool) value: nil.
	self assert: val1 = val2.! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:26'!
testCommutativeBooleans

	self assert: (trueBool and: falseBool) value = (falseBool and: trueBool) value.! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:22'!
testEmptyArgs

	self assert: trueBool arguments isEmpty.
	self assert: falseBool arguments isEmpty.! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:43'!
testFalseBlock

	self deny: (falseBlock value: nil).! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:26'!
testFalseBoolean

	self deny: falseBool value.! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:30'!
testNegatingBlock

	trueBlock not.
	self deny: (trueBlock value: nil).
	falseBlock not.
	self assert: (falseBlock value: nil).! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:29'!
testNegatingBoolean

	trueBool not.
	self deny: trueBool value.
	falseBool not.
	self assert: falseBool value.! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:27'!
testTrueBlock

	self assert: (trueBlock value: nil).! !

!DAConditionTest methodsFor: 'testing' stamp: 'as 3/25/2008 13:26'!
testTrueBoolean

	self assert: trueBool value.! !

TestCase subclass: #DAFilterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAFilterTest commentStamp: 'as 2/11/2008 08:40' prior: 0!
Testing DARegexFilter.!

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/7/2008 15:40'!
testNegation

	| filter |

	filter _ DAFilter string: 'abc'.
	self assert: (filter matches: 'abc').
	filter not.
	self deny: (filter matches: 'abc').! !

TestCase subclass: #DAJoinPointTest
	instanceVariableNames: 'jp'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAJoinPointTest commentStamp: 'as 1/31/2008 14:14' prior: 0!
Testing DALink.!

!DAJoinPointTest methodsFor: 'running' stamp: 'as 3/25/2008 17:42'!
setUp

	jp _ DAJoinPoint new.! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 3/31/2008 11:39'!
testAnding

	| jp1 jp2 |

	jp1 _ DAJoinPoint new class: (DAFilter class: 'Object').
	self assert: (jp1 classes includes: Object).
	
	jp2 _ DAJoinPoint new method: (DAFilter method: '=').
	self assert: (jp2 methods includes: (Integer >> #=) reflectiveMethod).
	
	jp _ jp1 and: jp2.
	self assert: (jp methods includes: (Object >> #=) reflectiveMethod).
	self assert: jp methods size = 1.! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 3/27/2008 16:39'!
testMultipleCategories

	jp category: (DAFilter category: 'Kernel-*').
	self assert: (jp categories includesAllOf: #(#'Kernel-Objects' #'Kernel-Processes')).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 3/28/2008 11:59'!
testMultipleClasses

	jp class: (DAFilter class: '*Object').
	self assert: (jp classes includesAllOf: { Object. ProtoObject. }).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 3/28/2008 12:15'!
testMultipleMethods

	jp
		class: (DAFilter class: 'ProtoObject');
		method: (DAFilter method: '*').
	self assert: (jp methods includesAllOf: {
		(ProtoObject >> #==) reflectiveMethod.
		(ProtoObject >> #become:) reflectiveMethod.
	}).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 3/28/2008 13:05'!
testMultipleNodes

	jp
		class: (DAFilter class: 'Object');
		method: (DAFilter method: 'class');
		node: (DAFilter node: [ :node | true. ]).
	self assert: (jp nodes includesAllOf:
		(Object >> #class) reflectiveMethod methodNode allChildren).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 3/25/2008 18:22'!
testSingleCategory

	jp category: (DAFilter category: 'Kernel-Objects').
	self assert: (jp categories includes: #'Kernel-Objects').! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 3/27/2008 16:13'!
testSingleClass

	jp class: (DAFilter class: 'Object').
	self assert: (jp classes includes: Object).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 3/27/2008 16:14'!
testSingleMethod

	jp
		class: (DAFilter class: 'Object');
		method: (DAFilter method: '=').
	self assert: (jp methods includes: (Object >> #=) reflectiveMethod).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 3/27/2008 16:38'!
testSingleNode

	jp
		class: (DAFilter class: 'Object');
		method: (DAFilter method: 'class');
		node: (DAFilter node: [ :node | node isMethod. ]).
	self assert: (jp nodes includes: (Object >> #class) reflectiveMethod methodNode).! !

TestCase subclass: #DAPointcutTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAPointcutTest commentStamp: 'as 3/31/2008 11:46' prior: 0!
Testing pointcuts.!

!DAPointcutTest methodsFor: 'testing' stamp: 'as 3/31/2008 17:00'!
testAnd

	| m pc |

	m _ Object >>> #=.
	pc _ (DAPointcut method: m) and: (DAPointcut methodName: '=').
	self assert: (pc nodes includesExactly: { m methodNode. }).! !

!DAPointcutTest methodsFor: 'testing' stamp: 'as 3/31/2008 17:00'!
testOr

	| m1 m2 pc |
	
	m1 _ Object >>> #=.
	m2 _ Object >>> #->.
	pc _ (DAPointcut method: m1) or: (DAPointcut method: m2).
	self assert: (pc nodes includesExactly: { m1 methodNode. m2 methodNode. }).! !

!DAPointcutTest methodsFor: 'testing' stamp: 'as 3/31/2008 11:59'!
testParent

	| pc |
	
	pc _ DACompositePointcut child: DAPointcut new child: DAPointcut new.

	pc children do: [
		:child |
		self assert: child parent == pc.
	].! !

TestCase subclass: #DATestWithLinks
	instanceVariableNames: 'links'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DATestWithLinks commentStamp: 'as 2/1/2008 13:57' prior: 0!
A test that uses Geppetto links.

This provides link cleanup at start/finish for any subclassed test.!

DATestWithLinks subclass: #DAHookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAHookTest commentStamp: 'as 4/1/2008 15:47' prior: 0!
Testing hooks.!

!DAHookTest class methodsFor: 'testing' stamp: 'as 4/3/2008 10:05'!
isAbstract

	^ false.! !

!DAHookTest methodsFor: 'testing' stamp: 'as 4/7/2008 14:36'!
testSimple

	| mo pc hook count |

	mo _ GPCounter new.
	pc _ DAPointcut class: DAExamples class method: #noop.
	hook _ DAHook on: pc do: mo with: #inc.	
	hook install.
	self cleanup: hook.

	count _ mo count.
	DAExamples noop.
	self assert: (count + 1) = mo count.! !

!DATestWithLinks class methodsFor: 'testing' stamp: 'as 2/18/2008 10:30'!
isAbstract

	^ true.! !

!DATestWithLinks methodsFor: 'running' stamp: 'as 2/11/2008 15:11'!
cleanup: aGPLink

	"Register aGPLink for cleanup in #tearDown"
	
	links add: aGPLink.! !

!DATestWithLinks methodsFor: 'running' stamp: 'as 2/11/2008 15:06'!
setUp

	links _ Set new.! !

!DATestWithLinks methodsFor: 'running' stamp: 'as 2/11/2008 15:07'!
tearDown

	links do: [ :link | link uninstall. ].! !
