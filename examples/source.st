SystemOrganization addCategory: #DAExamples!

DAActiveContext subclass: #DAStoreClosedContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples'!

!DAStoreClosedContext commentStamp: 'as 9/1/2008 15:28' prior: 0!
Active when the store is closed.!

!DAStoreClosedContext methodsFor: 'testing' stamp: 'as 9/1/2008 15:28'!
isActive

	^ Time now seconds even.! !

WAComponent subclass: #DAStoreClosedMessage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples'!

!DAStoreClosedMessage commentStamp: 'as 9/1/2008 15:33' prior: 0!
Render a closed message.!

!DAStoreClosedMessage methodsFor: 'rendering' stamp: 'as 9/1/2008 15:33'!
renderContentOn: html

	html paragraph: [ html emphasis: [ html text: 'Sorry, the store is closed every even second (', Time now asString, ').' ]. ].! !

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

DAAspect subclass: #DAStoreClosedExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples'!

!DAStoreClosedExample commentStamp: 'as 9/1/2008 15:33' prior: 0!
The store is closed in certain contexts.!

!DAStoreClosedExample class methodsFor: 'pointcuts' stamp: 'as 9/1/2008 15:45'!
entrance

	<pointcut>

	^ (PC class: WAStoreTask method: #go) & (PC context: DAStoreClosedContext).! !

!DAStoreClosedExample methodsFor: 'advices' stamp: 'as 9/1/2008 15:37'!
closedEntrance: task

	<advice: #entrance control: #instead arguments: #(object)>

	task call: DAStoreClosedMessage new.! !

DAAspect subclass: #DAStoreFieldWriteExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples'!

!DAStoreFieldWriteExample commentStamp: 'as 9/1/2008 15:51' prior: 0!
Trace the flow through the seaside components.!

!DAStoreFieldWriteExample class methodsFor: 'pointcuts' stamp: 'as 9/16/2008 18:50'!
fieldWrites

	<pointcut>

	^ (PC className: 'WAStore*') & PC instanceWrite.! !

!DAStoreFieldWriteExample methodsFor: 'advices' stamp: 'as 9/1/2008 15:52'!
logFieldWrites: node

	<advice: #fieldWrites control: #before arguments: #(node)>

	| method |

	method _ node reflectiveMethod.
	Transcript show:
		'Writing field ''',
		node variable name,
		''' in ',
		method methodClass name,
		'>>',
		method selector.
	Transcript cr.! !

DAAspect subclass: #DAStoreRenderExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples'!

!DAStoreRenderExample commentStamp: 'as 9/1/2008 15:56' prior: 0!
Render a halo around each component.!

!DAStoreRenderExample class methodsFor: 'pointcuts' stamp: 'as 9/1/2008 16:02'!
css

	<pointcut>

	^ (PC class: WAStore method: #style).! !

!DAStoreRenderExample class methodsFor: 'pointcuts' stamp: 'as 9/1/2008 16:02'!
rendering

	<pointcut>

	^ (PC className: 'WAStore*' methodName: #renderContentOn:).! !

!DAStoreRenderExample methodsFor: 'advices' stamp: 'as 9/1/2008 16:01'!
css: operation

	<advice: #css control: #instead arguments: #(operation)>

	^ operation value, '
		#halo {
			z-index: 20;
			left: 0;
			right: 0;
			bottom: 0;
			padding: 2px;
			color: #aa0000;
			background-color: #ffa0a0;
			border: 1px solid #ff0000;
			font: 10pt Verdana, Arial, Helvetica, sans-serif;
		}
	'! !

!DAStoreRenderExample methodsFor: 'advices' stamp: 'as 9/1/2008 16:02'!
renderHalos: html object: component

	<advice: #rendering control: #before arguments: #(arg1 object)>

	html div id: 'halo'; with: [
		html small: [ html text: component asString. ].
	].! !

DAAspect subclass: #DAStoreTitleExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples'!

!DAStoreTitleExample commentStamp: 'as 9/1/2008 15:15' prior: 0!
Modify the title.!

!DAStoreTitleExample class methodsFor: 'pointcuts' stamp: 'as 9/1/2008 15:19'!
title

	<pointcut>

	^ PC class: WAStore method: #title.! !

!DAStoreTitleExample class methodsFor: 'pointcuts' stamp: 'as 9/1/2008 15:22'!
titleAdvice

	<pointcut>

	^ PC class: self method: #title.! !

!DAStoreTitleExample methodsFor: 'advice' stamp: 'as 9/1/2008 16:36'!
title

	<advice: #title control: #instead disabled: false>

	^ 'sushiNet Pro'.! !

!DAStoreTitleExample methodsFor: 'advice' stamp: 'as 9/1/2008 15:27'!
title2

	<advice: #titleAdvice control: #instead disabled: true>

	^ 'sushiNet Pro 2.0'.! !

!DAStoreTitleExample methodsFor: 'advice' stamp: 'as 9/1/2008 16:35'!
title: operation

	<advice: #title control: #instead arguments: #(operation) disabled: true>

	^ operation value, ' Pro'.! !

DAAspect subclass: #DATranscriptExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples'!

!DATranscriptExample commentStamp: 'as 9/1/2008 15:08' prior: 0!
Put a carriage return after each #show: in the Transcript.!

!DATranscriptExample class methodsFor: 'pointcuts' stamp: 'as 9/1/2008 15:09'!
transcriptShow

	<pointcut>

	^ (TranscriptStream >> #show:) asPointcut.! !

!DATranscriptExample methodsFor: 'advices' stamp: 'as 9/1/2008 15:11'!
CrAfterShow: object

	<advice: #transcriptShow control: #after arguments: #(object)>

	object cr.! !
