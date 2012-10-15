SystemOrganization addCategory: #'DynamicAspects-Kernel'!
SystemOrganization addCategory: #'DynamicAspects-Pointcuts'!
SystemOrganization addCategory: #'DynamicAspects-Tests'!

Object subclass: #DAAspectClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

DAAspectClass class
	instanceVariableNames: 'pointcutNames'!

!DAAspectClass commentStamp: 'as 8/14/2007 10:04' prior: 0!
This makes the transition from an object to an aspect.!

DAAspectClass class
	instanceVariableNames: 'pointcutNames'!

DAAspectClass subclass: #DAAspect
	instanceVariableNames: 'links pc'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

DAAspect class
	instanceVariableNames: 'instance'!

!DAAspect commentStamp: 'as 9/26/2007 14:44' prior: 0!
An aspect is in AOP (Aspect-Oriented Progamming) what and object is in OOP (Object-Oriented Programming). Instead of trying to break down a program into different objects and their corresponding classes, in AOP the entities of modularization are aspects.
An aspect usually covers a cross-cutting concern in OOP that can be implemented much easier with AOP.

Although aspects are not necessarily objects or classes, in this implementation they are implemented as singleton classes in the traditional OOP way to get a good integration with the existing system.!

DAAspect class
	instanceVariableNames: 'instance'!

!DAAspect class methodsFor: 'accessing' stamp: 'as 10/22/2007 09:37'!
allPointcutNames

	^ self superclass pointcutNames addAll: self pointcutNames; yourself.! !

!DAAspect class methodsFor: 'fileIn/Out' stamp: 'as 10/31/2007 13:58'!
definitionST80

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

!DAAspect class methodsFor: 'instance creation' stamp: 'as 10/31/2007 10:33'!
instance

	^ instance ifNil: [ instance := self basicNew initialize. ].! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 10/31/2007 13:59'!
new

	self error: 'I''m singleton, use ', self class name, ' >> instance'.! !

!DAAspect class methodsFor: 'printing' stamp: 'as 10/22/2007 09:38'!
pointcutsString

	^ String streamContents: [
		:stream |
		self pointcutNames do: [
			:each |
			stream nextPutAll: each asString.
		] separatedBy: [ stream space. ].
	].! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 7/18/2007 15:03'!
template: categorySymbol

	^ self templateForSubclassOf: DAAspect name category: categorySymbol. ! !

!DAAspect class methodsFor: 'instance creation' stamp: 'as 10/31/2007 14:00'!
templateForSubclassOf: aClass category: aSymbol

	^ aClass asString, 'subaspect: #NameOfSubaspect
	pointcutNames: ''''
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''' , aSymbol asString , ''''.! !

!DAAspect methodsFor: 'advices' stamp: 'as 10/23/2007 14:03'!
adviceControls

	^ #(before after instead).! !

!DAAspect methodsFor: 'advices' stamp: 'as 10/31/2007 14:21'!
advices

	| possibilities |
	possibilities _ self possibleAdviceNames.
	^ self class methods select: [
		:method |
		possibilities anySatisfy: [ :pos | pos match: method selector. ].
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

!DAAspect methodsFor: 'initialize-release' stamp: 'as 10/31/2007 10:13'!
initializeLinks

	links _ IdentitySet new.! !

!DAAspect methodsFor: 'installing' stamp: 'as 10/24/2007 10:15'!
install

	| visitor |
	visitor _ DANodeCollector new.
	self isInstalled ifFalse: [
		self advices do: [
			:adv |
			| link |
			visitor visit: (self pointcutForAdvice: adv).
			link _ GPLink new
				metaObject: self;
				selector: adv selector;
				arguments: (self reificationsForAdvice: adv);
				control: (self controlForAdvice: adv);
				yourself.
			visitor condition ifNotNil: [ link condition: visitor condition. ].
			self install: link on: visitor nodes.
		].
	].! !

!DAAspect methodsFor: 'installing' stamp: 'as 10/24/2007 15:22'!
install: aGPLink on: aCollection

	aCollection do: [
		:node |
		node link: aGPLink.
	].
	links add: aGPLink.! !

!DAAspect methodsFor: 'testing' stamp: 'as 10/23/2007 13:39'!
isInstalled

	^ links isEmpty not.! !

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

!DAAspect methodsFor: 'advices' stamp: 'as 10/31/2007 10:32'!
possibleAdviceNames

	| names |
	names _ Set new.
	self allPointcutNames do: [
		:pcn |
		self adviceControls do: [
			:ctrl |
			names add: ctrl, pcn capitalized, '*'.
		].
	].
	^ names.! !

!DAAspect methodsFor: 'advices' stamp: 'as 10/24/2007 15:28'!
reificationsForAdvice: aMethod

	^ aMethod reflectiveMethod argumentNames collect: [ :name | name asSymbol. ].! !

!DAAspect methodsFor: 'installing' stamp: 'as 10/24/2007 10:00'!
uninstall

	self isInstalled ifTrue: [
		links do: [ :link | link uninstall. ].
		self initializeLinks.
	].! !

DAAspect subclass: #DATestAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DATestAspect commentStamp: 'as 10/8/2007 10:18' prior: 0!
An aspect to run tests on.!

!DATestAspect methodsFor: 'advices' stamp: 'as 10/24/2007 15:11'!
afterExample1

	DAExamples count.! !

!DATestAspect methodsFor: 'advices' stamp: 'as 10/31/2007 14:39'!
beforeExample2

	DAExamples count.! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 10/31/2007 14:32'!
example1

	^ pc method: DAExamples class >> #example1.! !

!DATestAspect methodsFor: 'pointcuts' stamp: 'as 10/31/2007 14:41'!
example2

	^ pc method: DAExamples class >> #example2.! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 10/31/2007 10:38'!
pointcutNames

	^ pointcutNames ifNil: [ pointcutNames _ Set new. ].! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 10/31/2007 10:38'!
pointcutNames: aString

	pointcutNames _ self stringToSymbols: aString.! !

!DAAspectClass class methodsFor: 'accessing' stamp: 'as 7/23/2007 15:01'!
stringToSymbols: aString

	| set |
	set _ Set new.
	(aString subStrings: ' ') do: [
		:substring |
		set add: substring asSymbol.
	].
	^ set.! !

!DAAspectClass class methodsFor: 'subaspect creation' stamp: 'as 10/22/2007 09:26'!
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

Object subclass: #DAExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

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

!DAExamples class methodsFor: 'examples' stamp: 'as 10/23/2007 16:23'!
example1

	counter _ 2.! !

!DAExamples class methodsFor: 'examples' stamp: 'as 10/31/2007 14:39'!
example2

	counter _ 2.! !

!DAExamples class methodsFor: 'counting' stamp: 'as 10/23/2007 16:22'!
initializeCounter

	counter _ 0.! !

Object subclass: #DAPointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DAPointcut commentStamp: 'as 9/12/2007 15:21' prior: 0!
Pointcuts are used to describe a set of join points. So far, the only type of join points are nodes from in reflective method.!

DAPointcut subclass: #DACompositePointcut
	instanceVariableNames: 'children'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DACompositePointcut commentStamp: 'as 9/18/2007 16:38' prior: 0!
A composition of one or more pointcuts, which can be compositions as well.!

DACompositePointcut subclass: #DAAndCompositePointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAAndCompositePointcut commentStamp: 'as 8/16/2007 15:00' prior: 0!
Logical And of 2 pointcuts.!

!DAAndCompositePointcut methodsFor: 'visiting' stamp: 'as 9/18/2007 17:35'!
visitName

	^ 'and'.! !

!DACompositePointcut class methodsFor: 'instance creation' stamp: 'as 9/18/2007 16:45'!
child: aDAPointcut

	^ self new
		children: {aDAPointcut};
		yourself.! !

!DACompositePointcut class methodsFor: 'instance creation' stamp: 'as 9/18/2007 16:44'!
child: firstDAPointcut child: secondDAPointcut

	^ self new
		children: {firstDAPointcut. secondDAPointcut};
		yourself.! !

!DACompositePointcut class methodsFor: 'instance creation' stamp: 'as 9/18/2007 16:44'!
children: aCollection

	^ self new
		children: aCollection;
		yourself.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 10/8/2007 12:06'!
child

	^ children first.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 10/17/2007 16:23'!
children

	^ children.! !

!DACompositePointcut methodsFor: 'accessing' stamp: 'as 9/18/2007 16:40'!
children: aCollection

	children _ aCollection.! !

DACompositePointcut subclass: #DAOrCompositePointcut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAOrCompositePointcut commentStamp: 'as 8/16/2007 15:01' prior: 0!
Logical Or of 2 poincuts.!

!DAOrCompositePointcut methodsFor: 'visiting' stamp: 'as 9/18/2007 17:35'!
visitName

	^ 'or'.! !

DACompositePointcut subclass: #DAWithinPointcut
	instanceVariableNames: 'categoryString classString'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAWithinPointcut commentStamp: 'as 10/8/2007 11:14' prior: 0!
Specify a location within categories and classes.!

!DAWithinPointcut methodsFor: 'accessing' stamp: 'as 10/24/2007 14:56'!
categoryString: aString

	categoryString _ aString ifNil: [ '*'. ].! !

!DAWithinPointcut methodsFor: 'accessing' stamp: 'as 10/24/2007 14:57'!
classString: aString

	classString _ aString ifNil: [ '*'. ].! !

!DAWithinPointcut methodsFor: 'evaluating' stamp: 'as 10/17/2007 16:14'!
classes

	^ self classesMatching: classString inCategoriesMatching: categoryString.! !

!DAWithinPointcut methodsFor: 'visiting' stamp: 'as 9/18/2007 17:35'!
visitName

	^ 'within'.! !

DAPointcut subclass: #DAFieldAccessPointcut
	instanceVariableNames: 'classString fieldString properties'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAFieldAccessPointcut commentStamp: 'as 10/30/2007 15:37' prior: 0!
Access to an instance or temporary variable.!

!DAFieldAccessPointcut class methodsFor: 'instance creation' stamp: 'as 10/26/2007 15:13'!
field: fieldString class: classString

	^ self new
		fieldString: fieldString;
		classString: classString;
		yourself.! !

!DAFieldAccessPointcut methodsFor: 'accessing' stamp: 'as 10/24/2007 17:28'!
classString: aString

	classString _ aString ifNil: [ '*'. ].! !

!DAFieldAccessPointcut methodsFor: 'evaluating' stamp: 'as 10/24/2007 17:32'!
classes

	^ self classesMatching: classString inCategoriesMatching: '*'.! !

!DAFieldAccessPointcut methodsFor: 'evaluating' stamp: 'as 10/30/2007 14:20'!
fieldNodes

	| nodes |
	nodes _ IdentitySet new.
	self classes do: [
		:class |
		class methods do: [
			:method |
			method reflectiveMethod nodesDo: [
				:node |
				(node isVariable and: [ self matches: node. ])
					ifTrue: [ nodes add: node. ].
			].
		].
	].
	^ nodes.! !

!DAFieldAccessPointcut methodsFor: 'accessing' stamp: 'as 10/24/2007 17:28'!
fieldString: aString

	fieldString _ aString ifNil: [ '*'. ].! !

!DAFieldAccessPointcut methodsFor: 'initialize-release' stamp: 'as 10/24/2007 18:22'!
initialize

	properties _ Dictionary new.
	#(instance temp read write) do: [
		:key |
		properties at: key put: false.
	].! !

!DAFieldAccessPointcut methodsFor: 'accessing' stamp: 'as 10/24/2007 18:20'!
instance

	properties at: #instance put: true.! !

!DAFieldAccessPointcut methodsFor: 'testing' stamp: 'as 10/24/2007 18:22'!
isInstance

	^ properties at: #instance.! !

!DAFieldAccessPointcut methodsFor: 'testing' stamp: 'as 10/24/2007 18:23'!
isRead

	^ properties at: #read.! !

!DAFieldAccessPointcut methodsFor: 'testing' stamp: 'as 10/24/2007 18:23'!
isTemp

	^ properties at: #temp.! !

!DAFieldAccessPointcut methodsFor: 'testing' stamp: 'as 10/24/2007 18:23'!
isWrite

	^ properties at: #write.! !

!DAFieldAccessPointcut methodsFor: 'evaluating' stamp: 'as 10/26/2007 15:21'!
matches: aPEProgramNode

	^ (self matchesName: aPEProgramNode)
		and: [ self matchesType: aPEProgramNode. ]
		and: [ self matchesMode: aPEProgramNode. ].! !

!DAFieldAccessPointcut methodsFor: 'evaluating' stamp: 'as 10/30/2007 14:09'!
matchesMode: aNode

	^ (self isRead and: [ aNode isRead. ]) or: [ self isWrite and: [ aNode isWrite. ]. ].! !

!DAFieldAccessPointcut methodsFor: 'evaluating' stamp: 'as 10/24/2007 18:08'!
matchesName: aNode

	^ fieldString match: aNode name.! !

!DAFieldAccessPointcut methodsFor: 'evaluating' stamp: 'as 10/30/2007 14:08'!
matchesType: aNode

	^ (self isInstance and: [ aNode isInstance. ]) or: [ self isTemp and: [ aNode isTemp. ]. ].! !

!DAFieldAccessPointcut methodsFor: 'accessing' stamp: 'as 10/24/2007 18:20'!
read

	properties at: #read put: true.! !

!DAFieldAccessPointcut methodsFor: 'accessing' stamp: 'as 10/24/2007 18:20'!
temp

	properties at: #temp put: true.! !

!DAFieldAccessPointcut methodsFor: 'visiting' stamp: 'as 10/24/2007 17:24'!
visitName

	^ 'field'.! !

!DAFieldAccessPointcut methodsFor: 'accessing' stamp: 'as 10/24/2007 18:20'!
write

	properties at: #write put: true.! !

DAPointcut subclass: #DAMethodPointcut
	instanceVariableNames: 'methodString classString'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Pointcuts'!

!DAMethodPointcut commentStamp: 'as 8/16/2007 15:00' prior: 0!
A method that is being executed.!

!DAMethodPointcut class methodsFor: 'instance creation' stamp: 'as 10/24/2007 09:47'!
method: aCompiledMethod

	^ self new
		methodString: aCompiledMethod selector asString;
		classString: aCompiledMethod methodClass asString;
		yourself.! !

!DAMethodPointcut class methodsFor: 'instance creation' stamp: 'as 10/17/2007 15:05'!
method: methodString class: classString

	^ self new
		methodString: methodString;
		classString: classString;
		yourself.! !

!DAMethodPointcut methodsFor: 'accessing' stamp: 'as 10/24/2007 17:27'!
classString: aString

	classString _ aString ifNil: [ '*'. ].! !

!DAMethodPointcut methodsFor: 'accessing' stamp: 'as 10/24/2007 17:27'!
methodString: aString

	methodString _ aString ifNil: [ '*'. ].! !

!DAMethodPointcut methodsFor: 'evaluating' stamp: 'as 10/17/2007 15:50'!
methods

	^ self methodsMatching: methodString inClassesMatching: classString inCategoriesMatching: '*'.! !

!DAMethodPointcut methodsFor: 'visiting' stamp: 'as 10/31/2007 14:29'!
visitName

	^ 'method'.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 10/31/2007 10:09'!
field: fieldString in: classString

	^ (DAFieldAccessPointcut field: fieldString class: classString)
		read; write; instance; temp;
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 10/31/2007 10:09'!
instanceVar: fieldString in: classString

	^ (DAFieldAccessPointcut field: fieldString class: classString)
		read; write; instance;
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 10/31/2007 10:09'!
instanceVarRead: fieldString in: classString

	^ (DAFieldAccessPointcut field: fieldString class: classString)
		read; instance;
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 10/31/2007 10:09'!
instanceVarWrite: fieldString in: classString

	^ (DAFieldAccessPointcut field: fieldString class: classString)
		write; instance;
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 10/31/2007 14:30'!
method: aCompiledMethod

	^ DAMethodPointcut method: aCompiledMethod.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 10/31/2007 14:31'!
method: methodString in: classString

	^ DAMethodPointcut method: methodString class: classString.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 10/31/2007 10:10'!
readField: fieldString in: classString

	^ (DAFieldAccessPointcut field: fieldString class: classString)
		read; instance; temp;
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 10/31/2007 10:10'!
tempVar: fieldString in: classString

	^ (DAFieldAccessPointcut field: fieldString class: classString)
		read; write; temp;
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 10/31/2007 10:10'!
tempVarRead: fieldString in: classString

	^ (DAFieldAccessPointcut field: fieldString class: classString)
		read; temp;
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 10/31/2007 10:10'!
tempVarWrite: fieldString in: classString

	^ (DAFieldAccessPointcut field: fieldString class: classString)
		write; temp;
		yourself.! !

!DAPointcut class methodsFor: 'instance creation' stamp: 'as 10/31/2007 10:09'!
writeField: fieldString in: classString

	^ (DAFieldAccessPointcut field: fieldString class: classString)
		write; instance; temp;
		yourself.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 10/17/2007 11:26'!
acceptVisitor: aDAPointcutVisitor

	aDAPointcutVisitor perform: ('visit', self visitName capitalized, ':') asSymbol with: self.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 9/18/2007 16:46'!
and: aDAPointcut

	^ DAAndCompositePointcut child: self child: aDAPointcut.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 10/17/2007 16:01'!
category: aString

	^ self category: aString class: nil.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 10/17/2007 16:22'!
category: categoryString class: classString

	^ (DAWithinPointcut child: self)
		categoryString: categoryString;
		classString: classString;
		yourself.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 9/18/2007 17:03'!
class: aString

	^ self category: nil class: aString.! !

!DAPointcut methodsFor: 'searching classes' stamp: 'as 10/24/2007 14:41'!
class: aClass matches: classString inCategory: categoryString

	^ (classString match: aClass name) and:
		[ categoryString match: aClass instanceSide category. ].! !

!DAPointcut methodsFor: 'searching classes' stamp: 'as 10/24/2007 14:42'!
classesMatching: classString inCategoriesMatching: categoryString

	| classes |
	classes _ Set new.
	Smalltalk allClasses do: [
		:class |
		(self class: class instanceSide matches: classString inCategory: categoryString) ifTrue: [
			classes add: class instanceSide.
		].
		(self class: class classSide matches: classString inCategory: categoryString) ifTrue: [
			classes add: class classSide.
		].
	].
	^ classes.! !

!DAPointcut methodsFor: 'searching classes' stamp: 'as 10/24/2007 14:44'!
methodsMatching: methodString inClassesMatching: classString inCategoriesMatching: categoryString

	| methods |
	methods _ Set new.
	(self classesMatching: classString inCategoriesMatching: categoryString) do: [
		:each |
		methods addAll:
			(each methods select: [ :method | methodString match: method selector. ]).
	].
	^ methods.! !

!DAPointcut methodsFor: 'composing' stamp: 'as 9/18/2007 16:46'!
or: aDAPointcut

	^ DAOrCompositePointcut child: self child: aDAPointcut.! !

!DAPointcut methodsFor: 'visiting' stamp: 'as 9/18/2007 17:34'!
visitName

	self subclassResponsibility.! !

Object subclass: #DAPointcutVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DAPointcutVisitor commentStamp: 'as 9/26/2007 15:24' prior: 0!
Generic visitor for a pointcut structure.!

DAPointcutVisitor subclass: #DANodeCollector
	instanceVariableNames: 'nodes condition'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Kernel'!

!DANodeCollector commentStamp: 'as 9/26/2007 15:23' prior: 0!
Visit a pointcut structure and collect all corresponding nodes in the reflective system.!

!DANodeCollector methodsFor: 'nodes' stamp: 'as 10/2/2007 16:02'!
addNode: aRBProgramNode

	nodes add: aRBProgramNode.! !

!DANodeCollector methodsFor: 'nodes' stamp: 'as 9/18/2007 18:16'!
addNodes: aCollection

	nodes addAll: aCollection.! !

!DANodeCollector methodsFor: 'accessing' stamp: 'as 10/2/2007 16:07'!
condition

	^ condition.! !

!DANodeCollector methodsFor: 'accessing' stamp: 'as 10/2/2007 16:07'!
condition: aBlock

	condition _ aBlock.! !

!DANodeCollector methodsFor: 'initialize-release' stamp: 'as 10/24/2007 10:09'!
initialize

	self initializeNodes.! !

!DANodeCollector methodsFor: 'initialize-release' stamp: 'as 10/9/2007 17:00'!
initializeNodes

	nodes _ Set new.! !

!DANodeCollector methodsFor: 'accessing' stamp: 'as 9/26/2007 15:10'!
nodes

	^ nodes.! !

!DANodeCollector methodsFor: 'visiting' stamp: 'as 10/23/2007 14:25'!
visit: pointcut

	self initializeNodes.
	super visit: pointcut.! !

!DANodeCollector methodsFor: 'visiting' stamp: 'as 10/19/2007 11:21'!
visitAnd: pointcut

	| tmpNodes1 tmpNodes2 |
	tmpNodes1 _ nodes.
	self initializeNodes.
	self visit: pointcut children first.
	tmpNodes2 _ nodes.
	self initializeNodes.
	self visit: pointcut children second.
	tmpNodes1 addAll: (tmpNodes2 select: [ :node | nodes includes: nodes. ]).
	nodes _ tmpNodes1.! !

!DANodeCollector methodsFor: 'visiting' stamp: 'as 10/30/2007 15:37'!
visitField: pointcut

	self addNodes: pointcut fieldNodes.! !

!DANodeCollector methodsFor: 'visiting' stamp: 'as 10/31/2007 14:30'!
visitMethod: pointcut

	self addNodes:
		(pointcut methods collect: [ :each | each methodNode. ]).! !

!DANodeCollector methodsFor: 'visiting' stamp: 'as 10/19/2007 11:13'!
visitOr: pointcut

	pointcut children do: [
		:child |
		self visit: child.
	].! !

!DANodeCollector methodsFor: 'visiting' stamp: 'as 10/19/2007 11:14'!
visitWithin: pointcut

	| tmpNodes classes |
	tmpNodes _ nodes.
	self initializeNodes.
	classes _ pointcut classes.
	pointcut children do: [ :child | self visit: child. ].
	nodes _ nodes select: [
		:node |
		classes includes: node method methodClass.
	].
	nodes addAll: tmpNodes.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 10/23/2007 14:24'!
visit: aDAPointcut

	aDAPointcut acceptVisitor: self.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 10/23/2007 14:24'!
visitAnd: aDAWithinPointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 10/26/2007 15:20'!
visitField: aDAMethodExecutionPointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 10/31/2007 14:30'!
visitMethod: aDAMethodExecutionPointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 10/23/2007 14:25'!
visitOr: aDAWithinPointcut

	self subclassResponsibility.! !

!DAPointcutVisitor methodsFor: 'visiting' stamp: 'as 10/9/2007 16:48'!
visitWithin: aDAWithinPointcut

	self subclassResponsibility.! !

!Browser methodsFor: '*DynamicAspects' stamp: 'as 7/23/2007 17:33'!
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
	
	"The next line is a fix for DynamicAspects, which do not contain the word 'subclass',
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

TestCase subclass: #DAAspectTest
	instanceVariableNames: 'example aspect'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

!DAAspectTest commentStamp: 'as 8/14/2007 10:30' prior: 0!
Testing DAAspect.!

!DAAspectTest methodsFor: 'running' stamp: 'as 7/18/2007 10:37'!
removeAllLinksOn: aClass

	aClass methodDict values do: [
		:method |
		method reflectiveMethod methodNode nodesDo: [
			:node |
			node hasAnyLink ifTrue: [ node removeAllLinks. ].
			self assert: node hasAnyLink not.
		].
	].! !

!DAAspectTest methodsFor: 'running' stamp: 'as 10/31/2007 14:34'!
setUp

	super initialize.
	self removeAllLinksOn: DAExamples.
	DAExamples initializeCounter.
	DATestAspect instance install.! !

!DAAspectTest methodsFor: 'running' stamp: 'as 10/31/2007 14:34'!
tearDown

	DATestAspect instance uninstall.
	self removeAllLinksOn: DAExamples.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 10/31/2007 14:40'!
testAfter

	DAExamples example1.
	self assert: DAExamples counter = 3.! !

!DAAspectTest methodsFor: 'testing' stamp: 'as 10/31/2007 14:41'!
testBefore

	DAExamples example2.
	self assert: DAExamples counter = 2.! !

TestCase subclass: #DACodingTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DynamicAspects-Tests'!

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
