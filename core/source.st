SystemOrganization addCategory: #'DA-Browser'!
SystemOrganization addCategory: #'DA-Condition'!
SystemOrganization addCategory: #'DA-Connectors'!
SystemOrganization addCategory: #'DA-Context'!
SystemOrganization addCategory: #'DA-Contexts'!
SystemOrganization addCategory: #'DA-Kernel'!
SystemOrganization addCategory: #'DA-Pointcuts'!
SystemOrganization addCategory: #'DA-Examples'!
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

!Behavior methodsFor: '*DA' stamp: 'as 5/26/2008 23:20'!
notifyUsersOfChangedSelectors: aCollection

	"Make it possible that a class can also react on selector changes on the class side,
	 whose methods are actually in the method dictionary of the meta class and
	 managed there.
	
	 Remember that Behavior is a superclass for normal classes (like Object) and
	 meta classes (like Object class)."
	
	self theNonMetaClass notifyUsersOfChangedSelectors: aCollection meta: self isMeta.! !

!Behavior methodsFor: '*DA' stamp: 'as 5/26/2008 23:16'!
notifyUsersOfChangedSelectors: aCollection meta: aBoolean! !

!CompiledMethod methodsFor: '*DA' stamp: 'as 4/18/2008 11:56'!
asDescription

	^ DAMethodDescription methodObject: self.! !

!CompiledMethod methodsFor: '*DA' stamp: 'as 4/30/2008 15:41'!
asPointcut

	^ DAPointcut method: self.! !

!RBProgramNode methodsFor: '*DA' stamp: 'as 4/18/2008 12:09'!
reflectiveMethod

	^ self method parent.! !

TestCase subclass: #DAAspectTest
	instanceVariableNames: 'examples aspect'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAAspectTest commentStamp: 'as 5/21/2008 16:08' prior: 0!
Testing example aspects.!

!DAAspectTest methodsFor: 'initialize-release' stamp: 'as 5/22/2008 15:02'!
initialize

	examples _ DAExamples.! !

!DAAspectTest methodsFor: 'running' stamp: 'as 5/23/2008 11:31'!
setUp

	aspect _ DAExampleAspect mo.
	examples reset.
	aspect reset.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 5/22/2008 21:48'!
testAfter

	examples countA.
	self assert: examples count = 2.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 5/22/2008 15:46'!
testAspectIsInstalled

	"If the examples aspect is not installed, all tests here will fail."
	
	self assert: aspect class isInstalled.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 5/22/2008 21:48'!
testBefore

	examples countB.
	self assert: examples count = 1.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 5/22/2008 21:49'!
testInstead

	examples countI.
	self assert: examples count = 1.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 5/23/2008 12:17'!
testReifications

	! !

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

!DACodingTest methodsFor: 'testing' stamp: 'as 5/21/2008 13:43'!
testMethodLength

	"No long methods."

	self methods do: [
		:each |
		self assert: each statements size < 35.
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

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/30/2008 16:14'!
testCategory

	| filter |

	filter _ DAValueFilter categoryName: 'DA-Tests'.
	self assert: (filter matches: #'DA-Tests').
	self deny: (filter matches: #'DA-Kernel').! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/30/2008 16:14'!
testClass

	| filter |

	filter _ DAValueFilter className: 'Object'.
	self assert: (filter matches: Object).
	self deny: (filter matches: ProtoObject).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/30/2008 16:14'!
testMethod

	| filter |

	filter _ DAValueFilter methodName: 'new'.
	self assert: (filter matches: Behavior >> #new).
	self assert: (filter matches: OrderedCollection class >> #new).
	self deny: (filter matches: Behavior >> #basicNew).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/30/2008 16:14'!
testMultipleCategories

	| filter |

	filter _ DAValueFilter categoryName: 'DA-*'.
	self assert: (filter matches: #'DA-Tests').
	self assert: (filter matches: #'DA-Kernel').
	self deny: (filter matches: #Kernel).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/30/2008 16:14'!
testMultipleClasses

	| filter |

	filter _ DAValueFilter className: '*Object'.
	self assert: (filter matches: ProtoObject).
	self assert: (filter matches: Object).
	self deny: (filter matches: ObjectTest).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/30/2008 16:15'!
testMultipleMethods

	| filter |

	filter _ DAValueFilter methodName: '>>*'.
	self assert: (filter matches: Behavior >> #>>).
	self assert: (filter matches: Behavior >> #>>>).
	self deny: (filter matches: Behavior >> #basicNew).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/30/2008 16:15'!
testMultipleNodes

	| filter |

	filter _ DABlockFilter block: [ :node | node isReturn. ].
	self assert: (filter matches: (Object >>> #=) methodNode body statements first).
	self assert: (filter matches: (Object >>> #->) methodNode body statements first).
	self deny: (filter matches: (Object >>> #class) methodNode body statements first).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/30/2008 16:15'!
testNegation

	| filter |

	filter _ DAValueFilter value: 'abc'.
	filter not.
	self deny: (filter matches: 'abc').! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/30/2008 16:15'!
testNode

	| filter |

	filter _ DABlockFilter block: [ :node | node isReturn. ].
	self assert: (filter matches: (Object >>> #=) methodNode body statements first).
	self deny: (filter matches: (Object >>> #class) methodNode body statements first).! !

!DAFilterTest methodsFor: 'testing' stamp: 'as 4/30/2008 16:16'!
testRegex

	| filter |

	filter _ DAValueFilter value: 'ab*' comparator: #match:.
	self assert: (filter matches: 'abcccc').
	self deny: (filter matches: 'aabcccc').! !

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

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 5/21/2008 15:15'!
testAnding

	| jp1 jp2 |

	jp1 _ DAJoinPoint new class: (DAValueFilter class: Object).
	self assert: (jp1 classes includes: Object).
	
	jp2 _ DAJoinPoint new method: (DAValueFilter methodName: '=').
	self assert: (jp2 methods includes: (Integer >> #=) reflectiveMethod).
	
	jp _ jp1 and: jp2.
	self assert: (jp methods includes: (Object >> #=) reflectiveMethod).
	self assert: jp methods size = 1.! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 5/21/2008 14:23'!
testMultipleCategories

	jp category: (DAValueFilter categoryName: 'Kernel-*').
	self assert: (jp categories includesAllOf: #(#'Kernel-Objects' #'Kernel-Processes')).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 5/21/2008 14:23'!
testMultipleClasses

	jp class: (DAValueFilter className: '*Object').
	self assert: (jp classes includesAllOf: { Object. ProtoObject. }).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 5/21/2008 14:23'!
testMultipleMethods

	jp
		class: (DAValueFilter className: 'ProtoObject');
		method: (DAValueFilter methodName: '*').
	self assert: (jp methods includesAllOf: {
		(ProtoObject >> #==) reflectiveMethod.
		(ProtoObject >> #become:) reflectiveMethod.
	}).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 5/21/2008 14:22'!
testMultipleNodes

	jp
		class: (DAValueFilter className: 'Object');
		method: (DAValueFilter methodName: 'class');
		node: (DABlockFilter block: [ :node | true. ]).
	self assert: (jp nodes includesAllOf:
		(Object >> #class) reflectiveMethod methodNode allChildren).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 5/21/2008 15:13'!
testSingleCategory

	jp category: (DAValueFilter category: #'Kernel-Objects').
	self assert: (jp categories includes: #'Kernel-Objects').! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 5/21/2008 15:14'!
testSingleClass

	jp class: (DAValueFilter class: Object).
	self assert: (jp classes includes: Object).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 5/21/2008 15:15'!
testSingleMethod

	jp
		class: (DAValueFilter class: Object);
		method: (DAValueFilter methodName: '=').
	self assert: (jp methods includes: (Object >> #=) reflectiveMethod).! !

!DAJoinPointTest methodsFor: 'testing' stamp: 'as 5/21/2008 15:15'!
testSingleNode

	jp
		class: (DAValueFilter class: Object);
		method: (DAValueFilter methodName: 'class');
		node: (DABlockFilter block: [ :node | node isMethod. ]).
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

!DAConnectorTest methodsFor: 'testing' stamp: 'as 5/21/2008 15:22'!
testDeploy

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

!SequenceableCollection methodsFor: '*DA' stamp: 'as 4/14/2008 10:24'!
copyAfterIndex: anIndex

	anIndex > self size ifTrue: [ ^ self copyEmpty. ].
	^ self copyFrom: anIndex to: self size.! !

!ReflectiveMethod methodsFor: '*DA' stamp: 'as 4/18/2008 11:56'!
asDescription

	^ DAMethodDescription methodObject: self.! !

!ReflectiveMethod methodsFor: '*DA' stamp: 'as 4/30/2008 15:40'!
asPointcut

	^ DAPointcut method: self.! !

Object subclass: #DAClassDescription
	instanceVariableNames: 'className'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities'!

!DAClassDescription commentStamp: 'as 4/18/2008 10:47' prior: 0!
A description of a class that evaluates to the real object if asked.!

!DAClassDescription class methodsFor: 'instance creation' stamp: 'as 5/8/2008 15:17'!
className: aString

	^ self new className: aString; yourself.! !

!DAClassDescription class methodsFor: 'instance creation' stamp: 'as 4/18/2008 10:50'!
classObject: aClass

	^ self new classObject: aClass; yourself.! !

!DAClassDescription methodsFor: 'comparing' stamp: 'as 5/8/2008 15:25'!
= aDAClassDescription

	^ className = aDAClassDescription className.! !

!DAClassDescription methodsFor: 'converting' stamp: 'as 5/8/2008 15:25'!
asPointcut

	^ DAPointcut className: className.! !

!DAClassDescription methodsFor: 'accessing' stamp: 'as 4/18/2008 10:47'!
className

	^ className.! !

!DAClassDescription methodsFor: 'accessing' stamp: 'as 5/8/2008 15:26'!
className: aString

	className _ aString.! !

!DAClassDescription methodsFor: 'accessing' stamp: 'as 5/8/2008 15:47'!
classObject

	^ self isMeta ifTrue: [
		| c |
		c _ Smalltalk at: (className subStrings: ' ') first asSymbol ifAbsent: [ nil. ].
		c ifNotNil: [ c class. ].
	] ifFalse: [
		Smalltalk at: className asSymbol ifAbsent: [ nil. ].
	].! !

!DAClassDescription methodsFor: 'accessing' stamp: 'as 5/8/2008 15:13'!
classObject: aClass

	self className: aClass name.! !

!DAClassDescription methodsFor: 'comparing' stamp: 'as 4/18/2008 10:48'!
hash

	^ className hash.! !

!DAClassDescription methodsFor: 'testing' stamp: 'as 5/8/2008 15:47'!
isMeta

	^ className endsWith: ' class'.! !

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

!DAConnector commentStamp: 'as 5/2/2008 10:29' prior: 0!
Connects a pointcut with an advices. This is basically a wrapper around multiple GPLinks.!

!DAConnector class methodsFor: 'instance creation' stamp: 'as 4/14/2008 16:34'!
on: aDAPointcut create: aBlock per: scopeSymbol do: selectorSymbol

	^ self new
		pointcut: aDAPointcut;
		metaObjectCreator: aBlock;
		selector: selectorSymbol;
		scope: scopeSymbol;
		yourself.! !

!DAConnector class methodsFor: 'instance creation' stamp: 'as 5/6/2008 16:16'!
on: aDAPointcut do: aBlock

	^ self new
		pointcut: aDAPointcut;
		metaObject: aBlock;
		selector: aBlock valueSelector;
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

!DAConnector methodsFor: 'accessing' stamp: 'as 4/28/2008 13:49'!
arguments: aCollection

	self
		linksDo: [ :link | link key arguments: aCollection. ]
		rollback: [ :link | link key arguments: arguments. ].
	arguments _ aCollection.
	! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/16/2008 14:21'!
aspect

	^ aspect.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/16/2008 14:21'!
aspect: aDAAspect

	aspect _ aDAAspect.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 3/20/2008 16:03'!
control

	^ control.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/28/2008 13:49'!
control: aSymbol

	self
		linksDo: [ :link | link key control: aSymbol. ]
		rollback: [ :link | link key control: control. ].
	control _ aSymbol.! !

!DAConnector methodsFor: 'private' stamp: 'as 4/28/2008 14:04'!
createLinks


	links _ Dictionary new.
	pointcut joinPoints do: [
		:jp |
		links at: jp put: (self newLink: jp).
	].! !

!DAConnector methodsFor: 'defaults' stamp: 'as 4/28/2008 14:06'!
defaultControl

	^ #before.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 5/6/2008 16:18'!
dependencies

	^ pointcut dependencies.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/21/2008 11:28'!
hookScope

	self scope: #hook.! !

!DAConnector methodsFor: 'initialize-release' stamp: 'as 4/28/2008 13:49'!
initialize

	installed _ false.
	control _ self defaultControl.
	links _ Dictionary new.! !

!DAConnector methodsFor: 'installing' stamp: 'as 5/13/2008 17:45'!
install

	self dependencies do: [ :dep | dep install. ].
	self isInstalled ifFalse: [
		links ifEmpty: [ self createLinks. ].
		self
			linksDo: [ :link | link value hookOnJoinPoint: link key. ]
			rollback: [ :link | link value uninstall. ].
		installed _ true.
	].! !

!DAConnector methodsFor: 'testing' stamp: 'as 4/18/2008 15:43'!
isInstalled

	^ installed.! !

!DAConnector methodsFor: 'private' stamp: 'as 5/6/2008 13:37'!
linksDo: doBlock rollback: rollbackBlock

	| passed |
	
	links ifNil: [ ^ self. ].
	links ifEmpty: [ ^ self. ].

	passed _ Dictionary new.
	[
		links associationsDo: [
			:link |
			doBlock value: link.
			passed add: link.
		].
	] ensure: [
		passed = links ifFalse: [
			self rollback: rollbackBlock for: passed.
			self error: 'operation failed, rolled back'.
		].
	].! !

!DAConnector methodsFor: 'private' stamp: 'as 5/7/2008 16:49'!
mergeCondition: aDACondition withContext: aDAContext

	aDACondition ifNil: [
		aDAContext ifNil: [
			^ nil.
		] ifNotNil: [
			^ aDAContext asCondition.
		].
	] ifNotNil: [
		aDAContext ifNil: [
			^ aDACondition.
		] ifNotNil: [
			^ aDACondition and: aDAContext asCondition.
		].
	].! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/7/2008 13:54'!
metaObject

	^ mo.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/28/2008 13:51'!
metaObject: anObject

	self
		linksDo: [ :link | self setMetaObject: anObject creator: nil for: link key. ]
		rollback: [ :link | self setMetaObject: mo creator: moCreator for: link key. ].
	mo _ anObject.
	moCreator _ nil.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/14/2008 16:05'!
metaObjectCreator

	^ moCreator.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/28/2008 13:52'!
metaObjectCreator: aBlock

	| dict |
	
	mo isDictionary ifTrue: [ dict _ mo. ] ifFalse: [ dict _ Dictionary new. ].
	self
		linksDo: [ :link | self setMetaObject: dict creator: aBlock for: link key. ]
		rollback: [ :link | self setMetaObject: mo creator: moCreator for: link key. ].
		
	mo _ dict.
	moCreator _ aBlock.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/28/2008 13:52'!
metaObjectCreator: aBlock dict: aDictionary

	self
		linksDo: [ :link | self setMetaObject: aDictionary creator: aBlock for: link key. ]
		rollback: [ :link | self setMetaObject: mo creator: moCreator for: link key. ].
		
	mo _ aDictionary.
	moCreator _ aBlock.! !

!DAConnector methodsFor: 'private' stamp: 'as 5/7/2008 16:45'!
newLink: aDAJoinPoint

	| link condition |

	link _ GPLink new
		selector: selector;
		control: control;
		connector: self;
		yourself.
	arguments ifNotNil: [ link arguments: arguments. ].
	condition _ self mergeCondition: aDAJoinPoint condition withContext: aDAJoinPoint context.
	condition ifNotNil: [ link conditionObject: condition. ].
	self setMetaObject: mo creator: moCreator for: link.
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

!DAConnector methodsFor: 'installing' stamp: 'as 5/7/2008 17:02'!
reset

	| reinstall |

	reinstall _ false.
	self isInstalled ifTrue: [ self uninstall. reinstall _ true. ].
	links _ Dictionary new.
	mo isDictionary ifTrue: [ mo _ Dictionary new. ].
	pointcut reset.
	reinstall ifTrue: [ self install. ].! !

!DAConnector methodsFor: 'private' stamp: 'as 4/28/2008 14:16'!
rollback: aBlock for: aDictionary

	| failed |

	failed _ false.
	aDictionary associationsDo: [
		:link |
		[ aBlock value: link. ] on: Exception do: [
			failed _ true.
		].
	].
	failed ifTrue: [ self error: 'rollback failed'. ].! !

!DAConnector methodsFor: 'accessing' stamp: 'as 3/20/2008 16:02'!
scope

	^ scope.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 5/13/2008 14:56'!
scope: aSymbol

	| rollback |
	
	scope ifNil: [
		rollback _ [ :link | link key noScope. ].
	] ifNotNil: [
		rollback _ [ :link | link key moScope: scope. ].
	].

	aSymbol = #hook ifTrue: [
		self
			linksDo: [ :link | link key noScope. ]
			rollback: rollback.
		scope _ nil.
	] ifFalse: [
		self
			linksDo: [ :link | link key moScope: aSymbol. ]
			rollback: rollback.
		scope _ aSymbol.
	].! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/7/2008 13:55'!
selector

	^ selector.! !

!DAConnector methodsFor: 'accessing' stamp: 'as 4/28/2008 13:50'!
selector: aSymbol

	self
		linksDo: [ :link | link key selector: aSymbol. ]
		rollback: [ :link | link key selector: selector. ].
	selector _ aSymbol.! !

!DAConnector methodsFor: 'private' stamp: 'as 4/28/2008 11:16'!
setMetaObject: moObject creator: creatorObject for: aGPLink

	"The link's dictionary of meta objects is hosted by the hook
	 and is the same for all links."

	scope ifNotNil: [
		aGPLink metaObjectCreator: creatorObject.
	].
	aGPLink metaObject: moObject.! !

!DAConnector methodsFor: 'installing' stamp: 'as 5/13/2008 18:18'!
uninstall

	self isInstalled ifTrue: [
		self
			linksDo: [ :link | link value uninstall. ]
			rollback: [ :link | link value install. ].
		installed _ false.
	].
	self dependencies do: [ :dep | dep uninstall. ].! !

!DAConnector methodsFor: 'installing' stamp: 'as 4/7/2008 14:10'!
update

	self isInstalled ifTrue: [ self reinstall. ].! !

DAConnector subclass: #DAFlow
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Connectors'!

!DAFlow commentStamp: 'as 5/5/2008 17:10' prior: 0!
Manages control flow counting for a pointcut.!

!DAFlow class methodsFor: 'instance creation' stamp: 'as 5/5/2008 16:22'!
after: aDAPointcut

	^ self new
		pointcut: aDAPointcut;
		selector: #flowOut;
		control: #after;
		yourself.! !

!DAFlow class methodsFor: 'instance creation' stamp: 'as 5/5/2008 16:23'!
before: aDAPointcut

	^ self new
		pointcut: aDAPointcut;
		selector: #flowIn;
		control: #before;
		yourself.! !

!DAFlow methodsFor: 'counting' stamp: 'as 5/5/2008 16:23'!
flowIn

	Processor activeProcess flowInto: pointcut.! !

!DAFlow methodsFor: 'counting' stamp: 'as 5/5/2008 16:23'!
flowOut

	Processor activeProcess flowOutOf: pointcut.! !

!DAFlow methodsFor: 'initialize-release' stamp: 'as 5/6/2008 13:38'!
initialize

	super initialize.
	self metaObject: self.! !

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

DAActiveContext class
	instanceVariableNames: 'instance'!

!DAActiveContext commentStamp: 'as 4/9/2008 16:33' prior: 0!
An active context can be activated/deactivated.!

DAActiveContext class
	instanceVariableNames: 'instance'!

!DAActiveContext class methodsFor: 'composing' stamp: 'as 4/9/2008 16:22'!
& aDAContextOrActiveContextClass

	^ self and: aDAContextOrActiveContextClass.! !

!DAActiveContext class methodsFor: 'composing' stamp: 'as 4/9/2008 16:24'!
and: aDAContextOrActiveContextClass

	^ self current and: aDAContextOrActiveContextClass.! !

!DAActiveContext class methodsFor: 'converting' stamp: 'as 5/7/2008 16:40'!
asCondition

	| processor |
	
	processor _ self processor.
	^ DABlockCondition block: [ processor current isActive. ].! !

!DAActiveContext class methodsFor: 'instance creation' stamp: 'as 4/30/2008 16:35'!
current

	^ instance ifNil: [ instance _ self new. ].! !

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
	category: 'DA-Tests'!

!DAExampleContext commentStamp: 'as 4/23/2008 16:42' prior: 0!
For example purposes.!

DAActiveContext subclass: #DAPerProcessContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Context'!

!DAPerProcessContext commentStamp: 'as 4/30/2008 16:36' prior: 0!
The state is managed per process.!

!DAPerProcessContext class methodsFor: 'instance creation' stamp: 'as 4/30/2008 16:38'!
current

	^ Processor activeProcess ctxtEnvironmentAt: self ifAbsentPut: [ self new. ].! !

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

!DAComposedContext methodsFor: 'initialize-release' stamp: 'as 4/8/2008 16:57'!
initialize

	children _ Set new.! !

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

!DAContext methodsFor: 'converting' stamp: 'as 5/7/2008 16:39'!
asCondition

	| processor |
	
	processor _ self processor.
	^ DABlockCondition block: [ processor current isActive. ].! !

!DAContext methodsFor: 'composing' stamp: 'as 5/5/2008 10:37'!
current

	^ self.! !

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

!DAContext methodsFor: 'composing' stamp: 'as 5/7/2008 14:30'!
processor

	"Something that when called #current will return the instance for the current scope."

	^ self.! !

!DAContext methodsFor: 'composing' stamp: 'as 4/9/2008 15:13'!
| aDAContext

	^ self or: aDAContext.! !

DAContext subclass: #DAFlowContext
	instanceVariableNames: 'pointcut minLevel maxLevel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Contexts'!

!DAFlowContext commentStamp: 'as 4/22/2008 14:26' prior: 0!
A context that is active if execution has entered a certain method and is at a certain nesting level of that method. Instances can only be created for specific methods.!

!DAFlowContext class methodsFor: 'initialize-release' stamp: 'as 5/5/2008 11:43'!
initialize

	" DAFlowContext initialize. "

	super initialize.
	(Process allInstVarNames includes: 'flow') ifFalse: [ Process addInstVarName: 'flow'. ].! !

!DAFlowContext class methodsFor: 'instance creation' stamp: 'as 5/7/2008 14:35'!
pointcut: aDAPointcut

	^ self pointcut: aDAPointcut min: 1 max: 1.! !

!DAFlowContext class methodsFor: 'instance creation' stamp: 'as 5/7/2008 17:26'!
pointcut: aDAPointcut min: minNumber

	^ self pointcut: aDAPointcut min: minNumber max: 0.! !

!DAFlowContext class methodsFor: 'instance creation' stamp: 'as 5/7/2008 14:35'!
pointcut: aDAPointcut min: minNumber max: maxNumber

	^ self new
		pointcut: aDAPointcut;
		min: minNumber;
		max: maxNumber;
		yourself.! !

!DAFlowContext methodsFor: 'testing' stamp: 'as 5/7/2008 15:09'!
isActive

	| count |
	
	count _ Processor activeProcess flowAt: pointcut.
	^ (count >= minLevel) & ((count <= maxLevel) | (maxLevel = 0)).! !

!DAFlowContext methodsFor: 'accessing' stamp: 'as 4/18/2008 14:41'!
max: aNumber

	maxLevel _ aNumber.! !

!DAFlowContext methodsFor: 'accessing' stamp: 'as 4/18/2008 14:41'!
min: aNumber

	minLevel _ aNumber.! !

!DAFlowContext methodsFor: 'accessing' stamp: 'as 5/5/2008 10:39'!
pointcut: aDAPointcut

	pointcut _ aDAPointcut.! !

Object subclass: #DAExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

DAExamples class
	instanceVariableNames: 'count'!

!DAExamples commentStamp: 'as 4/23/2008 13:45' prior: 0!
Examples to test aspects, connectors and links on.!

DAExamples class
	instanceVariableNames: 'count'!

!DAExamples class methodsFor: 'counting' stamp: 'as 5/22/2008 18:44'!
count

	^ count ifNil: [ count _ 0. ].! !

!DAExamples class methodsFor: 'counting' stamp: 'as 5/22/2008 18:40'!
count: aNumber

	count _ aNumber.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 5/22/2008 18:40'!
countA

	count _ 1.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 5/22/2008 18:40'!
countB

	count _ 1.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 5/22/2008 18:41'!
countI

	count _ 1.! !

!DAExamples class methodsFor: 'counting' stamp: 'as 5/22/2008 18:44'!
inc

	count _ self count + 1.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 5/22/2008 18:41'!
inner

	self noop.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 4/4/2008 15:04'!
noop! !

!DAExamples class methodsFor: 'examples' stamp: 'as 5/6/2008 16:14'!
outer

	self inner.! !

!DAExamples class methodsFor: 'counting' stamp: 'as 5/22/2008 18:46'!
reset

	count _ nil.! !

Object subclass: #DAFilter
	instanceVariableNames: 'negated'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities'!

!DAFilter commentStamp: 'as 3/25/2008 17:45' prior: 0!
A simple block used as filter with an attribute that indicates if it's meaning is negated or not.!

DAFilter subclass: #DABlockFilter
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities'!

!DABlockFilter commentStamp: 'as 4/29/2008 16:54' prior: 0!
The filter evaluates a block for determining the match, which is very flexible, but rather non-transparent from outside.!

!DABlockFilter class methodsFor: 'instance creation' stamp: 'as 4/30/2008 16:11'!
block: aBlock

	^ self new
		block: aBlock;
		yourself.! !

!DABlockFilter methodsFor: 'accessing' stamp: 'as 4/29/2008 16:55'!
block

	^ block.! !

!DABlockFilter methodsFor: 'accessing' stamp: 'as 4/29/2008 16:55'!
block: aBlock

	block _ aBlock.! !

!DABlockFilter methodsFor: 'private' stamp: 'as 4/29/2008 16:56'!
doMatch: anObject

	^ block value: anObject.! !

!DAFilter methodsFor: 'private' stamp: 'as 4/29/2008 16:46'!
doMatch: anObject

	self subclassResponsibility.! !

!DAFilter methodsFor: 'filtering' stamp: 'as 4/29/2008 16:49'!
filter: aCollection

	^ aCollection select: [
		:each |
		self matches: each.
	].! !

!DAFilter methodsFor: 'initialize-release' stamp: 'as 2/21/2008 15:04'!
initialize

	negated _ false.! !

!DAFilter methodsFor: 'testing' stamp: 'as 2/21/2008 15:53'!
isNegated

	^ negated.! !

!DAFilter methodsFor: 'testing' stamp: 'as 4/29/2008 16:46'!
matches: anObject

	^ (self doMatch: anObject) xor: negated.! !

!DAFilter methodsFor: 'negating' stamp: 'as 4/29/2008 18:17'!
negated: aBoolean

	negated _ aBoolean.! !

!DAFilter methodsFor: 'negating' stamp: 'as 4/7/2008 15:40'!
not

	negated _ negated not.! !

DAFilter subclass: #DAValueFilter
	instanceVariableNames: 'value comparator evaluator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Utilities'!

!DAValueFilter commentStamp: 'as 4/29/2008 16:47' prior: 0!
Specify a simple value the filter will match against.!

!DAValueFilter class methodsFor: 'instance creation' stamp: 'as 4/30/2008 15:55'!
category: aSymbol

	^ self categoryName: aSymbol.! !

!DAValueFilter class methodsFor: 'instance creation' stamp: 'as 4/30/2008 15:52'!
categoryName: regexString

	^ self value: regexString comparator: #match:.! !

!DAValueFilter class methodsFor: 'instance creation' stamp: 'as 4/30/2008 15:56'!
class: aClass

	^ self className: aClass name.! !

!DAValueFilter class methodsFor: 'instance creation' stamp: 'as 4/30/2008 15:56'!
className: regexString

	^ self value: regexString comparator: #match: evaluator: #name.! !

!DAValueFilter class methodsFor: 'instance creation' stamp: 'as 4/30/2008 15:57'!
method: aMethod

	^ self methodName: aMethod selector.! !

!DAValueFilter class methodsFor: 'instance creation' stamp: 'as 4/30/2008 15:57'!
methodName: regexString

	^ self value: regexString comparator: #match: evaluator: #selector.! !

!DAValueFilter class methodsFor: 'instance creation' stamp: 'as 4/29/2008 16:03'!
value: anObject

	^ self new
		value: anObject;
		yourself.! !

!DAValueFilter class methodsFor: 'instance creation' stamp: 'as 4/29/2008 16:03'!
value: anObject comparator: aSymbol

	^ self new
		value: anObject;
		comparator: aSymbol;
		yourself.! !

!DAValueFilter class methodsFor: 'instance creation' stamp: 'as 4/29/2008 16:04'!
value: anObject comparator: compSymbol evaluator: evalSymbol

	^ self new
		value: anObject;
		comparator: compSymbol;
		evaluator: evalSymbol;
		yourself.! !

!DAValueFilter class methodsFor: 'instance creation' stamp: 'as 4/29/2008 16:04'!
value: anObject evaluator: aSymbol

	^ self new
		value: anObject;
		evaluator: aSymbol;
		yourself.! !

!DAValueFilter methodsFor: 'accessing' stamp: 'as 4/29/2008 15:53'!
comparator

	^ comparator ifNil: [ comparator _ self defaultComparator. ].! !

!DAValueFilter methodsFor: 'accessing' stamp: 'as 4/29/2008 15:48'!
comparator: aSymbol

	comparator _ aSymbol.! !

!DAValueFilter methodsFor: 'defaults' stamp: 'as 4/29/2008 16:06'!
defaultComparator

	^ #=.! !

!DAValueFilter methodsFor: 'defaults' stamp: 'as 4/29/2008 16:06'!
defaultEvaluator

	^ #yourself.! !

!DAValueFilter methodsFor: 'private' stamp: 'as 4/29/2008 16:50'!
doMatch: anObject

	^ value perform: self comparator with: (anObject perform: self evaluator).! !

!DAValueFilter methodsFor: 'accessing' stamp: 'as 4/29/2008 15:54'!
evaluator

	^ evaluator ifNil: [ evaluator _ self defaultEvaluator. ].! !

!DAValueFilter methodsFor: 'accessing' stamp: 'as 4/29/2008 15:48'!
evaluator: aSymbol

	evaluator _ aSymbol.! !

!DAValueFilter methodsFor: 'accessing' stamp: 'as 4/29/2008 16:01'!
value

	^ value.! !

!DAValueFilter methodsFor: 'accessing' stamp: 'as 4/29/2008 16:01'!
value: anObject

	value _ anObject.! !

Object subclass: #DAJoinPoint
	instanceVariableNames: 'condition context filters cache dependencies'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

!DAJoinPoint commentStamp: 'as 4/23/2008 13:25' prior: 0!
References the concrete nodes in the sysem that a pointcut describes. The evaluation of a pointcut will result in one or more join points.!

!DAJoinPoint methodsFor: 'composing' stamp: 'as 5/6/2008 17:27'!
and: aDAJoinPoint

	| jp |
	
	jp _ self class new.
	jp condition: (self combineCondition: aDAJoinPoint).
	jp context: (self combineContext: aDAJoinPoint).
	jp dependencies: self dependencies, aDAJoinPoint dependencies.
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

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 5/7/2008 16:28'!
context: aDAContext

	context _ aDAContext.! !

!DAJoinPoint methodsFor: 'defaults' stamp: 'as 4/30/2008 16:06'!
defaultFiltersAt: aSymbol

	aSymbol = #category ifTrue: [ ^ { DAValueFilter categoryName: '*'. }. ].
	aSymbol = #class ifTrue: [ ^ { DAValueFilter className: '*'. }. ].
	aSymbol = #method ifTrue: [ ^ { DAValueFilter methodName: '*'. }. ].
	aSymbol = #node ifTrue: [ ^ { DABlockFilter block: [ :node | node isMethod. ]. }. ].
	^ #().! !

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 2/4/2008 17:21'!
defaultOrFiltersAt: aSymbol

	^ (filters at: aSymbol) selfIfEmpty: [ self defaultFiltersAt: aSymbol. ].! !

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 5/6/2008 17:25'!
dependencies

	^ dependencies.! !

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 5/6/2008 17:25'!
dependencies: aCollection

	dependencies _ aCollection.! !

!DAJoinPoint methodsFor: 'filtering' stamp: 'as 2/4/2008 17:55'!
filter: aSymbol

	^ self perform: (#filter, aSymbol capitalized) asSymbol.! !

!DAJoinPoint methodsFor: 'accessing' stamp: 'as 5/6/2008 14:40'!
filterAt: aSymbol put: aDAFilter

	(filters at: aSymbol) add: aDAFilter.! !

!DAJoinPoint methodsFor: 'filtering' stamp: 'as 4/30/2008 16:50'!
filterCategory

	| categories |

	categories _ SystemOrganization categories.
	(self defaultOrFiltersAt: #category) do: [
		:filter |
		categories _ filter filter: categories.
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

!DAJoinPoint methodsFor: 'filtering' stamp: 'as 4/30/2008 16:53'!
filterMethod
	
	| methods classMethods |
	
	methods _ IdentitySet new.
	(self cacheAt: #class) do: [
		:each |
		classMethods _ each methods.
		(self defaultOrFiltersAt: #method) do: [
			:filter |
			classMethods _ filter filter: classMethods.
		].
		methods addAll: classMethods.
	].
	^ methods collect: [ :each | each reflectiveMethod. ].! !

!DAJoinPoint methodsFor: 'filtering' stamp: 'as 4/30/2008 16:53'!
filterNode

	| nodes methodNodes |

	nodes _ IdentitySet new.
	(self cacheAt: #method) do: [
		:each |
		methodNodes _ each nodes.
		(self defaultOrFiltersAt: #node) do: [
			:filter |
			methodNodes _ filter filter: methodNodes.
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

!DAJoinPoint methodsFor: 'initialize-release' stamp: 'as 5/6/2008 17:25'!
initialize

	filters _ Dictionary new.
	cache _ Dictionary new.
	dependencies _ Set new.
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
	instanceVariableNames: 'parent properties'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

!DAPointcut commentStamp: 'as 5/7/2008 15:04' prior: 0!
Pointcuts describe a set of join points.!

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

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 4/29/2008 17:30'!
left: aDAPointcut

	children replaceFrom: 1 to: 1 with: aDAPointcut.
	aDAPointcut parent: self.! !

!DACompositePointcut methodsFor: 'negating' stamp: 'as 4/7/2008 15:45'!
negate

	self subclassResponsibility.! !

!DACompositePointcut methodsFor: 'negating' stamp: 'as 4/29/2008 17:09'!
not

	| negated |

	children copy do: [ :child | child not. ].
	negated _ self negate.
	self hasParent ifTrue: [ parent replace: self with: negated. ].
	^ negated.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 4/29/2008 17:12'!
replace: oldDAPointcut with: newDAPointcut

	children replaceAll: oldDAPointcut with: newDAPointcut.
	newDAPointcut parent: self.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 1/25/2008 14:31'!
right

	^ children last.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 4/29/2008 17:30'!
right: aDAPointcut

	children replaceFrom: children size to: children size with: aDAPointcut.
	aDAPointcut parent: self.! !

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

!DAContextPointcut commentStamp: 'as 5/7/2008 16:31' prior: 0!
Conditional attributes in form of contexts.!

!DAContextPointcut class methodsFor: 'instance creation' stamp: 'as 5/7/2008 16:32'!
context: aDAContext

	^ self new
		context: aDAContext;
		yourself.! !

!DAContextPointcut methodsFor: 'accessing' stamp: 'as 5/7/2008 16:32'!
context

	^ context.! !

!DAContextPointcut methodsFor: 'accessing' stamp: 'as 5/7/2008 16:32'!
context: aDAContext

	context _ aDAContext.! !

!DAContextPointcut methodsFor: 'negating' stamp: 'as 5/7/2008 17:10'!
not

	context _ context not.! !

!DAContextPointcut methodsFor: 'visiting' stamp: 'as 5/7/2008 16:31'!
visitName

	^ 'context'.! !

DAPointcut subclass: #DAEmptyPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DAEmptyPointcut commentStamp: 'as 4/16/2008 15:53' prior: 0!
Selects nothing. Useful in some special cases.!

!DAEmptyPointcut methodsFor: 'negating' stamp: 'as 4/29/2008 17:40'!
not! !

!DAEmptyPointcut methodsFor: 'visiting' stamp: 'as 4/16/2008 15:33'!
visitName

	^ 'empty'.! !

DAPointcut subclass: #DAFlowPointcut
	instanceVariableNames: 'context dependency'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DAFlowPointcut commentStamp: 'as 5/7/2008 17:18' prior: 0!
Specifies the flow inside another pointcut.!

!DAFlowPointcut class methodsFor: 'instance creation' stamp: 'as 5/7/2008 17:32'!
context: aDAContextPointcut dependency: aDADependencyPointcut

	^ self new
		context: aDAContextPointcut;
		dependency: aDADependencyPointcut;
		yourself.! !

!DAFlowPointcut methodsFor: 'accessing' stamp: 'as 5/7/2008 17:33'!
context

	^ context.! !

!DAFlowPointcut methodsFor: 'accessing' stamp: 'as 5/7/2008 17:33'!
context: aDAContextPointcut

	context _ aDAContextPointcut.! !

!DAFlowPointcut methodsFor: 'accessing' stamp: 'as 5/7/2008 17:33'!
dependency

	^ dependency.! !

!DAFlowPointcut methodsFor: 'accessing' stamp: 'as 5/7/2008 17:33'!
dependency: aDADependencyPointcut

	dependency _ aDADependencyPointcut.! !

!DAFlowPointcut methodsFor: 'negating' stamp: 'as 5/7/2008 17:34'!
not

	context _ context not.! !

!DAFlowPointcut methodsFor: 'visiting' stamp: 'as 5/7/2008 17:34'!
visitName

	^ 'flow'.! !

DAPointcut subclass: #DANegatingPointcut
	instanceVariableNames: 'negated'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DANegatingPointcut commentStamp: 'as 5/6/2008 14:49' prior: 0!
Just stores the negation status.!

DANegatingPointcut subclass: #DACategoryPointcut
	instanceVariableNames: 'categoryName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DACategoryPointcut commentStamp: 'as 1/31/2008 16:39' prior: 0!
Filter for categories.!

!DACategoryPointcut class methodsFor: 'instance creation' stamp: 'as 4/30/2008 15:48'!
categoryName: regexString

	^ self new
		categoryName: regexString;
		yourself.! !

!DACategoryPointcut methodsFor: 'converting' stamp: 'as 4/30/2008 15:58'!
asFilter

	^ (DAValueFilter categoryName: categoryName)
		negated: negated;
		yourself.! !

!DACategoryPointcut methodsFor: 'accessing' stamp: 'as 4/30/2008 15:47'!
categoryName

	^ categoryName.! !

!DACategoryPointcut methodsFor: 'accessing' stamp: 'as 5/21/2008 11:31'!
categoryName: regexString

	categoryName _ regexString.! !

!DACategoryPointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:29'!
visitName

	^ 'category'.! !

DANegatingPointcut subclass: #DAClassPointcut
	instanceVariableNames: 'className'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DAClassPointcut commentStamp: 'as 1/31/2008 16:40' prior: 0!
Filter for classes.!

!DAClassPointcut class methodsFor: 'instance creation' stamp: 'as 4/30/2008 15:48'!
className: regexString

	^ self new
		className: regexString;
		yourself.! !

!DAClassPointcut methodsFor: 'converting' stamp: 'as 4/30/2008 15:58'!
asFilter

	^ (DAValueFilter className: className)
		negated: negated;
		yourself.! !

!DAClassPointcut methodsFor: 'accessing' stamp: 'as 4/30/2008 15:48'!
className

	^ className.! !

!DAClassPointcut methodsFor: 'accessing' stamp: 'as 4/30/2008 16:08'!
className: regexString

	className _ regexString.! !

!DAClassPointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:46'!
visitName

	^ 'class'.! !

DANegatingPointcut subclass: #DADependencyPointcut
	instanceVariableNames: 'connectors'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DADependencyPointcut commentStamp: 'as 5/5/2008 11:53' prior: 0!
Add a install dependency to one or more connectors.!

!DADependencyPointcut class methodsFor: 'instance creation' stamp: 'as 5/5/2008 15:04'!
connector: aDAConnector

	^ self connectors: { aDAConnector. }.! !

!DADependencyPointcut class methodsFor: 'instance creation' stamp: 'as 5/5/2008 15:04'!
connectors: aCollection

	^ self new
		connectors: aCollection;
		yourself.! !

!DADependencyPointcut methodsFor: 'accessing' stamp: 'as 5/6/2008 17:14'!
connectors

	^ connectors.! !

!DADependencyPointcut methodsFor: 'accessing' stamp: 'as 5/5/2008 15:04'!
connectors: aCollection

	connectors _ aCollection.! !

!DADependencyPointcut methodsFor: 'negating' stamp: 'as 5/7/2008 17:15'!
not

	"No effect."! !

!DADependencyPointcut methodsFor: 'visiting' stamp: 'as 5/5/2008 11:54'!
visitName

	^ 'dependency'.! !

DANegatingPointcut subclass: #DAFilterPointcut
	instanceVariableNames: 'filters'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DAFilterPointcut commentStamp: 'as 5/6/2008 14:24' prior: 0!
Specifies arbitrary filters for join point selection.!

!DAFilterPointcut methodsFor: 'accessing' stamp: 'as 5/6/2008 14:26'!
categoryFilter: aBlock

	filters at: #category put: aBlock.! !

!DAFilterPointcut methodsFor: 'accessing' stamp: 'as 5/6/2008 14:26'!
classFilter: aBlock

	filters at: #class put: aBlock.! !

!DAFilterPointcut methodsFor: 'accessing' stamp: 'as 5/6/2008 14:33'!
filters

	^ filters.! !

!DAFilterPointcut methodsFor: 'initialize-release' stamp: 'as 5/6/2008 14:25'!
initialize

	super initialize.
	filters _ Dictionary new.! !

!DAFilterPointcut methodsFor: 'accessing' stamp: 'as 5/6/2008 14:26'!
methodFilter: aBlock

	filters at: #method put: aBlock.! !

!DAFilterPointcut methodsFor: 'visiting' stamp: 'as 5/6/2008 14:32'!
visitName

	^ 'filter'.! !

DANegatingPointcut subclass: #DAMethodPointcut
	instanceVariableNames: 'methodName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DAMethodPointcut commentStamp: 'as 1/31/2008 16:42' prior: 0!
Filter for methods.!

!DAMethodPointcut class methodsFor: 'instance creation' stamp: 'as 4/30/2008 15:50'!
methodName: regexString

	^ self new
		methodName: regexString;
		yourself.! !

!DAMethodPointcut methodsFor: 'converting' stamp: 'as 4/30/2008 15:59'!
asFilter

	^ (DAValueFilter methodName: methodName)
		negated: negated;
		yourself.! !

!DAMethodPointcut methodsFor: 'accessing' stamp: 'as 4/30/2008 15:49'!
methodName

	^ methodName.! !

!DAMethodPointcut methodsFor: 'accessing' stamp: 'as 4/30/2008 15:49'!
methodName: regexString

	methodName _ regexString.! !

!DAMethodPointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:47'!
visitName

	^ 'method'.! !

!DANegatingPointcut methodsFor: 'initialize-release' stamp: 'as 4/29/2008 17:39'!
initialize

	negated _ false.! !

!DANegatingPointcut methodsFor: 'testing' stamp: 'as 5/6/2008 14:57'!
isNegated

	^ negated.! !

!DANegatingPointcut methodsFor: 'negating' stamp: 'as 4/29/2008 17:38'!
not

	negated _ negated not.! !

DANegatingPointcut subclass: #DANodePointcut
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Pointcuts'!

!DANodePointcut commentStamp: 'as 1/31/2008 16:41' prior: 0!
Filter the nodes within a reflective method (sub-method level).!

!DANodePointcut class methodsFor: 'instance creation' stamp: 'as 4/29/2008 17:54'!
block: aBlock

	^ self new
		block: aBlock;
		yourself.! !

!DANodePointcut methodsFor: 'converting' stamp: 'as 4/30/2008 14:44'!
asFilter

	^ (DABlockFilter block: block)
		negated: negated;
		yourself.! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 4/29/2008 17:54'!
block

	^ block.! !

!DANodePointcut methodsFor: 'accessing' stamp: 'as 4/29/2008 17:53'!
block: aBlock

	block _ aBlock.! !

!DANodePointcut methodsFor: 'visiting' stamp: 'as 1/28/2008 08:48'!
visitName

	^ 'node'.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 5/8/2008 17:07'!
call: aSymbol on: aClass

	| desc |

	desc _ aClass asDescription.
	^ (self classOrSuper: aClass method: aSymbol) &
		(self if: [ :receiver | receiver class = desc classObject. ] arguments: #(receiver)).! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 2/21/2008 17:29'!
category: aSymbol

	^ self categoryName: aSymbol.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 5/6/2008 14:32'!
categoryFilter: aBlock

	^ DAFilterPointcut new categoryFilter: aBlock.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 4/30/2008 16:01'!
categoryName: regexString

	^ DACategoryPointcut categoryName: regexString.! !

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

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 5/6/2008 14:31'!
classFilter: aBlock

	^ DAFilterPointcut new classFilter: aBlock.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 4/30/2008 16:01'!
className: regexString

	^ DAClassPointcut className: regexString.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 5/8/2008 16:49'!
classOrSuper: aClass

	| desc |
	
	desc _ aClass asDescription.
	^ self classFilter: [
		:class |
		(class = desc classObject) or: [ desc classObject allSuperclasses includes: class. ].
	].! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 5/8/2008 16:24'!
classOrSuper: aClass method: aSymbol

	^ (self classOrSuper: aClass) & (self methodName: aSymbol).! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 5/6/2008 14:28'!
classWithBehavior: aClass

	| classDescr |
	
	classDescr _ DAClassDescription classObject: aClass.
	^ self classFilter: [
		:class |
		class includesBehavior: classDescr classObject.
	].! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 5/7/2008 16:35'!
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

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 5/7/2008 17:47'!
flow: aDAPointcut

	^ self flow: aDAPointcut min: 1 max: 1.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 5/7/2008 17:47'!
flow: aDAPointcut min: minNumber

	^ self flow: aDAPointcut min: minNumber max: 0.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 5/7/2008 17:47'!
flow: aDAPointcut min: minNumber max: maxNumber

	| context connectors |
	
	context _ DAFlowContext pointcut: aDAPointcut min: minNumber max: maxNumber.
	connectors _ {
		DAFlow before: aDAPointcut.
		DAFlow after: aDAPointcut.
	}.

	^ DAFlowPointcut
		context: (DAContextPointcut context: context)
		dependency: (DADependencyPointcut connectors: connectors).! !

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

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 4/30/2008 15:42'!
method: aMethod

	^ (self class: aMethod methodClass) and: (self methodName: aMethod selector).! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 5/6/2008 14:32'!
methodFilter: aBlock

	^ DAFilterPointcut new methodFilter: aBlock.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 4/30/2008 16:01'!
methodName: regexString

	^ DAMethodPointcut methodName: regexString.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/25/2008 17:59'!
node: aBlock

	^ DANodePointcut block: aBlock.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 3/3/2008 11:59'!
tempVariable

	^ self node: [
		:node |
		node isVariable and: [ node isTemp. ].
	].! !

!DAPointcut methodsFor: 'composing' stamp: 'as 4/9/2008 15:11'!
& aDAPointcut

	^ self and: aDAPointcut.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 3/19/2008 15:19'!
acceptVisitor: aDAPointcutEvaluator

	aDAPointcutEvaluator perform: ('visit', self visitName capitalized, ':') asSymbol with: self.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 1/24/2008 16:32'!
and: aDAPointcut

	^ DAAndPointcut child: self child: aDAPointcut.! !

!DAPointcut methodsFor: 'accessing' stamp: 'as 5/5/2008 17:25'!
dependencies

	self evaluate.
	^ self evaluator dependencies.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 5/5/2008 17:23'!
evaluate

	self evaluator hasEvaluated ifFalse: [ self evaluator visit: self. ].! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 5/6/2008 16:01'!
evaluator

	^ self properties at: #evaluator ifAbsentPut: [ DAPointcutEvaluator new. ].! !

!DAPointcut methodsFor: 'testing' stamp: 'as 2/4/2008 21:16'!
hasParent

	^ parent notNil.! !

!DAPointcut methodsFor: 'accessing' stamp: 'as 5/5/2008 17:24'!
joinPoints

	self evaluate.
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

!DAPointcut methodsFor: 'accessing' stamp: 'as 5/6/2008 15:29'!
properties

	^ properties ifNil: [ properties _ Dictionary new. ].! !

!DAPointcut methodsFor: 'caching' stamp: 'as 5/6/2008 17:18'!
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

!DAPointcutEvaluator methodsFor: 'accessing' stamp: 'as 5/6/2008 17:37'!
dependencies

	self hasEvaluated ifTrue: [
		^ joinPoints inject: Set new into: [ :set :jp | set, jp dependencies. ].
	] ifFalse: [
		^ #().
	].! !

!DAPointcutEvaluator methodsFor: 'testing' stamp: 'as 3/31/2008 15:18'!
hasEvaluated

	^ joinPoints notNil.! !

!DAPointcutEvaluator methodsFor: 'initialize-release' stamp: 'as 5/6/2008 17:43'!
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

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 5/7/2008 16:30'!
visitCategory: pc

	joinPoints add: (DAJoinPoint new category: pc asFilter; yourself).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 5/7/2008 16:30'!
visitClass: pc

	joinPoints add: (DAJoinPoint new class: pc asFilter; yourself).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 5/7/2008 16:29'!
visitCondition: pc

	joinPoints add: (DAJoinPoint new condition: pc condition; yourself).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 5/7/2008 16:30'!
visitContext: pc

	joinPoints add: (DAJoinPoint new context: pc context; yourself).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 5/7/2008 17:17'!
visitDependency: pc

	joinPoints add: (DAJoinPoint new dependencies: pc connectors; yourself).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 4/28/2008 14:22'!
visitEmpty: pc

	"Intentionally left blank."! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 5/6/2008 14:34'!
visitFilter: pc

	| jp |

	jp _ DAJoinPoint new.
	pc filters associationsDo: [
		:filter |
		jp filterAt: filter key put: (DABlockFilter block: filter value).
	].
	joinPoints add: jp.! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 5/7/2008 17:44'!
visitFlow: pc

	pc dependency acceptVisitor: self.
	pc context acceptVisitor: self.
	joinPoints add: (joinPoints removeAt: 1) & (joinPoints removeAt: 2).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 5/7/2008 16:30'!
visitMethod: pc

	joinPoints add: (DAJoinPoint new method: pc asFilter; yourself).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 5/7/2008 16:30'!
visitNode: pc

	joinPoints add: (DAJoinPoint new node: pc asFilter; yourself).! !

!DAPointcutEvaluator methodsFor: 'visiting' stamp: 'as 3/19/2008 15:16'!
visitOr: pc

	pc left acceptVisitor: self.
	self push.
	pc right acceptVisitor: self.
	joinPoints addAll: self pop.! !

Object subclass: #DAProtoAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

DAProtoAspect class
	instanceVariableNames: 'pointcutNames'!

!DAProtoAspect commentStamp: 'as 5/2/2008 09:54' prior: 0!
Provides minimal behavior for an aspect, that can't be implemented directly in the aspect class.!

DAProtoAspect class
	instanceVariableNames: 'pointcutNames'!

DAProtoAspect subclass: #DAAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Kernel'!

DAAspect class
	instanceVariableNames: 'mo moCreator moDict connectors disabled failure'!

!DAAspect commentStamp: 'as 4/23/2008 13:42' prior: 0!
Combines several pointcuts and advices by hosting multiple connectors.!

DAAspect class
	instanceVariableNames: 'mo moCreator moDict connectors disabled failure'!

!DAAspect class methodsFor: 'advices' stamp: 'as 5/2/2008 09:59'!
adviceControls

	^ #(before after beforeafter instead).! !

!DAAspect class methodsFor: 'advices' stamp: 'as 5/13/2008 11:26'!
advices

	| possibilities |
	possibilities _ self possibleAdviceNames.
	^ self methods select: [
		:method |
		possibilities anySatisfy: [
			:pos |
			pos match: (method selector subStrings: ':') first.
		].
	].! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 4/30/2008 17:41'!
allPointcutNames

	^ self superclass pointcutNames, self pointcutNames.! !

!DAAspect class methodsFor: 'advices' stamp: 'as 5/2/2008 11:12'!
argumentsForAdvice: aMethod

	^ aMethod reflectiveMethod argumentNames collect: [ :arg | arg asSymbol. ].! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/2/2008 11:31'!
connectorForAdvice: aMethod

	| connector |
	
	connector _ DAConnector new.
	connector
		aspect: self;
		arguments: (self argumentsForAdvice: aMethod);
		control: (self controlForAdvice: aMethod);
		pointcut: (self pointcutForAdvice: aMethod);
		selector: aMethod selector.
		
	self scope ifNil: [
		connector metaObject: self metaObject.
	] ifNotNil: [
		connector
			scope: self scope;
			metaObjectCreator: self metaObjectCreator dict: self metaObjectDict.
	].

	^ connector.! !

!DAAspect class methodsFor: 'advices' stamp: 'as 4/30/2008 18:02'!
controlForAdvice: aMethod

	^ self adviceControls detect: [
		:ctrl |
		aMethod selector startsWith: ctrl.
	].! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/13/2008 15:10'!
createConnectors

	| cons |

	cons _ Set new.
	self advices do: [
		:adv |
		cons add: (self connectorForAdvice: adv).
	].
	^ cons.! !

!DAAspect class methodsFor: 'fileIn/Out' stamp: 'as 5/14/2008 14:47'!
definitionAspect

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

!DAAspect class methodsFor: 'installing' stamp: 'as 5/19/2008 17:35'!
disable

	disabled _ true.
	self uninstallQuietly.! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/19/2008 10:47'!
disable: aBoolean

	aBoolean ifTrue: [ self disable. ] ifFalse: [ self enable. ].! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 5/19/2008 11:56'!
disabled

	^ disabled ifNil: [ disabled _ false. ].! !

!DAAspect class methodsFor: 'compiling' stamp: 'as 5/19/2008 17:11'!
doneCompiling

	self isEnabled ifTrue: [ self reinstallQuietly. ].! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/19/2008 17:35'!
enable

	disabled _ false.
	self installQuietly.! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/19/2008 10:47'!
enable: aBoolean

	self disable: aBoolean not.! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 5/19/2008 11:31'!
failure

	^ failure.! !

!DAAspect class methodsFor: 'initialize-release' stamp: 'as 5/21/2008 14:55'!
initialize

	self isEnabled ifTrue: [ self reinstallQuietly. ].! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/19/2008 17:22'!
install

	self notInstalled ifTrue: [
		connectors _ Set new.
		failure _ nil.
		[
			[
				self installConnectors.
			] on: Exception do: [
				:e |
				failure _ e.
				e pass.
			].
		] ensure: [
			failure ifNotNil: [ self uninstall. ].
		].
	].! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/13/2008 15:10'!
installConnectors

	self createConnectors do: [
		:con |
		con install.
		connectors add: con.
	].
		! !

!DAAspect class methodsFor: 'testing' stamp: 'as 5/19/2008 11:36'!
installFailed

	^ failure notNil.! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/19/2008 11:34'!
installQuietly

	[ self install. ] on: Exception do: [].! !

!DAAspect class methodsFor: 'testing' stamp: 'as 5/22/2008 19:02'!
isAdvice: aSymbol

	^ self possibleAdviceNames anySatisfy: [
		:pos |
		pos match: (aSymbol subStrings: ':') first.
	].! !

!DAAspect class methodsFor: 'testing' stamp: 'as 5/26/2008 23:30'!
isAdviceOrPointcut: aSymbol meta: aBoolean

	^ (aBoolean and: [ self isPointcut: aSymbol. ]) or: [
		aBoolean not and: [ self isAdvice: aSymbol. ].
	].! !

!DAAspect class methodsFor: 'testing' stamp: 'as 5/16/2008 11:25'!
isDisabled

	^ self disabled.! !

!DAAspect class methodsFor: 'testing' stamp: 'as 5/19/2008 11:29'!
isEnabled

	^ self isDisabled not.! !

!DAAspect class methodsFor: 'testing' stamp: 'as 5/13/2008 18:04'!
isInstalled

	^ connectors notNil & self installFailed not.! !

!DAAspect class methodsFor: 'testing' stamp: 'as 5/20/2008 13:54'!
isPointcut: aSymbol

	^ self allPointcutNames includes: aSymbol allButLast.! !

!DAAspect class methodsFor: 'private' stamp: 'as 4/14/2008 16:53'!
metaObject

	^ mo ifNil: [ mo _ self new. ].! !

!DAAspect class methodsFor: 'private' stamp: 'as 4/14/2008 16:59'!
metaObjectCreator

	^ moCreator ifNil: [ moCreator _ [ self new. ]. ].! !

!DAAspect class methodsFor: 'private' stamp: 'as 4/14/2008 17:12'!
metaObjectDict

	^ moDict ifNil: [ moDict _ Dictionary new. ].! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 5/21/2008 16:12'!
mo

	^ mo.! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 5/21/2008 16:13'!
moCreator

	^ moCreator.! !

!DAAspect class methodsFor: 'accessing' stamp: 'as 5/21/2008 16:12'!
moDict

	^ moDict.! !

!DAAspect class methodsFor: 'testing' stamp: 'as 5/13/2008 18:04'!
notInstalled

	^ connectors isNil.! !

!DAAspect class methodsFor: 'compiling' stamp: 'as 5/26/2008 23:29'!
noteCompilationOf: aSelector meta: aBoolean

	(self isEnabled and: [ self isAdviceOrPointcut: aSelector meta: aBoolean. ]) ifTrue: [
		self reinstallQuietly.
	].! !

!DAAspect class methodsFor: 'compiling' stamp: 'as 5/26/2008 23:34'!
notifyUsersOfChangedSelectors: aCollection meta: aBoolean

	(self isEnabled and: [
		aCollection anySatisfy: [
			:sel | self isAdviceOrPointcut: sel meta: aBoolean.
		].
	]) ifTrue: [ self reinstallQuietly. ].! !

!DAAspect class methodsFor: 'pointcuts' stamp: 'as 5/2/2008 10:49'!
pointcutForAdvice: aMethod

	| pc |

	pc _ self allPointcutNames detect: [
		:pcn |
		(aMethod selector subStrings: ':') first endsWith: pcn capitalized.
	].
	
	^ self perform: (pc, ':') asSymbol with: DAPointcut.! !

!DAAspect class methodsFor: 'printing' stamp: 'as 4/30/2008 17:43'!
pointcutsString

	^ String streamContents: [
		:stream |
		self pointcutNames do: [
			:each |
			stream nextPutAll: each asString.
		] separatedBy: [ stream space. ].
	].! !

!DAAspect class methodsFor: 'advices' stamp: 'as 4/30/2008 18:02'!
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

!DAAspect class methodsFor: 'installing' stamp: 'as 5/19/2008 11:21'!
reinstall

	self uninstall; install.! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/20/2008 14:15'!
reinstallQuietly

	self uninstallQuietly; installQuietly.! !

!DAAspect class methodsFor: 'aspects' stamp: 'as 4/14/2008 15:47'!
scope

	^ nil.! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 4/30/2008 17:42'!
template: categorySymbol

	^ self templateForSubclassOf: DAAspect name category: categorySymbol. ! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 4/30/2008 17:43'!
templateForSubclassOf: aClass category: aSymbol

	^ aClass asString, 'subaspect: #NameOfSubaspect
	pointcutNames: ''''
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''' , aSymbol asString , ''''.! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/19/2008 17:18'!
uninstall

	self uninstallConnectors.
	connectors _ nil.! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/19/2008 11:42'!
uninstallConnectors

	connectors ifNotNil: [
		connectors copy do: [
			:con |
			con uninstall.
			connectors remove: con.
		].
	].! !

!DAAspect class methodsFor: 'installing' stamp: 'as 5/19/2008 11:34'!
uninstallQuietly

	[ self uninstall. ] on: Exception do: [].! !

!DAAspect class methodsFor: 'initialize-release' stamp: 'as 5/26/2008 16:16'!
unload

	self uninstall.! !

DAAspect subclass: #DAExampleAspect
	instanceVariableNames: 'reifications'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Tests'!

!DAExampleAspect commentStamp: 'as 5/13/2008 11:21' prior: 0!
Examples aspect for tests.!

!DAExampleAspect class methodsFor: 'pointcuts' stamp: 'as 5/22/2008 18:32'!
countA: p

	^ p method: DAExamples class >> #countA.! !

!DAExampleAspect class methodsFor: 'pointcuts' stamp: 'as 5/22/2008 18:32'!
countB: p

	^ p method: DAExamples class >> #countB.! !

!DAExampleAspect class methodsFor: 'pointcuts' stamp: 'as 5/22/2008 18:33'!
countI: p

	^ p method: DAExamples class >> #countI.! !

!DAExampleAspect class methodsFor: 'pointcuts' stamp: 'as 5/23/2008 11:10'!
noop: p

	^ p method: DAExamples class >> #noop.! !

!DAExampleAspect methodsFor: 'advices' stamp: 'as 5/22/2008 18:48'!
afterCountA: object

	object count: 2.! !

!DAExampleAspect methodsFor: 'advices' stamp: 'as 5/22/2008 18:51'!
beforeCountB: object

	object count: 2.! !

!DAExampleAspect methodsFor: 'advices' stamp: 'as 5/22/2008 21:49'!
insteadCountI: object

	object inc.! !

!DAExampleAspect methodsFor: 'advices' stamp: 'as 5/23/2008 12:57'!
insteadNoop: arguments continuation: continuation control: control class: class link: link node: node object: object receiver: receiver selector: selector sender: sender context: context

	! !

!DAExampleAspect methodsFor: 'accessing' stamp: 'as 5/23/2008 12:52'!
reifications

	^ reifications.! !

DAAspect subclass: #DAFibonacciExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Examples'!

!DAFibonacciExample class methodsFor: 'fibonacci' stamp: 'as 5/24/2008 22:24'!
fib: n

	^ n <= 1 ifTrue: [ n. ] ifFalse: [ (self fib: n - 1) + (self fib: n - 2). ].! !

!DAFibonacciExample class methodsFor: 'fibonacci' stamp: 'as 5/26/2008 10:28'!
fibNoEnd: n

	^ (self fib: n - 1) + (self fib: n - 2).! !

!DAFibonacciExample class methodsFor: 'fibonacci' stamp: 'as 5/24/2008 22:42'!
fibTail: n

	"Tail recursion. A lot faster than #fib:."

	^ n <= 1 ifTrue: [ n. ] ifFalse: [ self fibTail: n - 1 a: 0 b: 1. ].! !

!DAFibonacciExample class methodsFor: 'fibonacci' stamp: 'as 5/24/2008 22:36'!
fibTail: n a: a b: b

	^ n <= 1 ifTrue: [ a + b. ] ifFalse: [ self fibTail: n - 1 a: b b: a + b. ].! !

!DAFibonacciExample class methodsFor: 'pointcuts' stamp: 'as 5/26/2008 17:08'!
noEnd: pc

	^ (self class >> #fibNoEnd:) asPointcut.! !

!DAFibonacciExample methodsFor: 'advices' stamp: 'as 5/25/2008 00:07'!
insteadNoEnd

	^ 1.! !

!DAProtoAspect class methodsFor: 'accessing' stamp: 'as 4/30/2008 17:34'!
pointcutNames

	^ pointcutNames ifNil: [ pointcutNames _ Set new. ].! !

!DAProtoAspect class methodsFor: 'accessing' stamp: 'as 4/30/2008 17:36'!
pointcutNames: aString
	
	pointcutNames _ (aString subStrings: ' ') asSet.! !

!DAProtoAspect class methodsFor: 'subaspect creation' stamp: 'as 4/30/2008 17:48'!
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

!GeppettoTest methodsFor: '*DA' stamp: 'as 5/26/2008 13:28'!
testMethodInstead

	gplink := GPLink new metaObject: [10]; control: #instead.
	(GPExamples>>#exampleBlock) methodNode body do: [ :node | node link: gplink. ].
	
	GPCounter reset.
	self assert: (GPExamples new exampleBlock = 10).! !

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

!ClassDescription class methodsFor: '*DA' stamp: 'as 5/8/2008 15:55'!
asDescription

	^ DAClassDescription classObject: self.! !

!ClassDescription methodsFor: '*DA' stamp: 'as 5/8/2008 15:54'!
asDescription

	^ DAClassDescription classObject: self.! !

!Process methodsFor: '*DA' stamp: 'as 5/5/2008 11:30'!
flow

	^ flow ifNil: [ flow _ Dictionary new. ].! !

!Process methodsFor: '*DA' stamp: 'as 5/6/2008 17:45'!
flowAt: aDAPointcut

	^ self flow at: aDAPointcut ifAbsent: [ 0. ].! !

!Process methodsFor: '*DA' stamp: 'as 5/6/2008 17:45'!
flowInto: aDAPointcut

	| count |

	count _ self flow at: aDAPointcut ifAbsentPut: [ 0. ].
	self flow at: aDAPointcut put: count + 1.! !

!Process methodsFor: '*DA' stamp: 'as 5/6/2008 17:50'!
flowOutOf: aDAPointcut

	| count |

	count _ self flow at: aDAPointcut.
	self flow at: aDAPointcut put: count - 1.! !

!GPCounter methodsFor: '*DA' stamp: 'as 5/22/2008 18:21'!
count: aNumber

	count _ aNumber.! !

Browser subclass: #DAAspectBrowser
	instanceVariableNames: 'aspectMenu'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DA-Browser'!

!DAAspectBrowser commentStamp: 'as 5/14/2008 14:25' prior: 0!
Add aspect functionality.!

!DAAspectBrowser class methodsFor: 'class initialization' stamp: 'as 5/14/2008 14:27'!
initialize

	"self initialize"
	
	TheWorldMenu registerOpenCommand: {'Aspect Browser'. {self. #openBrowser}}.
	self registerInAppRegistry.! !

!DAAspectBrowser methodsFor: 'aspects' stamp: 'as 5/21/2008 14:36'!
adaptAspectButtonColor

	| button color |

	button _ self topView allMorphs detect: [
		:morph |
		(morph isKindOf: PluggableButtonMorph) and:
			[ morph actionSelector = #openAspectMenu. ].
	].

	self editingAspect ifTrue: [
		self aspect isInstalled ifTrue: [
			color _ Color lightGreen.
		] ifFalse: [
			self aspect installFailed ifTrue: [
				color _ Color lightRed.
			] ifFalse: [
				color _ Color lightBlue.
			].
		].
	] ifFalse: [
		color _ Color white.
	].

	button offColor: color.! !

!DAAspectBrowser methodsFor: 'aspects' stamp: 'as 5/19/2008 15:18'!
aspect

	(self selectedClass notNil and: [ self selectedClass includesBehavior: DAAspect. ])
		ifTrue: [ ^ self selectedClass. ]
		ifFalse: [ ^ nil. ].! !

!DAAspectBrowser methodsFor: 'accessing' stamp: 'as 5/16/2008 12:54'!
aspectMenu

	^ aspectMenu ifNil: [ aspectMenu _ self buildAspectMenu. ].! !

!DAAspectBrowser methodsFor: 'aspects' stamp: 'as 5/16/2008 13:28'!
aspectMenuEnabled: aBoolean

	self aspectMenu items do: [ :m | m isEnabled: aBoolean. ].! !

!DAAspectBrowser methodsFor: 'initialize-release' stamp: 'as 5/19/2008 17:07'!
buildAspectMenu

	| menu |
	
	menu _ MenuMorph new.
	menu
		addTitle: 'Aspect';
		defaultTarget: self.
	menu addList: #(
		('1. Enable' enableAspect)
		('2. Disable' disableAspect)
		('2. Reinstall manually' reinstallAspect)
	).
	^ menu.! !

!DAAspectBrowser methodsFor: 'class functions' stamp: 'as 5/19/2008 15:31'!
classDefinitionText

	| theClass |
	
	theClass _ self selectedClassOrMetaClass.
	theClass ifNil: [ ^ ''. ].
	(self editingAspect and: [ theClass isInstanceSide. ]) ifTrue: [
		^ theClass definitionAspect.
	] ifFalse: [		
		^theClass definitionST80.
	].! !

!DAAspectBrowser methodsFor: 'class list' stamp: 'as 5/19/2008 11:54'!
classListIndex: anInteger 

	super classListIndex: anInteger.
	self updateAspect.! !

!DAAspectBrowser methodsFor: 'initialize-release' stamp: 'as 5/15/2008 16:41'!
defaultBrowserTitle

	^ 'AB'.! !

!DAAspectBrowser methodsFor: 'class functions' stamp: 'as 5/14/2008 14:35'!
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
	
	"as 5/2/2008: a fix for DA (Dynamic Aspects), which do not contain the word 'subclass',
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

!DAAspectBrowser methodsFor: 'aspects' stamp: 'as 5/19/2008 17:08'!
disableAspect

	self aspect disable.
	self updateAspect.! !

!DAAspectBrowser methodsFor: 'testing' stamp: 'as 5/19/2008 15:00'!
editingAspect

	^ self aspect notNil.! !

!DAAspectBrowser methodsFor: 'aspects' stamp: 'as 5/19/2008 17:08'!
enableAspect

	self aspect enable.
	self updateAspect.! !

!DAAspectBrowser methodsFor: 'aspects' stamp: 'as 5/19/2008 15:25'!
openAspectMenu

	self editingAspect
		ifTrue: [ self aspectMenuEnabled: true. ]
		ifFalse: [ self aspectMenuEnabled: false. ].
	self aspectMenu popUpInWorld.! !

!DAAspectBrowser methodsFor: 'controls' stamp: 'as 5/21/2008 14:36'!
optionalButtonPairs

	^ super optionalButtonPairs,
		#(('A' openAspectMenu 'manage aspects, the colors indicate:
green: the aspect is installed
blue: the aspect is not installed
red: the aspect failed to install')).! !

!DAAspectBrowser methodsFor: 'aspects' stamp: 'as 5/20/2008 13:58'!
reinstallAspect

	[ self aspect reinstall. ] ensure: [ self updateAspect. ].! !

!DAAspectBrowser methodsFor: 'aspects' stamp: 'as 5/19/2008 15:10'!
updateAspect

	self adaptAspectButtonColor.! !
DAFlowContext initialize!
DAAspect initialize!
DAAspectBrowser initialize!
