Class {
	#name : #PerceptronTest,
	#superclass : #TestCase,
	#category : #NeuralNetwork
}

{ #category : #'instance creation' }
PerceptronTest >> digitalComparator: inputs [
        " コンパレータ回路：要素数３の配列を返す。
       
                           真理値表
	       --- inputs -------+----- outputs ------------
	         A     B          A < B   A = B   A > B
	        (a)   (b)        (aLb)   (aEb)   (aGb)
           -----------------+---------------------------
	         0      0                 0      1       0
	         0      1                 1      0       0
	         1      0                 0      0       1
	         1      1                 0      1       0
          -------------------+--------------------------
        "
	| a b aLb aEb aGb not and nor notA notB |
        "引数inputs には A, Bを配列として渡す"
	a := inputs first.
	b := inputs second.
	"#(...)はNumber等リテラルを要素とする配列の生成に用いる、セパレータはスペース"

        "PerceptronTestでテストした論理ゲートオブジェクトを生成する"
	and := self newNeuron weights: #(1 1); bias: -1.5.
	not := self newNeuron weights: #(-1); bias: 0.5.
	nor := self newNeuron weights: #(-1 -1); bias: 0.5.
	notA := not feed: { a }.
	notB := not feed: { b }.
	
	"{...}は実行時に評価されるので式の結果を代入した変数を要素とする配列の生成に用いる、セパレータはピリオド"
        "回路図通りに論理ゲートを結びつける"
	aLb := and feed: { notA . b }.
	aGb := and feed: { a . notB }.
	aEb := nor feed: { aGb . aLb }.
	
	^ { aLb . aEb . aGb }
]

{ #category : #'instance creation' }
PerceptronTest >> newNeuron [
	"return a new neuron with the stepactivation function"
	^ Neuron new step
	
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
PerceptronTest >> testDigitalComparator [
        "真理値表をテストする"
	self assert: (self digitalComparator: #(0 0)) equals: #(0 1 0).
	self assert: (self digitalComparator: #(0 1)) equals: #(1 0 0).
	self assert: (self digitalComparator: #(1 0)) equals: #(0 0 1).
	self assert: (self digitalComparator: #(0 0)) equals: #(0 1 0)

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
PerceptronTest >> testTrainingNOT [
    | p |
    p := self newNeuron.
    p weights: #(-1).
    p bias: 2.
    
    40 timesRepeat: [
        p train: #(0) desiredOutput: 1.
        p train: #(1) desiredOutput: 0.
    ].

    self assert: (p feed: #(0)) equals: 1.
    self assert: (p feed: #(1)) equals: 0

]

{ #category : #'instance creation' }
PerceptronTest >> testTrainingOR [
    | p |
    p := self newNeuron.
    p weights: #(-1 -1).
    p bias: 2.

    40 timesRepeat: [
          p train: #(0 0 ) desiredOutput: 0.
          p train: #(0 1 ) desiredOutput: 1.
          p train: #(1 0 ) desiredOutput: 1.
          p train: #(1 1 ) desiredOutput: 1.
    ].

    self assert: (p feed: #(0 0)) equals: 0.
    self assert: (p feed: #(0 1)) equals: 1.
    self assert: (p feed: #(1 0)) equals: 1.
    self assert: (p feed: #(1 1)) equals: 1

]

{ #category : #'instance creation' }
PerceptronTest >> testWrongFeeding [
	| p |
	p := self newNeuron .
	p weights: #(-1).
	p bias: 0.5.
	
	self should: [ p feed: #(1 1) ] raise: Error 
	
]
