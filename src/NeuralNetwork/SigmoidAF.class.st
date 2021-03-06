Class {
	#name : #SigmoidAF,
	#superclass : #ActivationFunction,
	#category : #NeuralNetwork
}

{ #category : #overrides }
SigmoidAF >> derivative: output [ 
	^ output * (1 - output)
]

{ #category : #overrides }
SigmoidAF >> eval: z [
	^ 1 / (1 + z negated exp)
]
