
!ReflectiveMethod methodsFor: '*DAReflectivityFixes' stamp: 'as 7/19/2008 17:52'!
currentMethod

	^ self methodClass methodDict at: self selector.! !

!ReflectiveMethod methodsFor: '*DAReflectivityFixes' stamp: 'as 7/19/2008 18:00'!
isCurrent

	^ self currentMethod == self or: [ self currentMethod == compiledMethod. ].! !

!ReflectiveMethod methodsFor: '*DAReflectivityFixes' stamp: 'as 7/19/2008 17:56'!
isInvalid

	"The cache is invalidated by installing the RM in the MethodDictionary.
	 But this should only be done if this method is still current, meaning
	 it is in the method dictionary of the class.
	
	 The state of the compiledMethod is *not* the trigger!!"
	
	^ self == self currentMethod or: [ self isCurrent not. ].
	
	! !

!GPLink methodsFor: '*DAReflectivityFixes' stamp: 'as 8/3/2008 20:30'!
nodes
	^nodes ifNil: [nodes := IdentitySet new].! !

!RBProgramNode methodsFor: '*DAReflectivityFixes' stamp: 'as 7/30/2008 17:47'!
deleteLink: aLink

	"Remove the link only in the method, don't touch the link's nodes."

	self hasAnyLink ifFalse: [ ^ self. ].
	(self annotationAt: #link) values remove: aLink ifAbsent: [].
	(self annotationAt: #link) values ifEmpty: [ self removeAllLinks. ]. 
	
	self resetCache.! !

!PEInlineCompilationStrategy methodsFor: '*DAReflectivityFixes' stamp: 'as 7/30/2008 18:12'!
addOutlineReturnAfter: original to: aSequenceNode

	| body statements last lastIsReturn |

	body _ original body copy.
	statements _ body statements.
	statements size > 0 ifTrue: [
		last _ statements last.
		lastIsReturn _ last isReturn.
	] ifFalse: [
		last _ nil.
		lastIsReturn _ false.
	].
	lastIsReturn ifTrue: [
		body replaceNode: last withNode: last value ].
	aSequenceNode addNode: (self
		wrap: body
		withEnsure: original after asSequenceNode).
	^ lastIsReturn
		ifTrue: [ (RBReturnNode value: aSequenceNode) asSequenceNode ]
		ifFalse: [ aSequenceNode ]! !

!GPOperationParameter methodsFor: '*DAReflectivityFixes' stamp: 'as 7/30/2008 17:47'!
genForRBMethodNode
	"The method wrapped needs to be the method with just not our link"
	
	| methodNode |
	methodNode := node copy.
	methodNode annotations: methodNode annotations copy.
	methodNode deleteLink: link.
	
	^ RBMessageNode 
			receiver: GPMethod asLiteralNode
			selector: #method:receiver:arguments:
			arguments:  {   methodNode generate compiledMethod asLiteralNode. 
							RBMessageNode 
								receiver: (RBVariableNode named: 'thisContext')
								selector: #receiver.
							(GPArgumentsParameter node: node link: link) genForRBMethodNode}
! !
