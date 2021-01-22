Class {
	#name : #Neuron,
	#superclass : #Object,
	#instVars : [
		'weights',
		'bias',
		'learningRate',
		'activationFunction'
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
	^ activationFunction eval: z
]

{ #category : #accessing }
Neuron >> initialize [ 
	super initialize.
	learningRate := 0.1.
	self sigmoid

]

{ #category : #accessing }
Neuron >> learningRate [
	"return the learningRate of the neuron."
	^learningRate 
	
	
]

{ #category : #accessing }
Neuron >> learningRate: aLearningRateAsFloat [
	"set the learningRate of the neuron."
	learningRate := aLearningRateAsFloat  
	
	
	
]

{ #category : #activating }
Neuron >> sigmoid [
	"Use the sigmoid activation function"
    activationFunction := SigmoidAF new
]

{ #category : #activating }
Neuron >> step [
	"Use the step activation function"
    activationFunction := StepAF new
]

{ #category : #accessing }
Neuron >> train: inputs desiredOutput: desiredOutput [
	| diff output delta |
	output := self feed: inputs.
	diff := desiredOutput - output .
    delta := diff * (activationFunction derivative: output).
	inputs withIndexDo: [ :anInput :index |
		weights at: index put: ((weights at: index) + (delta * anInput * learningRate))].
	bias := bias + (delta * learningRate)
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
