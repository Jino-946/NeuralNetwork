Class {
	#name : #NeuronExamples,
	#superclass : #Object,
	#category : #NeuralNetwork
}

{ #category : #example }
NeuronExamples >> addingSeparationLine [
	" P28  Figure 1-12
	 赤い点と青い点の領域を分離する直線を加える。
	 	
	  NeuronExamples new addingSeparationLine
	"
	| somePoints f g d d2 |
	somePoints := OrderedCollection new.
	500 timesRepeat: [ 
		somePoints add: {(50 atRandom - 25) . (50 atRandom -25)}
 	].

	f := [ :x | (-2 * x) - 3 ].

	"We use the Roassal Grapher engine to plot our points"
	g := RTGrapher new.
	d := RTData new.
	d dotShape "Return the shape builder that is used to render a dot, i.e., a data point"
		color: [ :p | (p second > (f value: p first )) "p second -> i.e. p at:2"
					ifTrue:  [ Color red trans ] 
					ifFalse: [ Color blue trans ]].
	d points: somePoints.
	d x: #first.
	d y: #second.
	g add: d.
	
	"追加するコード"
	d2 := RTData new.
	d2 noDot.
	d2 connectColor: Color red.
	d2 points: (-15 to: 15 by: 0.1).
	d2 y: f.
	d2 x: #yourself.
	g add: d2.
	^g

]

{ #category : #example }
NeuronExamples >> classifyingDotsAlongLine [
	"   P26 Figure 1-11 
	 
		NeuronExamples new classifyingDotsAlongLine
	"
	| somePoints f g d |
	somePoints := OrderedCollection new.
	500 timesRepeat: [ 
		somePoints add: {(50 atRandom - 25) . (50 atRandom -25)}
 	].

	f := [ :x | (-2 * x) - 3 ].

	"We use the Roassal Grapher engine to plot our points"
	g := RTGrapher new.
	d := RTData new.
	d dotShape "Return the shape builder that is used to render a dot, i.e., a data point"
		color: [ :p | (p second > (f value: p first )) "p second -> i.e. p at:2"
					ifTrue:  [ Color red trans ] 
					ifFalse: [ Color blue trans ]].
	d points: somePoints.
	d x: #first.
	d y: #second.
	g add: d.
	^ g
]

{ #category : #example }
NeuronExamples >> predictingTheColorOfTheDot [
	" P30 Figure1-13
	
	  NeuronExamples new predictingTheColorOfTheDot
	"
	|f p r anX anY designedOutput testPoints g d d2 |
	f := [ :x| (-2 * x) -3 ].
	p := Neuron new.
	p weights: { 1 . 2 }.
	p bias: -1.
	r := Random new seed: 42.

	"We are training the perceptron"
	500 timesRepeat: [ 
		anX := (r nextInt: 50) - 25.
		anY := (r nextInt: 50) - 25.
		designedOutput := (f value: anX) >= anY
								ifTrue: [ 1 ] ifFalse: [ 0 ].
		p train: { anX . anY } desiredOutput: designedOutput
	].

	"Test points "
	testPoints := OrderedCollection new.
	2000 timesRepeat: [ 
		testPoints add: { ((r nextInt: 50) - 25) . ((r nextInt: 50) - 25)}	
	].

	g := RTGrapher new.
	d := RTData new.
	d dotShape 
		color: [ :point| (p feed: point) > 0.5
						ifTrue: [Color red trans]
						ifFalse: [ Color blue trans ]].
	d points: testPoints .
	d x: #first.
	d y: #second.
	g add: d.

	d2 := RTData new.
	d2 noDot.
	d2 connectColor: Color red.
	d2 points: (-15 to: 15 by: 0.1).
	d2 y: f.
	d2 x: #yourself.
	g add:d2.
	
	^g
]
