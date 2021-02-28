Class {
	#name : #NeuronLayer,
	#superclass : #Object,
	#instVars : [
		'previousLayer',
		'nextLayer',
		'neurons'
	],
	#category : #NeuralNetwork
}

{ #category : #accessing }
NeuronLayer >> backwardPropagateError [
	"再帰メソッド。伝播は最終層である出力層から始まる"
	
	"現在地は隠れ層"
	neurons doWithIndex: [ :neuron :j |
		| theError |
		theError := 0.0 .
		self nextLayer neurons do: [ :nextNeuron |
			theError := theError + ((nextNeuron weights at: j) * nextNeuron delta)
		].
		neuron adjustDeltaWith: theError
	] .
	self previousLayer notNil 
		ifTrue: [ self previousLayer backwardPropagateError ]
]

{ #category : #accessing }
NeuronLayer >> backwardPropagateError: expected [ 
	"再帰メソッド最終層である出力層から伝播は開始される"

	"現在地は出力層"
	neurons with: expected do: [ :neuron :exp |
		| theError |
		theError := exp - neuron output .
		neuron adjustDeltaWith: theError ] .
	
	"繰り返す"
	self previousLayer notNil 
		ifTrue: [  self previousLayer backwardPropagateError ].
]

{ #category : #accessing }
NeuronLayer >> feed: someInputValues [
	"Feed the neuron layer with some inputs"
    | someOutputs |
    someOutputs := neurons collect: [ :n | n feed: someInputValues ] as: Array.
    ^ self isOutputLayer
    	ifTrue: [ someOutputs]
		ifFalse: [ nextLayer feed: someOutputs]

]

{ #category : #initialization }
NeuronLayer >> initializeNbOfNeurons: nbOfNeurons nbOfWeights: nbOfWeights using: random [
	"Main method to initialize a neuron layer
	 nbOfNeurons : number of neurons the layer should be made of
	 nbOfWeights : nember of weightd each neuron should have
	 random : a random number generator
	"
	| weights |
	neurons := (1 to: nbOfNeurons) collect: [ :i |
		weights := (1 to: nbOfWeights) collect: [ :ii | random next * 4 - 2].
    	Neuron new sigmoid; weights: weights; bias: (random next * 4 - 2)
	].

	self learningRate: 0.1

]

{ #category : #accessing }
NeuronLayer >> isOutputLayer [
	"Return true if the layer is the output layer
     (i.e., the last layer, right-most in the network)"
    ^ self nextLayer isNil


]

{ #category : #accessing }
NeuronLayer >> learningRate: aLearningRate [
	" 
	Set the learning rate for all neurons
  	Note that this method should be called after configuring the network,
 	and_not_before
	"
    self assert: [ neurons notEmpty] description: 'learningRate: should be invoked after configuring the layer'.
         
    neurons do: [ :n | n learningRate: aLearningRate]
]

{ #category : #accessing }
NeuronLayer >> neurons [
	"Return the neurons I am composed of"
    ^neurons
]

{ #category : #accessing }
NeuronLayer >> nextLayer [
	"Return the next layer connected to me"
    ^nextLayer
]

{ #category : #accessing }
NeuronLayer >> nextLayer: aLayer [
	"Set the next layer"
    nextLayer := aLayer
]

{ #category : #accessing }
NeuronLayer >> numberOfNeurons [
	"Return the number of neurons in the layer"
    ^neurons size
]

{ #category : #accessing }
NeuronLayer >> previousLayer [
	"Return the previous layer connected to me"
    ^previousLayer
]

{ #category : #accessing }
NeuronLayer >> previousLayer: aLayer [
	"Set the previous layer"
    previousLayer := aLayer
]

{ #category : #accessing }
NeuronLayer >> updateWeight [
	"初期入力を元にニューロンの重みを更新する。
	 このメソッドは、メソッドを呼び出すメッセージのレシーバが
	 最初の隠れ層であることを前提としている。
	
	現在地は2番目の隠れ層または出力層
	"
	| inputs |
	inputs := self previousLayer neurons collect: #output .
	
	self updateWeight: inputs 

]

{ #category : #accessing }
NeuronLayer >> updateWeight: initialInputs [
	"初期入力を元にニューロンの重みを更新する。
	 このメソッドは、メソッドを呼び出すメッセージのレシーバが
	 最初の隠れ層であることを前提としている。
	"
	| inputs |
	inputs := initialInputs .
	
	neurons do: [ :n |
		n adjustWeightWithInput: inputs .
		n adjustBias ].
	
	self nextLayer ifNotNil: [ self nextLayer updateWeight ]
]
