SystemOrganization addCategory: #DAExamples!

DAAspect subclass: #DAFibonacciExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples'!

!DAFibonacciExample commentStamp: 'as 9/1/2008 14:36' prior: 0!
An example with the Fibonacci numbers.!

!DAFibonacciExample class methodsFor: 'fibonacci' stamp: 'as 9/1/2008 14:37'!
fib: n

	^ n <= 1 ifTrue: [ n. ] ifFalse: [ (self fib: n - 1) + (self fib: n - 2). ].! !

!DAFibonacciExample class methodsFor: 'fibonacci' stamp: 'as 9/1/2008 14:37'!
fibNoEnd: n

	^ (self fib: n - 1) + (self fib: n - 2).! !

!DAFibonacciExample class methodsFor: 'fibonacci' stamp: 'as 9/1/2008 14:37'!
fibTail: n

	"Tail recursion. A lot faster than #fib:."

	^ n <= 1 ifTrue: [ n. ] ifFalse: [ self fibTail: n - 1 a: 0 b: 1. ].! !

!DAFibonacciExample class methodsFor: 'fibonacci' stamp: 'as 9/1/2008 14:37'!
fibTail: n a: a b: b

	^ n <= 1 ifTrue: [ a + b. ] ifFalse: [ self fibTail: n - 1 a: b b: a + b. ].! !

!DAFibonacciExample class methodsFor: 'pointcuts' stamp: 'as 9/1/2008 14:38'!
noEnd

	<pointcut>

	^ (self class >> #fibNoEnd:) asPointcut.! !

!DAFibonacciExample methodsFor: 'advices' stamp: 'as 9/1/2008 14:58'!
end: n operation: operation

	<advice: #noEnd control: #instead arguments: #(arg1 operation)>

	^ n <= 1 ifTrue: [ ^ n. ] ifFalse: [ ^ operation value. ].! !
