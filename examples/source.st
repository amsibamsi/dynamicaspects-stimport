SystemOrganization addCategory: #'DAExamples-Simple'!
SystemOrganization addCategory: #'DAExamples-Store'!

DAActiveContext subclass: #DAStoreClosedContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples-Store'!

!DAStoreClosedContext commentStamp: 'as 7/30/2008 20:56' prior: 0!
Active when the store is closed.!

!DAStoreClosedContext methodsFor: 'testing' stamp: 'as 7/30/2008 20:57'!
isActive

	^ Time now seconds even.! !

WAComponent subclass: #DAStoreClosedMessage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples-Store'!

!DAStoreClosedMessage commentStamp: 'as 7/30/2008 21:01' prior: 0!
Render a closed message.!

!DAStoreClosedMessage methodsFor: 'rendering' stamp: 'as 8/1/2008 11:17'!
renderContentOn: html

	html paragraph: [ html emphasis: [ html text: 'Sorry, the store is closed every even second (', Time now asString, ').' ]. ].! !

DAAspect subclass: #DAFibonacciExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples-Simple'!

!DAFibonacciExample commentStamp: 'as 5/29/2008 14:24' prior: 0!
An example with the Fibonacci numbers.!

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

!DAFibonacciExample class methodsFor: 'pointcuts' stamp: 'as 7/11/2008 17:14'!
noEnd

	^ (self class >> #fibNoEnd:) asPointcut.! !

!DAFibonacciExample class methodsFor: 'pointcuts' stamp: 'as 7/14/2008 12:01'!
pointcutNames

	^ #(noEnd).! !

!DAFibonacciExample methodsFor: 'advices' stamp: 'as 7/29/2008 12:24'!
insteadNoEndWithArg1: n operation: operation

	^ n <= 1 ifTrue: [ ^ n. ] ifFalse: [ ^ operation value. ].! !

DAAspect subclass: #DAStoreClosedExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples-Store'!

!DAStoreClosedExample commentStamp: 'as 8/2/2008 18:04' prior: 0!
The store is closed in certain contexts.!

!DAStoreClosedExample class methodsFor: 'pointcuts' stamp: 'as 8/2/2008 18:06'!
entrance

	^ (PC class: WAStoreTask method: #go) & (PC context: DAStoreClosedContext).! !

!DAStoreClosedExample class methodsFor: 'pointcuts' stamp: 'as 8/2/2008 18:06'!
pointcutNames

	^ #(entrance).! !

!DAStoreClosedExample methodsFor: 'advices' stamp: 'as 8/2/2008 18:08'!
insteadEntranceWithObject: task

	task call: DAStoreClosedMessage new.! !

DAAspect subclass: #DAStoreFieldWriteExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples-Store'!

!DAStoreFieldWriteExample commentStamp: 'as 8/3/2008 12:58' prior: 0!
Trace the flow through the seaside components.!

!DAStoreFieldWriteExample class methodsFor: 'pointcuts' stamp: 'as 8/3/2008 20:29'!
fieldWrites

	^ (PC className: 'WAStore*') & (PC fieldWrite).! !

!DAStoreFieldWriteExample class methodsFor: 'pointcuts' stamp: 'as 8/3/2008 20:28'!
pointcutNames

	^ #(fieldWrites).! !

!DAStoreFieldWriteExample methodsFor: 'advices' stamp: 'as 8/3/2008 21:12'!
beforeFieldWritesWithNode: node

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
	category: 'DAExamples-Store'!

!DAStoreRenderExample commentStamp: 'as 8/2/2008 18:10' prior: 0!
Render a halo around each component.!

!DAStoreRenderExample class methodsFor: 'pointcuts' stamp: 'as 8/4/2008 08:49'!
css

	^ (PC class: WAStore method: #style).! !

!DAStoreRenderExample class methodsFor: 'pointcuts' stamp: 'as 8/4/2008 08:44'!
pointcutNames

	^ #(rendering css).! !

!DAStoreRenderExample class methodsFor: 'pointcuts' stamp: 'as 8/2/2008 18:10'!
rendering

	^ (PC className: 'WAStore*' methodName: #renderContentOn:).! !

!DAStoreRenderExample methodsFor: 'advices' stamp: 'as 8/4/2008 08:54'!
beforeRenderingWithArg1: html object: component

	html div id: 'halo'; with: [
		html small: [ html text: component asString. ].
	].! !

!DAStoreRenderExample methodsFor: 'advices' stamp: 'as 8/4/2008 08:57'!
insteadCssWithOperation: o

	^ o value, '
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

DAAspect subclass: #DAStoreTitleExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples-Store'!

!DAStoreTitleExample commentStamp: 'as 8/2/2008 18:16' prior: 0!
Modify the title.!

!DAStoreTitleExample class methodsFor: 'options' stamp: 'as 8/3/2008 21:21'!
disabledAdvices

	^ #(
		"insteadTitle"
		insteadTitleAdvice
		insteadTitleWithOperation:
	).! !

!DAStoreTitleExample class methodsFor: 'pointcuts' stamp: 'as 8/2/2008 17:22'!
pointcutNames

	^ #(title titleAdvice).! !

!DAStoreTitleExample class methodsFor: 'pointcuts' stamp: 'as 8/2/2008 17:20'!
title

	^ PC class: WAStore method: #title.! !

!DAStoreTitleExample class methodsFor: 'pointcuts' stamp: 'as 8/2/2008 17:20'!
titleAdvice

	^ PC class: self method: #insteadTitle.! !

!DAStoreTitleExample methodsFor: 'advices' stamp: 'as 8/2/2008 17:56'!
insteadTitle

	^ 'sushiNet Pro'.! !

!DAStoreTitleExample methodsFor: 'advices' stamp: 'as 8/2/2008 17:58'!
insteadTitleAdvice

	^ 'sushiNet Pro 2.0'.! !

!DAStoreTitleExample methodsFor: 'advices' stamp: 'as 8/2/2008 17:57'!
insteadTitleWithOperation: x

	^ x value, ' Pro'.! !

DAAspect subclass: #DATranscriptExample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples-Simple'!

!DATranscriptExample commentStamp: 'as 7/3/2008 17:55' prior: 0!
Put a carriage return after each #show: in the Transcript.!

!DATranscriptExample class methodsFor: 'initialize-release' stamp: 'as 7/3/2008 18:28'!
initialize

	self disable.
	super initialize.! !

!DATranscriptExample class methodsFor: 'pointcuts' stamp: 'as 7/14/2008 12:06'!
pointcutNames

	^ #(transcriptShow).! !

!DATranscriptExample class methodsFor: 'pointcuts' stamp: 'as 7/21/2008 09:18'!
transcriptShow

	^ (TranscriptStream >> #show:) asPointcut.! !

!DATranscriptExample methodsFor: 'advices' stamp: 'as 7/3/2008 17:52'!
afterTranscriptShowWithObject: object

	object cr.! !
DATranscriptExample initialize!
