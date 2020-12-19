Class {
	#name : #PerceptronTest,
	#superclass : #TestCase,
	#category : #NeuralNetwork
}

{ #category : #'instance creation' }
PerceptronTest >> newNeuron [
	"return a new neuron."
	^ Neuron new 
	
]

{ #category : #'instance creation' }
PerceptronTest >> testAND [
	"
                  真理値表
	       --------------------------
		     A     B      A AND B
	      --------------------------
	        0     0          0
	        0     1          0
	        1     0          0
	        1     1          1
	     -------------------------
	
	"

	| p |
	p := self newNeuron .
	p weights: #(1 1).
	p bias: -1.5.
	
       "真理値表をカバーできた"
	self assert: (p feed: #(0 0)) equals: 0.
	self assert: (p feed: #(0 1)) equals: 0.
	self assert: (p feed: #(1 0)) equals: 0.
	self assert: (p feed: #(1 1)) equals: 1

]

{ #category : #'instance creation' }
PerceptronTest >> testNOR [
	"
                  真理値表
	       ----------------------
		     A     B      A NOR B
	      -----------------------
	        0     0          1
	        0     1          0
	        1     0          0
	        1     1          0
	     -----------------------
	
	"

	| p |
	p := self newNeuron .
	p weights: #(-1 -1).
	p bias: 0.5.
	
       "真理値表をカバーできた"
	self assert: (p feed: #(0 0)) equals: 1.
	self assert: (p feed: #(0 1)) equals: 0.
	self assert: (p feed: #(1 0)) equals: 0.
	self assert: (p feed: #(1 1)) equals: 0

]

{ #category : #'instance creation' }
PerceptronTest >> testNOT [
	"
         -------------------
             真理値表
	     -------------------
		  A         NOT A   
	     -------------------
	      0           1
	      1           0
	    -------------------
	"

	| p |
	p := self newNeuron .
	p weights: #(-1).
	p bias: 0.5.
	
        "真理値表をカバーできた"
	self assert: (p feed: #(1)) equals: 0.
	self assert: (p feed: #(0)) equals: 1.

]

{ #category : #'instance creation' }
PerceptronTest >> testOR [
	"
                  真理値表
	       ----------------------
		     A     B      A OR B
	      -----------------------
	        0     0          0
	        0     1          1
	        1     0          1
	        1     1          1
	     -----------------------
	
	"

	| p |
	p := self newNeuron .
	p weights: #(1 1).
	p bias: -0.5.
	
       "真理値表をカバーできた"
	self assert: (p feed: #(0 0)) equals: 0.
	self assert: (p feed: #(0 1)) equals: 1.
	self assert: (p feed: #(1 0)) equals: 1.
	self assert: (p feed: #(1 1)) equals: 1

]

{ #category : #'instance creation' }
PerceptronTest >> testSmallExample [
	|p result|
	p := self newNeuron .
	p weights: #(1 2).
	p bias: -2.
	result := p feed: #(5 2).
	self assert: result equals: 1.
	
	result := p feed: #(-2 2).
	self assert: result equals: 0
]

{ #category : #'instance creation' }
PerceptronTest >> testWrongFeeding [
	| p |
	p := self newNeuron .
	p weights: #(-1).
	p bias: 0.5.
	
	self should: [ p feed: #(1 1) ] raise: Error 
	
]
