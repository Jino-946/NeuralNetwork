Class {
	#name : #StepAF,
	#superclass : #ActivationFunction,
	#category : #NeuralNetwork
}

{ #category : #overrides }
StepAF >> derivative: output [ 
	^ 1
]

{ #category : #overrides }
StepAF >> eval: z [
	^ (z > 0) ifTrue: [ 1 ] ifFalse: [ 0 ]
]
