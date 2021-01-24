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

{ #category : #initialization }
NeuronLayer >> initializeNbOfNeurons: nbOfNeurons nbOfWights: nbOfWeights using: random [
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
NeuronLayer >> learningRate: aLearningRate [
	" 
	Set the learning rate for all neurons
  	Note that this method should be called after configuring the network,
 	and_not_before
	"
    self assert: [ neurons notEmpty] description: 'learningRate: should be invoked after configuring the layer'.
         
    neurons do: [ :n | n learningRate: aLearningRate]
]
