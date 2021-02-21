"
- Figureを作成するスクリプトをメソッドにする
- ""Agile Artificial Intelligence In Pharo"" のFigureグラフを作成するスクリプトを管理するためのクラス

"
Class {
	#name : #NeuronFigures,
	#superclass : #Object,
	#category : #NeuralNetwork
}

{ #category : #example }
NeuronFigures >> figure1_11 [
	"   P26 Figure 1-11 
	 
		NeuronFigures new figure1_11
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
	d points: somePoints. "somePoints は2つの整数を要素とする配列のコレクション"
	d x: #first.           "x: #first は配列の第一要素をxとするRTDataのイディオムと解釈しておこう"
	d y: #second.          "であるからしてsecondのレシーバは個々の点を表す２つの整数を要素とする配列"
	g add: d.
	^ g
]

{ #category : #example }
NeuronFigures >> figure1_12 [
	" P28  Figure 1-12
	 赤い点と青い点の領域を分離する直線を加える。
	 	
	  NeuronFigures new figure1_12
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
	d points: somePoints. "somePoints は2つの整数を要素とする配列のコレクション"
	d x: #first.          "x: #first は配列の第一要素をxとするRTDataのイディオムと解釈しておこう"
	d y: #second.          "であるからしてsecondのレシーバは個々の点を表す２つの整数を要素とする配列"
	g add: d.
	
	"y=-2x - 3グラフ描画のため追加するコード"
	d2 := RTData new.
	d2 noDot.
	d2 connectColor: Color red.
	d2 points: (-15 to: 15 by: 0.1). "points:の引数にはx座標を表すインターバルも指定可能の様だ"
	d2 x: #yourself.           "xはインターバルの各要素"
	d2 y: f.                   "yはxに関数fを適用した結果"
	g add: d2.
	^g

]

{ #category : #example }
NeuronFigures >> figure1_13 [
	" P30 Figure1-13
	  点の色を予測する
		
	  NeuronFigures new figure1_13
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
		color: [ :point| (p feed: point) > 0.5   "p feed: point は1または0を返すので (p feed: point) = 1 に等しい"
						ifTrue: [Color red trans]
						ifFalse: [ Color blue trans ]].
	d points: testPoints .  "testPoints は2つの整数を要素とする配列のコレクション"
	d x: #first.            "x: #first は配列の第一要素をxとするRTDataのイディオムと解釈しておこう"
	d y: #second.           "であるからしてsecondのレシーバは個々の点を表す２つの整数を要素とする配列"
	g add: d.

	d2 := RTData new.
	d2 noDot.
	d2 connectColor: Color red.
	d2 points: (-15 to: 15 by: 0.1). "points:の引数にはx座標を表すインターバルも指定可能の様だ"
	d2 x: #yourself.    "xはインターバルの各要素"
	d2 y: f.            "yはxに関数fを適用した結果"
	g add:d2.
	
	^g
]

{ #category : #example }
NeuronFigures >> figure1_14 [
	"P32  Figure 1-14
	 点の分類精度
	
	 NeuronFigures new figure1_14
	"
	| learningCurve f r p anX anY traindOutput nbOfGood nbOfTries realOutput g d |
	learningCurve := OrderedCollection new.
	f := [ :x| (-2 * x) - 3 ].
	0 to: 2000 by: 10 do: [ :nbOfTrained|
		r := Random new seed: 42.
		p := Neuron new.
		p weights: #(1 2).
		p bias: -1.
		
		nbOfTrained timesRepeat: [ 
			anX := (r nextInt: 50) - 25.
			anY := (r nextInt: 50) - 25.
			traindOutput := (f value: anX) >= anY ifTrue: [1] ifFalse: [0].
			p train: (Array with: anX with: anY) desiredOutput: traindOutput ].
		
		nbOfGood := 0.
		nbOfTries := 1000.
		nbOfTries timesRepeat: [ 
			anX := (r nextInt: 50) - 25.
			anY := (r nextInt: 50) - 25.
			realOutput := (f value: anX) >= anY ifTrue: [1] ifFalse: [0].
			((p feed: {anX . anY}) - realOutput) abs < 0.2
			"比較2項メッセージの左項は0または1を返すので左項が0の時真を意味する"
				ifTrue:[nbOfGood := nbOfGood + 1].				
			 ].
		learningCurve add: { nbOfTrained . (nbOfGood / nbOfTries ) }.
	].

	g := RTGrapher new.
	d := RTData new.
	d noDot .
	d connectColor: Color blue.
	d points: learningCurve.
	d x: #first.
	d y: #second.
	g add: d.
	g axisY title: 'Precision'.
	g axisX noDecimal ; title: 'Training iteration'.
	^g

]

{ #category : #example }
NeuronFigures >> figure2_1 [
	"P39  Figure 2-1
	 ステップ関数 
	
	 NeuronFigures new figure2_1
	"
	| g d |
	g := RTGrapher new.
	d := RTData new.
	d connectColor: Color blue.
	d noDot.
	d points: (-7.0 to: 7.0 by: 0.01).
	d x: #yourself .
	d y: [ :x | x > 0 ifTrue: [ 1 ] ifFalse: [ 0 ] ].
	g add: d.
	^ g
	
]

{ #category : #example }
NeuronFigures >> figure2_2 [
	"P40  Figure 2-2
	 シグモイド関数 
	
	 NeuronFigures new figure2_2
	"
	| g d |
	g := RTGrapher new.
	d := RTData new.
	d connectColor: Color blue.
	d noDot.
	d points: (-7.0 to: 7.0 by: 0.01).
	d x: #yourself .
	d y:  [ :x | 1 / (1 + (x negated exp)) ].
	g add: d.
	^ g
	
]

{ #category : #example }
NeuronFigures >> figure2_3 [
	"P50  Figure 2-3
	 シグモイド関数 vs パーセプトロン
	
	 NeuronFigures new figure2_3
	"
	| learningCurveNeuron learningCurvePerceptron p res g d |
	learningCurveNeuron := OrderedCollection new.
	0 to: 1000 do: [ :nbOfTrained |
		p := Neuron new.
		p weights: #(-1 -1).
		p bias: 2.
		
		nbOfTrained timesRepeat: [ 
			p train: #(0 0) desiredOutput: 0.
			p train: #(0 1) desiredOutput: 0.
			p train: #(1 0) desiredOutput: 0.
			p train: #(1 1) desiredOutput: 1.		
		].
	
		res := ((p feed: #(0 0)) - 0) abs +
			   ((p feed: #(0 1)) - 0) abs +
			   ((p feed: #(1 0)) - 0) abs +
			   ((p feed: #(1 1)) - 1) abs.
		learningCurveNeuron add: res / 4.
 	].

	learningCurvePerceptron  := OrderedCollection new.
	0 to: 1000 do: [ :nbOfTrained |
		p := Neuron new.
		p step.
		p weights: #(-1 -1).
		p bias: 2.
		
		nbOfTrained timesRepeat: [ 
			p train: #(0 0) desiredOutput: 0.
			p train: #(0 1) desiredOutput: 0.
			p train: #(1 0) desiredOutput: 0.
			p train: #(1 1) desiredOutput: 1.		
		].
	
		res := ((p feed: #(0 0)) - 0) abs +
			   ((p feed: #(0 1)) - 0) abs +
			   ((p feed: #(1 0)) - 0) abs +
			   ((p feed: #(1 1)) - 1) abs.
			
		learningCurvePerceptron  add: res / 4.
 	].

	g := RTGrapher new.
	d := RTData new.
	d label: 'Sigmoid neuron'.
	d noDot.
	d connectColor: Color blue.
	d points: learningCurveNeuron .
	d y: #yourself .
	g add: d.

	d := RTData new.
	d label: 'Perceptron '.
	d noDot.
	d connectColor: Color green.
	d points: learningCurvePerceptron  .
	d y: #yourself .
	g add: d.
	
	g axisY title: 'Error'.
	g axisX noDecimal ; title: 'Epoch'.
	g legend addText: 'Perceptron vs Sigmoid neuron'.
	
	^g 
]

{ #category : #example }
NeuronFigures >> figure4_1 [
	"P70  Figure 4-1
	 Plotting four points
	
	 NeuronFigures new figure4_1
	"
	| points g d |
	points := { (1 @ 3.0). (3 @ 5.2). (2 @ 4.1). (4 @ 7.5) }.
	g := RTGrapher new.
	d := RTData new.
	d dotShape color: Color red.
	d points: points .
	d x: #x; y: #y.
	g add: d.
	^g
	
]

{ #category : #example }
NeuronFigures >> figure4_2 [
	"P71  Figure 4-2
	 Points and a line
	
	 NeuronFigures new figure4_2
	"
	|a b f points g d |
	points := { (1 @ 3.0). (3 @ 5.2). (2 @ 4.1). (4 @ 7.5) }.
	
	a := 2.
	b := -0.5.
	f := [ :x | a * x + b ].
	
	g := RTGrapher new.
	d := RTData new.
	d dotShape color: Color red.
	d points: points .
	d x: #x; y: #y.
	g add: d.
	
	d := RTData new.
	d noDot ; connectColor: Color blue.
	d points: (0 to: 5).
	d x: #yourself.
	d y: f.
	g add: d.
	^g
	
]

{ #category : #example }
NeuronFigures >> figure4_3 [
	"P71  Figure 4-3
	 Gradient descent(勾配降下)
	
	 NeuronFigures new figure4_3
	"
	|a b f points learningRate deriMSEa deriMSEb g d |
	points := { (1 @ 3.0). (3 @ 5.2). (2 @ 4.1). (4 @ 7.5) }.
	
	a := 0.5.
	b := 3.
	f := [ :x | a * x + b ].
	learningRate := 0.01.
	1000 timesRepeat: [ 
		deriMSEa := (2 / points size) * (points collect: [ :aPoint | 
			aPoint x * (aPoint y - (f value: aPoint x)) negated ]) sum.
		deriMSEb := (2 / points size) * (points collect: [ :aPoint |
			1 * ( aPoint y - (f value: aPoint x)) negated ]) sum.
		a := a - (learningRate * deriMSEa).
		b := b - (learningRate * deriMSEb).
	].
	
	
	Transcript cr; show: 'a -> '; show: a.
	Transcript cr; show: 'b -> '; show: b.
	
	g := RTGrapher new.
	d := RTData new.
	d dotShape color: Color red.
	d points: points .
	d x: #x; y: #y.
	g add: d.
	
	d := RTData new.
	d noDot ; connectColor: Color blue.
	d points: (0 to: 5).
	d x: #yourself.
	d y: f.
	g add: d.
	^g
	
]

{ #category : #example }
NeuronFigures >> figure4_4 [
	"P78  Figure 4-4
	 Variation of the MSE cost function
	
	 NeuronFigures new figure4_4
	"
	|a b f points learningRate deriMSEa deriMSEb result mse g d |
	points := { (1 @ 3.0). (3 @ 5.2). (2 @ 4.1). (4 @ 7.5) }.
	
	a := 0.5.
	b := 3.
	f := [ :x | a * x + b ].
	learningRate := 0.01.
	
	result := OrderedCollection new.
	1000 timesRepeat: [ 
		deriMSEa := (2 / points size) * (points collect: [ :aPoint | 
			aPoint x * (aPoint y - (f value: aPoint x)) negated ]) sum.
		deriMSEb := (2 / points size) * (points collect: [ :aPoint |
			1 * ( aPoint y - (f value: aPoint x)) negated ]) sum.
		a := a - (learningRate * deriMSEa).
		b := b - (learningRate * deriMSEb).
		mse := (points collect: [ :aPoint | (aPoint y - (f value: aPoint x)) squared ]) sum / points size.
		result add: mse.
	].
	
	
	g := RTGrapher new.
	d := RTData new.
	d noDot; connectColor: Color blue.
	d points: result  .
	d y: #yourself.
	g add: d.
	^g
	
]

{ #category : #example }
NeuronFigures >> figure4_5 [
	"P81  Figure 4-5
	 
	 Approximating a line passing by 100 points
	 NeuronFigures new figure4_4
	"
	|nbOfPoints r a b f points learningRate deriMSEa deriMSEb result mse g d |
  	nbOfPoints := 100.
	r := Random seed: 42.
	
	points := (1 to: nbOfPoints ) collect: [ :i |
		(i / nbOfPoints) asFloat @ ((r next * 40 - 20 + i) / nbOfPoints) asFloat ].
	
	a := 0.5.
	b := 3.
	f := [ :x | a * x + b ].
	learningRate := 0.01.
	
	result := OrderedCollection new.
	1000 timesRepeat: [ 
		deriMSEa := (2 / points size) * (points collect: [ :aPoint | 
			aPoint x * (aPoint y - (f value: aPoint x)) negated ]) sum.
		deriMSEb := (2 / points size) * (points collect: [ :aPoint |
			1 * ( aPoint y - (f value: aPoint x)) negated ]) sum.
		a := a - (learningRate * deriMSEa).
		b := b - (learningRate * deriMSEb).
		mse := (points collect: [ :aPoint | 
			(aPoint y - (f value: aPoint x)) squared ]) sum / points size.
		result add: mse.
	].
	
	
	g := RTGrapher new.
	d := RTData new.
	d noDot; connectColor: Color blue.
	d points: result  .
	d y: #yourself.
	g add: d.
	^g
	
]

{ #category : #example }
NeuronFigures >> figure4_6 [
	"P82  Figure 4-6
	 
	 Approximating a line passing by 100 points
	 NeuronFigures new figure4_6
	"
	|nbOfPoints r a b f points learningRate deriMSEa deriMSEb result mse g d d2 |
	nbOfPoints := 100.
	r := Random seed: 42.
	
	points := (1 to: nbOfPoints ) collect: [ :i |
		(i / nbOfPoints) asFloat @ ((r next * 40 - 20 + i) / nbOfPoints) asFloat ].
	
	a := 0.5.
	b := 3.
	f := [ :x | a * x + b ].
	learningRate := 0.01.
	
	result := OrderedCollection new.
	5000 timesRepeat: [ 
		deriMSEa := (2 / points size) * (points collect: [ :aPoint | 
			aPoint x * (aPoint y - (f value: aPoint x)) negated ]) sum.
		deriMSEb := (2 / points size) * (points collect: [ :aPoint |
			1 * ( aPoint y - (f value: aPoint x)) negated ]) sum.
		a := a - (learningRate * deriMSEa).
		b := b - (learningRate * deriMSEb).
		mse := (points collect: [ :aPoint | 
			(aPoint y - (f value: aPoint x)) squared ]) sum / points size.
		result add: mse.
	].
	
	g := RTGrapher new.
	d := RTData new.
	d dotShape color: Color red.
	d points: points.
	d y: #y.
	d x: #x.
	g add: d.
	
	
	d2 := RTData new.
	d2 noDot; connectColor: Color blue.
	d2 points: (0 to: 1.0 by: 0.01).
	d2 x: #yourself.
	d2 y: f.
	g add: d2.
	
	^ g
	
]

{ #category : #example }
NeuronFigures >> figure4_7 [
	"P84  Figure 4-7
	 
	 Result of the stochastic gradient descent
	 
	 NeuronFigures new figure4_7
	"
	|nbOfPoints r a b f points learningRate deriMSEa deriMSEb result mse g d 
	 currentBatch miniBatches batchSize accumulatedMse|
	nbOfPoints := 100.
	r := Random seed: 42.
	
	points := (1 to: nbOfPoints ) collect: [ :i |
		(i / nbOfPoints) asFloat @ ((r next * 40 - 20 + i) / nbOfPoints) asFloat ].
	currentBatch := OrderedCollection new.
	miniBatches := OrderedCollection new.
	batchSize := 5.
	1 to: points size do:  [ :index |
		currentBatch add: (points at: index).
		index \\ batchSize  = 0
			ifTrue: [  miniBatches add: currentBatch copy.
						currentBatch := OrderedCollection new. ]].
	miniBatches .
	
	a := 0.5.
	b := 3.
	f := [ :x | a * x + b ].
	learningRate := 0.01.
	
	result := OrderedCollection new.
	5000 timesRepeat: [
		accumulatedMse := 0.
		miniBatches do: [ :pointsBatch |  
			deriMSEa := (2 / pointsBatch size) * (pointsBatch collect: [ :aPoint | 
				aPoint x * (aPoint y - (f value: aPoint x)) negated ]) sum.
			deriMSEb := (2 / pointsBatch size) * (pointsBatch collect: [ :aPoint |
				1 * ( aPoint y - (f value: aPoint x)) negated ]) sum.
			a := a - (learningRate * deriMSEa).
			b := b - (learningRate * deriMSEb).
			mse := (pointsBatch collect: [ :aPoint | 
				(aPoint y - (f value: aPoint x)) squared ]) sum / points size.
			accumulatedMse := accumulatedMse + mse.
		].
		result add: accumulatedMse 
	].
	
	g := RTGrapher new.
	d := RTData new.
	d noDot; connectColor: Color blue.
	d points: result.
	d y: #yourself.
	g add: d.	
	^ g
	
]

{ #category : #example }
NeuronFigures >> figure5_5 [
	"P104  Figure 5-5
		 
	 NeuronFigures new figure5_5
	"

	| g learningCurveNeuron r p res d |
	g := RTGrapher new.
	#(0.001 0.01 0.1 0.2 0.3) doWithIndex: [ :lr :index |
		learningCurveNeuron := OrderedCollection new.
		0 to: 1000 do: [ :nbOfTrained |
			r := Random new seed: 42.
			p := Neuron new.
			p weights: #(-1 -1).
			p bias: 2.
			p learningRate: lr.
			nbOfTrained timesRepeat: [ p train: #(0 0) desiredOutput: 0.
										p train: #(0 1) desiredOutput: 0.
										p train: #(1 0) desiredOutput:  0.
										p train: #(1 1) desiredOutput: 1 ].
			res := ((p feed: #(0 0)) - 0) abs + ((p feed: #(0 1)) - 0) abs +
					((p feed: #(1 0)) - 0) abs + ((p feed: #(1 1)) - 1) abs.
			learningCurveNeuron add: res / 4
		].
		d := RTData new.
		d label: 'Sigmoid neuron lr = ', lr asString.
		d noDot.
		d connectColor: (RTPalette c3 at: index).
		d points: learningCurveNeuron.
		d y: #yourself.
		g add: d
	].
	g legend addText: 'Learning rate(lr) effect'.
	^g
]
