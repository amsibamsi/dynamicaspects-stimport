SystemOrganization addCategory: #'DAExamples-Simple'!
SystemOrganization addCategory: #'DAExamples-Store'!

DAActiveContext subclass: #DAStoreClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples-Store'!

!DAStoreClosed commentStamp: 'as 7/30/2008 20:56' prior: 0!
Active when the store is closed.!

!DAStoreClosed methodsFor: 'testing' stamp: 'as 7/30/2008 20:57'!
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

DAAspect subclass: #DAStoreExample
	instanceVariableNames: 'orders fields'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DAExamples-Store'!

!DAStoreExample commentStamp: 'as 7/21/2008 16:46' prior: 0!
The famous sushi store example.!

!DAStoreExample classSide methodsFor: 'pointcuts' stamp: 'as 7/30/2008 20:58'!
closed

	^ (PC class: WAStoreTask method: #go) & (PC context: DAStoreClosed).! !

!DAStoreExample classSide methodsFor: 'pointcuts' stamp: 'as 7/29/2008 17:47'!
confirmation

	^ PC class: WAStoreTask method: #shipTo:billTo:payWith:.! !

!DAStoreExample classSide methodsFor: 'options' stamp: 'as 8/2/2008 16:57'!
disabledAdvices

	^ #(
		insteadTitle
		insteadTitle2
		insteadTitleWithOperation:
		insteadSubtitleWithOperation:
		afterConfirmation
		beforeRenderingWithArg1:object:
		insteadClosedWithObject:
	).! !

!DAStoreExample classSide methodsFor: 'pointcuts' stamp: 'as 8/2/2008 16:59'!
pointcutNames

	^ #(title title2 subtitle confirmation rendering closed seaside).! !

!DAStoreExample classSide methodsFor: 'pointcuts' stamp: 'as 7/30/2008 15:33'!
rendering

	^ (PC className: 'WAStore*' methodName: #renderContentOn:).! !

!DAStoreExample classSide methodsFor: 'pointcuts' stamp: 'as 8/2/2008 17:02'!
seaside

	^ (PC className: 'WAStoreCartView' methodName: 'cart*') & (PC behavior: WAComponent).! !

!DAStoreExample classSide methodsFor: 'pointcuts' stamp: 'as 7/29/2008 17:26'!
subtitle

	^ PC class: WAStore method: #subtitle.! !

!DAStoreExample classSide methodsFor: 'pointcuts' stamp: 'as 7/21/2008 16:49'!
title

	^ PC class: WAStore method: #title.! !

!DAStoreExample classSide methodsFor: 'pointcuts' stamp: 'as 7/21/2008 16:51'!
title2

	^ PC class: self method: #insteadTitle.! !

!DAStoreExample methodsFor: 'advices' stamp: 'as 7/30/2008 15:02'!
afterConfirmation

	self ordered: 1.! !

!DAStoreExample methodsFor: 'advices' stamp: 'as 7/30/2008 15:24'!
beforeRenderingWithArg1: html object: component

	html paragraph: [ html small: [ html text: component asString. ]. ].! !

!DAStoreExample methodsFor: 'advices' stamp: 'as 8/2/2008 17:04'!
beforeSeasideWithNode: node

	Transcript show: 'before ', node asString.
	Transcript cr.! !

!DAStoreExample methodsFor: 'accessing' stamp: 'as 7/31/2008 13:56'!
fieldAt: anObject

	^ self fields at: anObject ifAbsent: [ 0. ].! !

!DAStoreExample methodsFor: 'accessing' stamp: 'as 7/31/2008 13:56'!
fieldAt: aObject put: aNumber

	self fields at: aObject put: aNumber.! !

!DAStoreExample methodsFor: 'accessing' stamp: 'as 7/31/2008 13:53'!
fields

	^ fields ifNil: [ fields _ Dictionary new. ].! !

!DAStoreExample methodsFor: 'advices' stamp: 'as 7/30/2008 21:04'!
insteadClosedWithObject: task

	task call: DAStoreClosedMessage new.! !

!DAStoreExample methodsFor: 'advices' stamp: 'as 7/30/2008 15:02'!
insteadSubtitleWithOperation: o

	^ o value, ' (', self orders asString, ' orders)'.! !

!DAStoreExample methodsFor: 'advices' stamp: 'as 7/25/2008 10:55'!
insteadTitle

	^ 'sushiNet Pro'.! !

!DAStoreExample methodsFor: 'advices' stamp: 'as 7/25/2008 10:55'!
insteadTitle2

	^ 'sushiNet Pro 2.0'.! !

!DAStoreExample methodsFor: 'advices' stamp: 'as 7/28/2008 13:53'!
insteadTitleWithOperation: x

	^ x value, ' Pro'.! !

!DAStoreExample methodsFor: 'accessing' stamp: 'as 7/30/2008 14:36'!
ordered

	self orders: self orders + 1.! !

!DAStoreExample methodsFor: 'accessing' stamp: 'as 7/30/2008 14:36'!
ordered: aNumber

	self orders: self orders + aNumber.! !

!DAStoreExample methodsFor: 'accessing' stamp: 'as 7/30/2008 14:36'!
orders

	^ orders ifNil: [ orders _ 0. ].! !

!DAStoreExample methodsFor: 'accessing' stamp: 'as 7/30/2008 14:36'!
orders: aNumber

	orders _ aNumber.! !

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
