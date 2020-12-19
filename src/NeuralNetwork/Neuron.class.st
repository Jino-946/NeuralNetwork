Class {
	#name : #Neuron,
	#superclass : #Object,
	#instVars : [
		'weights',
		'bias'
	],
	#category : #NeuralNetwork
}

{ #category : #accessing }
Neuron >> bias [
	"return the bias of the neuron."
	^bias
	
]

{ #category : #accessing }
Neuron >> bias: aNumber [
	"set the bias of the neuron."
	bias := aNumber
	
]

{ #category : #accessing }
Neuron >> feed: inputs [
	| z |
	z := (inputs with: weights collect: [ :x :w | x * w ]) sum + bias.
	^ z > 0 ifTrue: [ 1 ] ifFalse: [ 0 ]
	

]

{ #category : #accessing }
Neuron >> weights [
	"return the weights of the neuro."
	^ weights 
]

{ #category : #accessing }
Neuron >> weights: someWeightsAsNumbers [
	"set the weights of the neuron.
	takes a collection of numbers as argument."
	weights := someWeightsAsNumbers 
]
