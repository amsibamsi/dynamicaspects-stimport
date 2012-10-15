SystemOrganization addCategory: #'AOP-Evaluation-Tests'!

Object subclass: #AOPJointPointEvaluationDummy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'AOP-Evaluation-Tests'!

!AOPJointPointEvaluationDummy commentStamp: 'as 6/13/2007 14:17' prior: 0!
Dummy to test join point evaluations on.!

!AOPJointPointEvaluationDummy methodsFor: 'as yet unclassified' stamp: 'as 6/13/2007 14:17'!
method

	| tmp |
	tmp _ Object new.
	^ tmp.! !

!AOPJointPointEvaluationDummy methodsFor: 'as yet unclassified' stamp: 'as 6/13/2007 15:35'!
method2

	^ self method.! !

TestCase subclass: #AOPJoinPointEvaluation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'AOP-Evaluation-Tests'!

!AOPJoinPointEvaluation commentStamp: 'as 6/13/2007 12:49' prior: 0!
Evaluating join point possibilities.!

!AOPJoinPointEvaluation methodsFor: 'testing' stamp: 'as 6/13/2007 16:40'!
testMethodCall

	| nodes node |
	nodes _ (AOPJointPointEvaluationDummy >> #method2) reflectiveMethod methodNode allChildren.
	node _ nodes detect: [
		:each |
		each isKindOf: RBMessageNode.
	].
	self assert: node selector = #method.! !

!AOPJoinPointEvaluation methodsFor: 'testing' stamp: 'as 6/13/2007 15:12'!
testMethodExecution

	| node |
	node _ (AOPJointPointEvaluationDummy >> #method) reflectiveMethod methodNode body.
	self assert: (node isKindOf: RBProgramNode).! !
