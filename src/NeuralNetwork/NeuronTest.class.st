Class {
	#name : #NeuronTest,
	#superclass : #TestCase,
	#category : #NeuralNetwork
}

{ #category : #tests }
NeuronTest >> testTrainingAND [
	| p |
	p := Neuron  new .
	p weights: #(-1 -1).
	p bias: 2.
	
	6000 timesRepeat: [ 
			p train: #(0 0) desiredOutput: 0.
			p train: #(0 1) desiredOutput: 0.
			p train: #(1 0) desiredOutput: 0.
			p train: #(1 1) desiredOutput: 1.			
		 ].
	
    "真理値表をカバーできた"
	self assert: ((p feed: #(0 0)) closeTo: 0 precision: 0.1).
	self assert: ((p feed: #(0 1)) closeTo: 0 precision: 0.1).
	self assert: ((p feed: #(1 0)) closeTo: 0 precision: 0.1).
	self assert: ((p feed: #(1 1)) closeTo: 1 precision: 0.1)
	
	

]

{ #category : #tests }
NeuronTest >> testTrainingOR [
	"
                  真理値表
	       --------------------------
		     A     B      A AND B
	      --------------------------
	        0     0          0
	        0     1          1
	        1     0          1
	        1     1          1
	     -------------------------
	
	"

	| p |
	p := Neuron  new .
	p weights: #(-1 -1).
	p bias: 2.
	
	10000 timesRepeat: [ 
			p train: #(0 0) desiredOutput: 0.
			p train: #(0 1) desiredOutput: 1.
			p train: #(1 0) desiredOutput: 1.
			p train: #(1 1) desiredOutput: 1.			
		 ].
	
    "真理値表をカバーできた"
	self assert: ((p feed: #(0 0)) closeTo: 0 precision: 0.1).
	self assert: ((p feed: #(0 1)) closeTo: 1 precision: 0.1).
	self assert: ((p feed: #(1 0)) closeTo: 1 precision: 0.1).
	self assert: ((p feed: #(1 1)) closeTo: 1 precision: 0.1)
	
	

]
