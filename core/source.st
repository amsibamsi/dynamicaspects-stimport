SystemOrganization addCategory: #'DA-Aspects'!
SystemOrganization addCategory: #'DA-Condition'!
SystemOrganization addCategory: #'DA-Context'!
SystemOrganization addCategory: #'DA-Contexts'!
SystemOrganization addCategory: #'DA-Kernel'!
SystemOrganization addCategory: #'DA-Pointcuts'!
SystemOrganization addCategory: #'DA-Tests'!
SystemOrganization addCategory: #'DA-Utilities'!

!Collection methodsFor: '*DA' stamp: 'as 3/31/2008 15:57'!
includesExactly: aCollection

	"Answer whether both collections include exactly the same elements."
	
	^ (self includesAllOf: aCollection) & (aCollection includesAllOf: self).! !

!Collection methodsFor: '*DA' stamp: 'as 1/31/2008 15:23'!
selfIfEmpty: aBlock

	self isEmpty ifTrue: [ ^ aBlock value. ] ifFalse: [ ^ self. ].! !

!Behavior methodsFor: '*DA' stamp: 'as 3/31/2008 15:13'!
>>> selector 

	^ (self >> selector) reflectiveMethod.
! !

!CompiledMethod methodsFor: '*DA' stamp: 'as 4/18/2008 11:56'!
asDescription

	^ DAMethodDescription methodObject: self.! !

!CompiledMethod methodsFor: '*DA' stamp: 'as 4/17/2008 15:17'!
asPointcut

	^ DAMethodPointcut method: self.! !

!RBProgramNode methodsFor: '*DA' stamp: 'as 4/18/2008 12:09'!
reflectiveMethod

	^ self method parent.! !

!Class methodsFor: '*DA' stamp: 'as 4/18/2008 11:56'!
asDescription

	^ DAClassDescription classObject: self.! !

!SequenceableCollection methodsFor: '*DA' stamp: 'as 4/14/2008 10:24'!
copyAfterIndex: anIndex

	anIndex > self size ifTrue: [ ^ self copyEmpty. ].
	^ self copyFrom: anIndex to: self size.! !

!ReflectiveMethod methodsFor: '*DA' stamp: 'as 4/18/2008 11:56'!
asDescription

	^ DAMethodDescription methodObject: self.! !

!ReflectiveMethod methodsFor: '*DA' stamp: 'as 4/17/2008 15:18'!
asPointcut

	^ DAMethodPointcut method: self.! !

Object subclass: #DAAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

DAAspect class
	instanceVariableNames: 'mo moCreator moDict connectors'!

!DAAspect commentStamp: 'as 4/23/2008 13:42' prior: 0!
Combines several pointcuts and advices by hosting multiple connectors.!

DAAspect class
	instanceVariableNames: 'mo moCreator moDict connectors'!

!DAAspect class methodsFor: 'connecting' stamp: 'as 4/21/2008 16:29'!
after: aDAPointcut do: aSymbol

	^ (self on: aDAPointcut do: aSymbol)
		control: #after;
		yourself.! !

!DAAspect class methodsFor: 'connecting' stamp: 'as 4/21/2008 16:29'!
after: aDAPointcut do: aSymbol with: aCollection

	^ (self after: aDAPointcut do: aSymbol)
		arguments: aCollection;
		yourself.! !

!DAAspect class methodsFor: 'connecting' stamp: 'as 4/21/2008 16:32'!
before: aDAPointcut do: aSymbol

	^ (self on: aDAPointcut do: aSymbol)
		control: #before;
		yourself.! !

!DAAspect class methodsFor: 'connecting' stamp: 'as 4/21/2008 16:33'!
before: aDAPointcut do: aSymbol with: aCollection

	^ (self before: aDAPointcut do: aSymbol)
		arguments: aCollection;
		yourself.! !

!DAAspect class methodsFor: 'connecting' stamp: 'as 4/21/2008 16:33'!
beforeAndAfter: aDAPointcut do: aSymbol

	^ (self on: aDAPointcut do: aSymbol)
		control: #beforeafter;
		yourself.! !

!DAAspect class methodsFor: 'connecting' stamp: 'as 4/21/2008 16:33'!
beforeAndAfter: aDAPointcut do: aSymbol with: aCollection

	^ (self beforeAndAfter: aDAPointcut do: aSymbol)
		arguments: aCollection;
		yourself.! !

!DAAspect class methodsFor: 'connecting' stamp: 'as 4/22/2008 16:52'!
connections

	"Return a collection of instances of DAConnector."

	self subclassResponsibility.! !

!DAAspect class methodsFor: 'connecting' stamp: 'as 4/22/2008 15:30'!
connectors

	^ connectors ifNil: [ connectors _ self connections. ].! !

!DAAspect class methodsFor: 'installing' stamp: 'as 4/14/2008 17:31'!
disabled

	^ false.! !

!DAAspect class methodsFor: 'installing' stamp: 'as 4/22/2008 14:28'!
install

	self connectors do: [
		:con |
		con install.
	].! !

!DAAspect class methodsFor: 'connecting' stamp: 'as 4/21/2008 16:33'!
instead: aDAPointcut do: aSymbol

	^ (self on: aDAPointcut do: aSymbol)
		control: #instead;
		yourself.! !

!DAAspect class methodsFor: 'connecting' stamp: 'as 4/21/2008 16:34'!
instead: aDAPointcut do: aSymbol with: aCollection

	^ (self instead: aDAPointcut do: aSymbol)
		arguments: aCollection;
		yourself.! !

!DAAspect class methodsFor: 'private' stamp: 'as 4/14/2008 16:53'!
metaObject

	^ mo ifNil: [ mo _ self new. ].! !

!DAAspect class methodsFor: 'private' stamp: 'as 4/14/2008 16:59'!
metaObjectCreator

	^ moCreator ifNil: [ moCreator _ [ self new. ]. ].! !

!DAAspect class methodsFor: 'private' stamp: 'as 4/14/2008 17:12'!
metaObjectDict

	^ moDict ifNil: [ moDict _ Dictionary new. ].! !

!DAAspect class methodsFor: 'dependencies' stamp: 'as 4/11/2008 11:50'!
needs

	^ #().! !

!DAAspect class methodsFor: 'connecting' stamp: 'as 4/22/2008 16:51'!
on: aDAPointcut do: aSymbol

	| connector |

	self scope ifNil: [
		connector _ DAConnector on: aDAPointcut do: aSymbol on: self metaObject.
	] ifNotNil: [
		connector _ DAConnector on: aDAPointcut create: self metaObjectCreator per: self scope do: aSymbol.
	].

	^ connector aspect: self; yourself.! !

!DAAspect class methodsFor: 'dependencies' stamp: 'as 4/11/2008 11:52'!
provides

	^ #().! !

!DAAspect class methodsFor: 'installing' stamp: 'as 4/22/2008 16:53'!
reset

	connectors ifNotNil: [ connectors do: [ :con | con uninstall. ]. ].
	connectors _ nil.
	mo _ nil.
	moDict _ nil.
	moCreator _ nil.! !

!DAAspect class methodsFor: 'aspects' stamp: 'as 4/14/2008 15:47'!
scope

	^ nil.! !

!DAAspect class methodsFor: 'installing' stamp: 'as 4/22/2008 14:29'!
uninstall

	self connectors do: [
		:con |
		con uninstall.
	].! !

!DAAspect class methodsFor: 'dependencies' stamp: 'as 4/11/2008 11:52'!
uses

	^ #().! !

DAAspect subclass: #DAControlFlowAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Aspects'!

DAControlFlowAspect class
	instanceVariableNames: 'descriptions'!

!DAControlFlowAspect commentStamp: 'as 4/18/2008 12:07' prior: 0!
Monitor control flow for registered methods.!

DAControlFlowAspect class
	instanceVariableNames: 'descriptions'!

!DAControlFlowAspect class methodsFor: 'accessing' stamp: 'as 4/17/2008 16:09'!
addMethod: aMethod

	self descriptions add: aMethod asDescription.! !

!DAControlFlowAspect class methodsFor: 'connecting' stamp: 'as 4/22/2008 15:32'!
connections

	^ self descriptions inject: Set new into: [
		:set :description |
		| pc |
		pc _ description asPointcut.
		set add: (self before: pc do: #countUp: with: #(node)).
		set add: (self after: pc do: #countDown: with: #(node)).
		set.
	].! !

!DAControlFlowAspect class methodsFor: 'accessing' stamp: 'as 4/16/2008 16:18'!
descriptions

	^ descriptions ifNil: [ descriptions _ Set new. ].! !

!DAControlFlowAspect class methodsFor: 'initialize-release' stamp: 'as 4/17/2008 15:55'!
initialize

	" DAControlFlow initialize. "

	super initialize.
	Process addInstVarName: 'cflowCounters'.! !

!DAControlFlowAspect class methodsFor: 'accessing' stamp: 'as 4/17/2008 16:09'!
removeMethod: aMethod

	self descriptions remove: aMethod asDescription.! !

!DAControlFlowAspect methodsFor: 'advices' stamp: 'as 4/18/2008 12:10'!
countDown: aRBProgramNode

	self process flowOutOf: aRBProgramNode reflectiveMethod.! !

!DAControlFlowAspect methodsFor: 'advices' stamp: 'as 4/18/2008 12:10'!
countUp: aRBProgramNode

	self process flowInto: aRBProgramNode reflectiveMethod.! !

!DAControlFlowAspect methodsFor: 'private' stamp: 'as 4/18/2008 12:09'!
process

	^ Processor activeProcess.! !

Object subclass: #DAClassDescription
	instanceVariableNames: 'className'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities'!

!DAClassDescription commentStamp: 'as 4/18/2008 10:47' prior: 0!
A description of a class that evaluates to the real object if asked.!

!DAClassDescription class methodsFor: 'instance creation' stamp: 'as 4/18/2008 10:51'!
className: aClass

	^ self new className: aClass; yourself.! !

!DAClassDescription class methodsFor: 'instance creation' stamp: 'as 4/18/2008 10:50'!
classObject: aClass

	^ self new classObject: aClass; yourself.! !

!DAClassDescription methodsFor: 'comparing' stamp: 'as 4/18/2008 11:59'!
= aDAClassDescription

	^ className = aDAClassDescription className.! !

!DAClassDescription methodsFor: 'converting' stamp: 'as 4/18/2008 10:50'!
asPointcut

	^ DAPointcut class: self classObject.! !

!DAClassDescription methodsFor: 'accessing' stamp: 'as 4/18/2008 10:47'!
className

	^ className.! !

!DAClassDescription methodsFor: 'accessing' stamp: 'as 4/18/2008 10:47'!
className: aSymbol

	className _ aSymbol.! !

!DAClassDescription methodsFor: 'accessing' stamp: 'as 4/18/2008 11:08'!
classObject

	^ Smalltalk at: className ifAbsent: [ nil. ].! !

!DAClassDescription methodsFor: 'accessing' stamp: 'as 4/18/2008 10:47'!
classObject: aClass

	className _ aClass name asSymbol.! !

!DAClassDescription methodsFor: 'comparing' stamp: 'as 4/18/2008 10:48'!
hash

	^ className hash.! !

DAClassDescription subclass: #DAMethodDescription
	instanceVariableNames: 'methodName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities'!

!DAMethodDescription commentStamp: 'as 4/18/2008 12:06' prior: 0!
Describes a method plus it's class.!

!DAMethodDescription class methodsFor: 'instance creation' stamp: 'as 4/18/2008 11:47'!
className: classSymbol methodName: methodSymbol

	^ self new
		className: classSymbol;
		methodName: methodSymbol;
		yourself.! !

!DAMethodDescription class methodsFor: 'instance creation' stamp: 'as 4/18/2008 11:47'!
methodObject: aMethod

	^ self new methodObject: aMethod; yourself.! !

!DAMethodDescription methodsFor: 'comparing' stamp: 'as 4/18/2008 11:59'!
= aDAMethodDescription

	^ super = aDAMethodDescription and:
		[ methodName = aDAMethodDescription methodName. ].! !

!DAMethodDescription methodsFor: 'converting' stamp: 'as 4/18/2008 11:57'!
asPointcut

	^ DAPointcut method: self methodObject.! !

!DAMethodDescription methodsFor: 'accessing' stamp: 'as 4/18/2008 11:48'!
className: classSymbol methodName: methodSymbol

	className _ classSymbol.
	methodName _ methodSymbol.! !

!DAMethodDescription methodsFor: 'comparing' stamp: 'as 4/18/2008 12:01'!
hash

	^ (className, methodName) hash.! !

!DAMethodDescription methodsFor: 'accessing' stamp: 'as 4/18/2008 11:50'!
methodName

	^ methodName.! !

!DAMethodDescription methodsFor: 'accessing' stamp: 'as 4/18/2008 11:55'!
methodName: aSymbol

	methodName _ aSymbol.! !

!DAMethodDescription methodsFor: 'accessing' stamp: 'as 4/18/2008 11:53'!
methodObject

	^ self classObject ifNotNil: [
		self classObject compiledMethodAt: methodName ifAbsent: [ nil. ]. ].! !

!DAMethodDescription methodsFor: 'accessing' stamp: 'as 4/18/2008 11:50'!
methodObject: aMethod

	self classObject: aMethod methodClass.
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

!DABlockCondition methodsFor: 'accessing' stamp: 'as 4/23/2008 16:36'!
block

	^ block.! !

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

!DACondition methodsFor: 'composing' stamp: 'as 4/9/2008 15:12'!
& aDACondition

	^ self and: aDACondition.! !

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

Object subclass: #DAConnector
	instanceVariableNames: 'installed pointcut scope control links mo moCreator selector arguments aspect'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

!DAConnector commentStamp: 'as 4/23/2008 13:43' prior: 0!
Connects a pointcut with an advices.!

!DAConnector class methodsFor: 'instance creation' stamp: 'as 4/14/2008 16:34'!
on: aDAPointcut create: aBlock per: scopeSymbol do: selectorSymbol

	^ self new
		pointcut: aDAPointcut;
		metaObjectCreator: aBlock;
		selector: selectorSymbol;
		scope: scopeSymbol;
		yourself.! !

!DAConnector class methodsFor: 'instance creation' stamp: 'as 4/14/2008 16:35'!
on: aDAPointcut do: aSymbol on: anObject

	^ self new
		pointcut: aDAPointcut;
		metaObject: anObject;
		selector: aSymbol;
		yourself.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/14/2008 16:05'!
arguments

	^ arguments ifNil: [ arguments _ #(). ].! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/18/2008 15:40'!
arguments: aCollection

	arguments _ aCollection.
	links do: [ :link | link arguments: aCollection. ].! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/16/2008 14:21'!
aspect

	^ aspect.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/16/2008 14:21'!
aspect: aDAAspect

	aspect _ aDAAspect.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 3/20/2008 16:03'!
control

	^ control.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/18/2008 15:41'!
control: aSymbol

	control _ aSymbol.
	links do: [ :link | link control: aSymbol. ].! !

!DAConnector methodsFor: 'defaults' stamp: 'as 4/14/2008 16:17'!
defaultControl

	^ #before.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/21/2008 11:28'!
hookScope

	self scope: #hook.! !

!DAConnector methodsFor: 'initialize-release' stamp: 'as 4/21/2008 15:02'!
initialize

	links _ Set new.
	control _ self defaultControl.
	installed _ false.! !

!DAConnector methodsFor: 'installing' stamp: 'as 4/18/2008 15:43'!
install

	self isInstalled ifFalse: [
		pointcut joinPoints do: [
			:jp |
			| link |
			link _ self newLink: jp.
			link hookOnJoinPoint: jp.
			links add: link.
		].
		installed _ true.
	].
		! !

!DAConnector methodsFor: 'testing' stamp: 'as 4/18/2008 15:43'!
isInstalled

	^ installed.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 3/25/2008 09:20'!
links

	^ links.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/7/2008 13:54'!
metaObject

	^ mo.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/21/2008 11:39'!
metaObject: anObject

	mo _ anObject.
	moCreator _ nil.
	links do: [ :link | self setMetaObject: link. ].! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/14/2008 16:05'!
metaObjectCreator

	^ moCreator.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/21/2008 11:43'!
metaObjectCreator: aBlock

	moCreator _ aBlock.
	mo isDictionary ifFalse: [ mo _ Dictionary new. ].
	links do: [ :link | self setMetaObject: link. ].! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/21/2008 11:44'!
metaObjectCreator: aBlock dict: aDictionary

	"A bit a hack, but useful if the meta object dictionary is shared with the outside."
	
	moCreator _ aBlock.
	mo _ aDictionary.
	links do: [ :link | self setMetaObject: link. ].! !

!DAConnector methodsFor: 'private' stamp: 'as 4/21/2008 15:58'!
newLink: aDAJoinPoint

	| link |

	link _ GPLink new
		selector: selector;
		control: control;
		connector: self;
		yourself.
	arguments ifNotNil: [ link arguments: arguments. ].
	aDAJoinPoint condition ifNotNil: [ link conditionObject: aDAJoinPoint condition. ].
	aDAJoinPoint context ifNotNil: [ link addOnActiveContext: aDAJoinPoint context. ].
	self setMetaObject: link.
	scope ifNotNil: [ link moScope: scope. ].
	
	^ link.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 3/20/2008 16:03'!
pointcut

	^ pointcut.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/18/2008 15:46'!
pointcut: aDAPointcut

	pointcut _ aDAPointcut.
	self update.! !

!DAConnector methodsFor: 'installing' stamp: 'as 4/7/2008 13:51'!
reinstall

	self uninstall; install.! !

!DAConnector methodsFor: 'installing' stamp: 'as 4/7/2008 14:19'!
reset

	self initializeMoDict.
	pointcut reset.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 3/20/2008 16:02'!
scope

	^ scope.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/21/2008 15:16'!
scope: aSymbol

	aSymbol = #hook ifTrue: [
		scope _ nil.
		links do: [ :link | link noScope. ].
	] ifFalse: [
		scope = aSymbol.
		links do: [ :link | link moScope: aSymbol. ].
	].! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/7/2008 13:55'!
selector

	^ selector.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/18/2008 15:47'!
selector: aSymbol

	selector _ aSymbol.
	links do: [ :link | link selector: aSymbol. ].! !

!DAConnector methodsFor: 'private' stamp: 'as 4/21/2008 14:54'!
setMetaObject: aGPLink

	"The link's dictionary of meta objects is hosted by the hook
	 and is the same for all links."

	scope ifNotNil: [
		aGPLink metaObjectCreator: moCreator.
	].
	aGPLink metaObject: mo.! !

!DAConnector methodsFor: 'installing' stamp: 'as 4/18/2008 15:43'!
uninstall

	self isInstalled ifTrue: [
		links do: [
			:link |
			link uninstall.
			links remove: link.
		].
		installed _ false.
	].! !

!DAConnector methodsFor: 'installing' stamp: 'as 4/7/2008 14:10'!
update

	self isInstalled ifTrue: [ self reinstall. ].! !

Object subclass: #DAContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

!DAContext commentStamp: 'as 4/18/2008 12:11' prior: 0!
A simple implementation of contexts, as it is used in Context-oriented programming. This is a rewrite of the existing Context class from Reflectivity.!

DAContext subclass: #DAActiveContext
	instanceVariableNames: 'active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

!DAActiveContext commentStamp: 'as 4/9/2008 16:33' prior: 0!
An active context can be activated/deactivated.!

!DAActiveContext class methodsFor: 'composing' stamp: 'as 4/9/2008 16:22'!
& aDAContextOrActiveContextClass

	^ self and: aDAContextOrActiveContextClass.! !

!DAActiveContext class methodsFor: 'composing' stamp: 'as 4/9/2008 16:24'!
and: aDAContextOrActiveContextClass

	^ self current and: aDAContextOrActiveContextClass.! !

!DAActiveContext class methodsFor: 'instance creation' stamp: 'as 4/9/2008 15:23'!
current

	^ Processor activeProcess ctxtEnvironmentAt: self ifAbsentPut: [ self new. ].! !

!DAActiveContext class methodsFor: 'composing' stamp: 'as 4/9/2008 15:41'!
not

	^ self current not.! !

!DAActiveContext class methodsFor: 'composing' stamp: 'as 4/9/2008 16:24'!
or: aDAContextOrActiveContextClass

	^ self current or: aDAContextOrActiveContextClass.! !

!DAActiveContext class methodsFor: 'composing' stamp: 'as 4/18/2008 14:00'!
processor

	^ self.! !

!DAActiveContext class methodsFor: 'composing' stamp: 'as 4/9/2008 16:22'!
| aDAContextOrActiveContextClass

	^ self or: aDAContextOrActiveContextClass.! !

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

!DAActiveContext methodsFor: 'composing' stamp: 'as 4/18/2008 14:00'!
processor

	^ self class.! !

!DAActiveContext methodsFor: 'activating' stamp: 'as 4/8/2008 16:54'!
setActive: aBoolean

	active _ aBoolean.! !

DAActiveContext subclass: #DAExampleContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Contexts'!

!DAExampleContext commentStamp: 'as 4/23/2008 16:42' prior: 0!
For example purposes.!

DAContext subclass: #DAComposedContext
	instanceVariableNames: 'children'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

!DAComposedContext commentStamp: 'as 4/9/2008 16:34' prior: 0!
Compose one or more contexts by any operation concerning the isActive evaluation.!

DAComposedContext subclass: #DAAndContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

!DAAndContext commentStamp: 'as 4/9/2008 16:46' prior: 0!
Logically and two contexts.!

!DAAndContext methodsFor: 'testing' stamp: 'as 4/18/2008 13:54'!
isActive

	^ children inject: true into: [ :active :child | active & child current isActive. ].! !

!DAComposedContext class methodsFor: 'instance creation' stamp: 'as 4/8/2008 17:08'!
context: aDAContext

	^ self contexts: { aDAContext. }.! !

!DAComposedContext class methodsFor: 'instance creation' stamp: 'as 4/8/2008 17:07'!
contexts: aCollection

	^ self new children: aCollection.! !

!DAComposedContext methodsFor: 'accessing' stamp: 'as 4/23/2008 17:09'!
child

	^ children anyOne.! !

!DAComposedContext methodsFor: 'accessing' stamp: 'as 4/8/2008 17:08'!
children

	^ children.! !

!DAComposedContext methodsFor: 'accessing' stamp: 'as 4/23/2008 16:56'!
children: aCollection

	children _ aCollection.! !

!DAComposedContext methodsFor: 'composing' stamp: 'as 4/18/2008 13:54'!
current

	^ self.! !

!DAComposedContext methodsFor: 'initialize-release' stamp: 'as 4/8/2008 16:57'!
initialize

	children _ Set new.! !

!DAComposedContext methodsFor: 'composing' stamp: 'as 4/18/2008 13:53'!
processor

	^ self.! !

DAComposedContext subclass: #DANotContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

!DANotContext commentStamp: 'as 4/9/2008 16:46' prior: 0!
Invert a context.!

!DANotContext methodsFor: 'private' stamp: 'as 4/8/2008 17:15'!
child

	^ children first.! !

!DANotContext methodsFor: 'testing' stamp: 'as 4/18/2008 13:57'!
isActive

	^ self child current notActive.! !

!DANotContext methodsFor: 'composing' stamp: 'as 4/8/2008 17:15'!
not

	^ self child.! !

DAComposedContext subclass: #DAOrContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

!DAOrContext commentStamp: 'as 4/9/2008 16:46' prior: 0!
Logically or two contexts.!

!DAOrContext methodsFor: 'testing' stamp: 'as 4/18/2008 13:58'!
isActive

	^ children inject: false into: [ :active :child | active | child current isActive. ].! !

!DAContext methodsFor: 'composing' stamp: 'as 4/9/2008 15:12'!
& aDAContext

	^ self and: aDAContext.! !

!DAContext methodsFor: 'composing' stamp: 'as 4/18/2008 13:51'!
and: aDAContextOrActiveContextClass

	^ DAAndContext contexts:
		{ self processor. aDAContextOrActiveContextClass processor. }.! !

!DAContext methodsFor: 'testing' stamp: 'as 4/8/2008 16:49'!
isActive

	self subclassResponsibility.! !

!DAContext methodsFor: 'composing' stamp: 'as 4/18/2008 13:52'!
not

	^ DANotContext context: self processor.! !

!DAContext methodsFor: 'testing' stamp: 'as 4/18/2008 12:14'!
notActive

	^ self isActive not.! !

!DAContext methodsFor: 'composing' stamp: 'as 4/18/2008 13:52'!
or: aDAContextOrActiveContextClass

	^ DAOrContext contexts:
		{ self processor. aDAContextOrActiveContextClass processor. }.! !

!DAContext methodsFor: 'composing' stamp: 'as 4/18/2008 13:53'!
processor

	"Something that when called #current will return the instance for the current process."

	self subclassResponsibility.! !

!DAContext methodsFor: 'composing' stamp: 'as 4/9/2008 15:13'!
| aDAContext

	^ self or: aDAContext.! !

DAContext subclass: #DAControlFlowContext
	instanceVariableNames: 'methodDescription minLevel maxLevel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Contexts'!

!DAControlFlowContext commentStamp: 'as 4/22/2008 14:26' prior: 0!
A context that is active if execution has entered a certain method and is at a certain nesting level of that method. Instances can only be created for specific methods.!

!DAControlFlowContext class methodsFor: 'instance creation' stamp: 'as 4/23/2008 17:02'!
inMethod: aMethod

	^ self in: aMethod min: 1 max: 0.! !

!DAControlFlowContext class methodsFor: 'instance creation' stamp: 'as 4/23/2008 17:02'!
inMethod: aMethod min: minNumber max: maxNumber

	^ self new
		method: aMethod;
		min: minNumber;
		max: maxNumber;
		yourself.! !

!DAControlFlowContext class methodsFor: 'instance creation' stamp: 'as 4/23/2008 17:02'!
withinMethod: aMethod

	^ self in: aMethod min: 1 max: 1.! !

!DAControlFlowContext methodsFor: 'testing' stamp: 'as 4/18/2008 14:56'!
isActive

	| count |
	
	count _ Processor activeProcess cflowCount: methodDescription.
	^ (count >= minLevel) & ((count <= maxLevel) | (maxLevel = 0)).! !

!DAControlFlowContext methodsFor: 'accessing' stamp: 'as 4/18/2008 14:41'!
max: aNumber

	maxLevel _ aNumber.! !

!DAControlFlowContext methodsFor: 'accessing' stamp: 'as 4/18/2008 14:38'!
method: aMethod

	methodDescription _ aMethod asDescription.! !

!DAControlFlowContext methodsFor: 'accessing' stamp: 'as 4/18/2008 14:41'!
min: aNumber

	minLevel _ aNumber.! !

Object subclass: #DAExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAExamples commentStamp: 'as 4/23/2008 13:45' prior: 0!
Examples to test aspects, connectors and links on.!

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

Object subclass: #DAJoinPoint
	instanceVariableNames: 'condition context filters cache'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

!DAJoinPoint commentStamp: 'as 4/23/2008 13:25' prior: 0!
References the concrete nodes in the sysem that a pointcut describes. The evaluation of a pointcut will result in one or more join points.!

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

!DAAndPointcut commentStamp: 'as 4/23/2008 13:43' prior: 0!
Describes all join points that fullfill all requirements of two pointcuts.!

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

DAPointcut subclass: #DAEmptyPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DAEmptyPointcut commentStamp: 'as 4/16/2008 15:53' prior: 0!
Selects nothing. Useful in some special cases.!

!DAEmptyPointcut methodsFor: 'visiting' stamp: 'as 4/16/2008 15:33'!
visitName

	^ 'empty'.! !

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

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 4/16/2008 15:55'!
empty

	^ DAEmptyPointcut new.! !

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

!DAPointcut methodsFor: 'composing' stamp: 'as 4/9/2008 15:11'!
& aDAPointcut

	^ self and: aDAPointcut.! !

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

!DAPointcut methodsFor: 'composing' stamp: 'as 4/9/2008 15:11'!
| aDAPointcut

	^ self or: aDAPointcut.! !

Object subclass: #DAPointcutEvaluator
	instanceVariableNames: 'joinPoints stack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

!DAPointcutEvaluator commentStamp: 'as 4/23/2008 13:43' prior: 0!
Goes over a pointcut structure and evaluates the corresponding join points for it.!

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

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 4/16/2008 15:56'!
visitEmpty: pc! !

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

TestCase subclass: #DACodingTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DACodingTest commentStamp: 'as 4/23/2008 13:45' prior: 0!
Testing coding guidelines.!

!DACodingTest methodsFor: 'testing' stamp: 'as 4/23/2008 14:52'!
classes

	^ (PackageInfo named: self packageName) classes.! !

!DACodingTest methodsFor: 'testing' stamp: 'as 4/23/2008 14:55'!
methods

	^ self classes inject: Set new into: [
		:set :class |
		set, class instanceSide methodDict, class classSide methodDict.
	].! !

!DACodingTest methodsFor: 'testing' stamp: 'as 4/23/2008 14:48'!
packageName

	^ 'DA'.! !

!DACodingTest methodsFor: 'testing' stamp: 'as 4/23/2008 14:52'!
testClassComment

	"Each class should have a comment."

	self classes do: [
		:each |
		self assert: each hasComment.
	].! !

!DACodingTest methodsFor: 'testing' stamp: 'as 4/23/2008 14:57'!
testMethodLength

	"No long methods."

	self methods do: [
		:each |
		self assert: each statements size < 15.
	].! !

TestCase subclass: #DAConditionTest
	instanceVariableNames: 'trueBool falseBool trueBlock falseBlock altTrueBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAConditionTest commentStamp: 'as 4/23/2008 13:44' prior: 0!
Testing conditions.!

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

TestCase subclass: #DAContextTest
	instanceVariableNames: 'example'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAContextTest commentStamp: 'as 4/23/2008 16:46' prior: 0!
Testing contexts.!

!DAContextTest methodsFor: 'running' stamp: 'as 4/23/2008 16:48'!
setUp

	example _ DAExampleContext current.! !

!DAContextTest methodsFor: 'testing' stamp: 'as 4/23/2008 16:48'!
testActivation

	example activate.
	self assert: example isActive.
	example deactivate.
	self assert: example notActive.! !

!DAContextTest methodsFor: 'testing' stamp: 'as 4/23/2008 17:04'!
testAnd

	| not and |

	not _ example not.
	and _ not & example.
	example activate.
	self assert: and notActive.
	example deactivate.
	self assert: and notActive.! !

!DAContextTest methodsFor: 'testing' stamp: 'as 4/23/2008 17:11'!
testClassSideCombination

	| not |

	not _ DAExampleContext not.
	self assert: not child == DAExampleContext.! !

!DAContextTest methodsFor: 'testing' stamp: 'as 4/23/2008 17:11'!
testInstanceSideCombination

	| not |

	not _ DAExampleContext current not.
	self assert: not child == DAExampleContext.! !

!DAContextTest methodsFor: 'testing' stamp: 'as 4/23/2008 16:50'!
testNot

	| not |

	not _ example not.
	example activate.
	self assert: not notActive.
	example deactivate.
	self assert: not isActive.! !

!DAContextTest methodsFor: 'testing' stamp: 'as 4/23/2008 17:05'!
testOr

	| not or |

	not _ example not.
	or _ not | example.
	example activate.
	self assert: or isActive.
	example deactivate.
	self assert: or isActive.! !

TestCase subclass: #DAFilterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAFilterTest commentStamp: 'as 4/23/2008 13:45' prior: 0!
Testing filtering.!

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:30'!
testCategory

	| filter |

	filter _ DAFilter category: 'DA-Tests'.
	self assert: (filter matches: #'DA-Tests').
	self deny: (filter matches: #'DA-Kernel').! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:40'!
testClass

	| filter |

	filter _ DAFilter class: 'Object'.
	self assert: (filter matches: Object).
	self deny: (filter matches: ProtoObject).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:32'!
testMethod

	| filter |

	filter _ DAFilter method: 'new'.
	self assert: (filter matches: Behavior >> #new).
	self assert: (filter matches: OrderedCollection class >> #new).
	self deny: (filter matches: Behavior >> #basicNew).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:29'!
testMultipleCategories

	| filter |

	filter _ DAFilter category: 'DA-*'.
	self assert: (filter matches: #'DA-Tests').
	self assert: (filter matches: #'DA-Kernel').
	self deny: (filter matches: #Kernel).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:40'!
testMultipleClasses

	| filter |

	filter _ DAFilter class: '*Object'.
	self assert: (filter matches: ProtoObject).
	self assert: (filter matches: Object).
	self deny: (filter matches: ObjectTest).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:48'!
testMultipleMethods

	| filter |

	filter _ DAFilter method: '>>*'.
	self assert: (filter matches: Behavior >> #>>).
	self assert: (filter matches: Behavior >> #>>>).
	self deny: (filter matches: Behavior >> #basicNew).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:49'!
testMultipleNodes

	| filter |

	filter _ DAFilter node: [ :node | node isReturn. ].
	self assert: (filter matches: (Object >>> #=) methodNode body statements first).
	self assert: (filter matches: (Object >>> #->) methodNode body statements first).
	self deny: (filter matches: (Object >>> #class) methodNode body statements first).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:12'!
testNegation

	| filter |

	filter _ DAFilter string: 'abc'.
	filter not.
	self deny: (filter matches: 'abc').! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:36'!
testNode

	| filter |

	filter _ DAFilter node: [ :node | node isReturn. ].
	self assert: (filter matches: (Object >>> #=) methodNode body statements first).
	self deny: (filter matches: (Object >>> #class) methodNode body statements first).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:37'!
testRegex

	| filter |

	filter _ DAFilter string: 'ab*'.
	self assert: (filter matches: 'abcccc').
	self deny: (filter matches: 'aabcccc').! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:38'!
testString

	| filter |

	filter _ DAFilter string: 'abc'.
	self assert: (filter matches: 'abc').
	self deny: (filter matches: 'bbc').! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/23/2008 15:38'!
testSymbol

	| filter |

	filter _ DAFilter symbol: #asString matches: 'an Object'.
	self assert: (filter matches: Object new).
	self deny: (filter matches: #Object).! !

TestCase subclass: #DAJoinPointTest
	instanceVariableNames: 'jp'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAJoinPointTest commentStamp: 'as 4/23/2008 13:45' prior: 0!
Testing join points.!

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

!DAPointcutTest methodsFor: 'testing' stamp: 'as 4/23/2008 16:17'!
testCategory

	| pc jp |

	pc _ DAPointcut category: #'Kernel-Classes'.
	jp _ pc joinPoints anyOne.
	self assert: (jp categories includesExactly: { #'Kernel-Classes'. }).! !

!DAPointcutTest methodsFor: 'testing' stamp: 'as 4/23/2008 16:18'!
testClass

	| pc jp |

	pc _ DAPointcut class: Object.
	jp _ pc joinPoints anyOne.
	self assert: (jp classes includesExactly: { Object. }).! !

!DAPointcutTest methodsFor: 'testing' stamp: 'as 4/23/2008 16:36'!
testCondition

	| con pc jp |

	con _ [ true. ].
	pc _ DAPointcut if: con.
	jp _ pc joinPoints anyOne.
	self assert: jp condition block = con.! !

!DAPointcutTest methodsFor: 'testing' stamp: 'as 4/23/2008 16:45'!
testContext

	| con pc jp |

	con _ DAExampleContext.
	pc _ DAPointcut context: con.
	jp _ pc joinPoints anyOne.
	self assert: jp context = con.! !

!DAPointcutTest methodsFor: 'testing' stamp: 'as 4/23/2008 16:23'!
testMethod

	| pc jp |

	pc _ DAPointcut method: Behavior >> #new.
	jp _ pc joinPoints anyOne.
	self assert: (jp nodes includesExactly: { (Behavior >>> #new) methodNode. }).! !

!DAPointcutTest methodsFor: 'testing' stamp: 'as 4/23/2008 16:33'!
testNode

	| pc jp |

	pc _ (DAPointcut node: [ :node | node isReturn. ]) and:
		(DAPointcut method: Behavior >> #new).
	jp _ pc joinPoints anyOne.
	self assert:
		(jp nodes includesExactly: { (Behavior >>> #new) methodNode body statements first. }).! !

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

DATestWithLinks subclass: #DAConnectorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAConnectorTest commentStamp: 'as 4/23/2008 13:44' prior: 0!
Testing connectors.!

!DAConnectorTest class methodsFor: 'testing' stamp: 'as 4/3/2008 10:05'!
isAbstract

	^ false.! !

!DAConnectorTest methodsFor: 'testing' stamp: 'as 4/23/2008 13:38'!
testSimple

	| mo pc con count |

	mo _ GPCounter new.
	pc _ DAPointcut class: DAExamples class method: #noop.
	con _ DAConnector on: pc do: #inc on: mo.	
	con install.
	self cleanup: con.

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

!GPLink methodsFor: '*DA' stamp: 'as 3/10/2008 15:03'!
conditionObject: aDACondition

	condition _ aDACondition.! !

!GPLink methodsFor: '*DA' stamp: 'as 4/22/2008 14:45'!
connector

	properties ifNil: [ ^ nil. ].
	^self properties at: #connector ifAbsent: [ nil. ].! !

!GPLink methodsFor: '*DA' stamp: 'as 4/22/2008 14:45'!
connector: aDAConnector

	self properties at: #connector put: aDAConnector.! !

!GPLink methodsFor: '*DA' stamp: 'as 3/23/2008 16:58'!
hookOnJoinPoint: aDAJoinPoint

	aDAJoinPoint nodes do: [
		:node |
		self hookOn: node.
	].! !

!GPLink methodsFor: '*DA' stamp: 'as 4/21/2008 15:19'!
noScope

	self properties removeKey: #moScope ifAbsent: [ self. ].! !

!Process methodsFor: '*DA' stamp: 'as 4/18/2008 13:30'!
cflowCount: aMethodDescription

	^ self cflowCounters at: aMethodDescription ifAbsent: [ 0. ].! !

!Process methodsFor: '*DA' stamp: 'as 4/17/2008 16:00'!
cflowCounters

	^ cflowCounters ifNil: [ cflowCounters _ Dictionary new. ].! !

!Process methodsFor: '*DA' stamp: 'as 4/22/2008 17:40'!
flowInto: aMethod

	| count |

	count _ self cflowCounters at: aMethod asDescription ifAbsentPut: [ 0. ].
	self cflowCounters at: aMethod asDescription put: count + 1.! !

!Process methodsFor: '*DA' stamp: 'as 4/22/2008 17:40'!
flowOutOf: aMethod

	| count |

	count _ self cflowCounters at: aMethod asDescription.
	self cflowCounters at: aMethod asDescription put: count - 1.! !
DAControlFlowAspect initialize!
