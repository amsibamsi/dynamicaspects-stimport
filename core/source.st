SystemOrganization addCategory: #'DynamicAspects-Evaluation'!

Object subclass: #DAJoinPointEvaluationDummy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Evaluation'!

!DAJoinPointEvaluationDummy commentStamp: 'as 6/13/2007 14:17' prior: 0!
Dummy to test join point evaluations on.!

!DAJoinPointEvaluationDummy methodsFor: 'as yet unclassified' stamp: 'as 6/13/2007 14:17'!
method

	| tmp |
	tmp _ Object new.
	^ tmp.! !

!DAJoinPointEvaluationDummy methodsFor: 'as yet unclassified' stamp: 'as 6/13/2007 15:35'!
method2

	^ self method.! !

Object subclass: #DAPointcutEvaluationDummy
	instanceVariableNames: 'a'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Evaluation'!

!DAPointcutEvaluationDummy commentStamp: 'as 6/18/2007 17:36' prior: 0!
Dummy to test pointcut evaluations on.!

!DAPointcutEvaluationDummy methodsFor: 'as yet unclassified' stamp: 'as 6/18/2007 17:37'!
method! !

TestCase subclass: #DAJoinPointEvaluation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Evaluation'!

!DAJoinPointEvaluation commentStamp: 'as 6/13/2007 12:49' prior: 0!
Evaluating join point possibilities.!

!DAJoinPointEvaluation methodsFor: 'util' stamp: 'as 6/18/2007 17:10'!
class: aClass methodBody: aSymbol

	^ (aClass >> aSymbol) reflectiveMethod methodNode body.! !

!DAJoinPointEvaluation methodsFor: 'testing-types' stamp: 'as 6/18/2007 17:11'!
testFieldGet

	| nodes selectedNodes |
	nodes _ (self class: DAJoinPointEvaluationDummy methodBody: #method) allChildren.
	selectedNodes _ nodes select: [
		:each |
		(each isKindOf: RBTempVariableNode) and: [ ((each parent isKindOf: RBAssignmentNode) not) and: [ (each parent isKindOf: RBSequenceNode) not. ] ].
	].
	self assert: selectedNodes size = 1.! !

!DAJoinPointEvaluation methodsFor: 'testing-types' stamp: 'as 6/18/2007 17:11'!
testFieldSet

	| nodes node |
	nodes _ (self class: DAJoinPointEvaluationDummy methodBody: #method) allChildren.
	node _ nodes detect: [
		:each |
		each isKindOf: RBAssignmentNode
	].
	self assert: node variable name = 'tmp'.! !

!DAJoinPointEvaluation methodsFor: 'testing-types' stamp: 'as 6/18/2007 17:11'!
testMethodCall

	| nodes node |
	nodes _ (self class: DAJoinPointEvaluationDummy methodBody: #method2) allChildren.
	node _ nodes detect: [
		:each |
		each isKindOf: RBMessageNode.
	].
	self assert: node selector = #method.! !

!DAJoinPointEvaluation methodsFor: 'testing-types' stamp: 'as 6/18/2007 17:11'!
testMethodExecution

	| node |
	node _ self class: DAJoinPointEvaluationDummy methodBody: #method.
	self assert: (node isKindOf: RBProgramNode).! !

TestCase subclass: #DAPointcutEvaluation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Evaluation'!

!DAPointcutEvaluation commentStamp: 'as 6/18/2007 17:01' prior: 0!
Evaluating Pointcut possibilities.!

!DAPointcutEvaluation methodsFor: 'testing-selectors' stamp: 'as 6/18/2007 17:36'!
testClass

	self assert: (DAPointcutEvaluationDummy isKindOf: Class).! !

!DAPointcutEvaluation methodsFor: 'testing-selectors' stamp: 'as 6/18/2007 17:52'!
testField

	self assert: (DAPointcutEvaluationDummy allInstVarNames includes: 'a').! !

!DAPointcutEvaluation methodsFor: 'testing-selectors' stamp: 'as 6/18/2007 17:38'!
testMethod

	self assert: ((DAPointcutEvaluationDummy >> #method) isKindOf: ReflectiveMethod).! !
