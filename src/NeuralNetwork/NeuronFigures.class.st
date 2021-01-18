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
