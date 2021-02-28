Class {
	#name : #Neuron,
	#superclass : #Object,
	#instVars : [
		'weights',
		'bias',
		'learningRate',
		'activationFunction',
		'delta',
		'output'
	],
	#category : #NeuralNetwork
}

{ #category : #accessing }
Neuron >> adjustBias [
	bias := bias + (learningRate * delta)
]

{ #category : #activating }
Neuron >> adjustDeltaWith: anError [
	delta := anError * (activationFunction derivative: output)
]

{ #category : #accessing }
Neuron >> adjustWeightWithInput: inputs [
	inputs withIndexDo: [ :anInput :index |
		weights at: index put: ((weights at: index) + (learningRate * delta * anInput))
	]
]

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
Neuron >> delta [
	"エラーを伝播する際に計算したdelta値を返す"
    ^ delta
]

{ #category : #accessing }
Neuron >> feed: inputs [
	| z |
	z := (inputs with: weights collect: [ :x :w | x * w ]) sum + bias.
	output := activationFunction eval: z .
	^ output
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

{ #category : #accessing }
Neuron >> output [
	"feed:を実行した時に計算されたoutput値を返す"
	^ output
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
	| diff _output _delta |
	_output := self feed: inputs.
	diff := desiredOutput - _output .
    _delta := diff * (activationFunction derivative: _output).
	inputs withIndexDo: [ :anInput :index |
		weights at: index put: ((weights at: index) + (learningRate * _delta * anInput))].
	bias := bias + (learningRate * _delta)
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
