Class {
	#name : #NeuralNetwork,
	#superclass : #Object,
	#instVars : [
		'layers',
		'errors',
		'precisions'
	],
	#category : #NeuralNetwork
}

{ #category : #initialization }
NeuralNetwork >> addLayer: aNeuronLayer [
	" ニューロン層を追加する。追加される層はすでに存在している層にリンクされる。"
	layers ifNotEmpty: [ 
			aNeuronLayer previousLayer: layers last .
			layers last nextLayer: aNeuronLayer ] .
	
	layers add: aNeuronLayer 
]

{ #category : #initialization }
NeuralNetwork >> backwardPropagateError: expectedOutputs [
	"expectedOutputsはトレーニングしているネットワークからの出力に対応している"
	 self outputLayer backwardPropagateError: expectedOutputs 
]

{ #category : #initialization }
NeuralNetwork >> configure: nbOfInputs hidden: nbOfNeurons1 hidden: nbOfNeurons2 hidden: nbOfNeurons3 nbOfOutputs: nbOfOutput [
	"与えられた引数でネットワークを構成する。
	 ネットワークは3層の隠れ層を持つ"
	| random |
	random := Random seed: 42 .
	self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons1  nbOfWeights: nbOfInputs   using: random).
	self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons2  nbOfWeights: nbOfNeurons1  using: random).
	self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons3  nbOfWeights: nbOfNeurons2  using: random).
	self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfOutput   nbOfWeights: nbOfNeurons3  using: random).
	
]

{ #category : #initialization }
NeuralNetwork >> configure: nbOfInputs hidden: nbOfNeurons1 hidden: nbOfNeurons2  nbOfOutputs: nbOfOutput [
	"与えられた引数でネットワークを構成する。
	 ネットワークは2層の隠れ層を持つ"
	| random |
	random := Random seed: 42 .
	self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons1  nbOfWeights: nbOfInputs   using: random).
	self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons2  nbOfWeights: nbOfNeurons1  using: random).
	self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfOutput   nbOfWeights: nbOfNeurons2  using: random).
	
]

{ #category : #initialization }
NeuralNetwork >> configure: nbOfInputs hidden: nbOfNeurons nbOfOutputs: nbOfOutput [
	"与えられた引数でネットワークを構成する。
	 ネットワークの隠れ層は1つのみ"
	| random |
	random := Random seed: 42 .
	self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfNeurons  nbOfWeights: nbOfInputs   using: random).
	self addLayer: (NeuronLayer new initializeNbOfNeurons: nbOfOutput   nbOfWeights: nbOfNeurons  using: random).
	
]

{ #category : #initialization }
NeuralNetwork >> feed: someInputValues [
	"与えられた入力を最初の層へ供給する"
	^ layers first feed: someInputValues 
]

{ #category : #initialization }
NeuralNetwork >> initialize [ 
	super initialize .
	layers := OrderedCollection new .
	errors := OrderedCollection new .
	precisions := OrderedCollection new 
	
]

{ #category : #initialization }
NeuralNetwork >> learningRate: aLearningRate [
	" 各層の学習レートを設定する"
	 layers do: [ :l | l learningRate: aLearningRate  ]	
]

{ #category : #initialization }
NeuralNetwork >> numberOfInputs [
	"Return the number of inputs the network has"
	^ layers first neurons size
]

{ #category : #initialization }
NeuralNetwork >> numberOfNeurons [
	"Return the number of neurons the network has"
	^ (layers collect: #numberOfNeurons ) sum 
]

{ #category : #initialization }
NeuralNetwork >> numberOfOutputs [
	" ネットワークの出力数を返す"
	^ layers last numberOfNeurons 
]

{ #category : #initialization }
NeuralNetwork >> outputLayer [
	"出力層を返す、ようするに最終層"
	^ layers last
]

{ #category : #initialization }
NeuralNetwork >> predict: inputs [
	" 予測を行う。このメソッドはネットワークの出力数と同じ出力数であることを想定している"
 	"Pharo ではコレクションの添字は1から始まる"
	| outputs |
	outputs := self feed: inputs.
	^ (outputs  indexOf: (outputs max)) - 1 
]

{ #category : #initialization }
NeuralNetwork >> train: someInputs desiredOutputs: desiredOutputs [
	"ニューラルネットワークを入力値と期待する出力でトレーニングする"
	self feed: someInputs .
	self backwardPropagateError: desiredOutputs .
	self updateWeight: someInputs 
]

{ #category : #initialization }
NeuralNetwork >> train: train nbEpochs: nbEpochs [
	"訓練用のデータセットを用いネットワークを訓練する"
	| sumError outputs expectedOutput epochPrecision t n |
	1 to: nbEpochs do: [ :epoch |
		sumError := 0.
		epochPrecision := 0.
		train do: [ :row |
			outputs := self feed: row allButLast .
			expectedOutput := (1 to: self numberOfOutputs) collect: [ :notUsed | 0 ].
			n := row last.
			expectedOutput at: n + 1 put: 1.
			(row last = (self predict: row allButLast))
				ifTrue: [ epochPrecision := epochPrecision  + 1 ].
			t := (1 to: expectedOutput size) collect: [ :i |
				((expectedOutput  at: i) - (outputs at: i )) squared
			]. 
			sumError := sumError + t sum.
			self backwardPropagateError: expectedOutput .
			self updateWeight: row allButLast .
		].
		errors  add: sumError .
		precisions add: (epochPrecision  / train size) asFloat.
	]
   
]

{ #category : #initialization }
NeuralNetwork >> updateWeight: initialInputs [
	"初期の入力値を用いニューロンの重みを更新する"
	layers first updateWeight: initialInputs 
]

{ #category : #initialization }
NeuralNetwork >> viewLearningCurve [
	"エラー曲線と精度曲線を描く"
	| b ds |
	"ネットワークが実行されていない時は描く物はない"
	errors ifEmpty: [  ^RTView new 
		add: (RTLabel elementOn: 'ネットワークを実行して下さい。');
		yourself 
	].

	b := RTDoubleGrapher new.
	"グラフ描画領域のサイズを定義する"
	b extent: 500 @ 300.
	ds := RTData new.
	"Roassal が提供する簡単な最適化"
	ds samplingIfMoreThan: 2000.
	"点は不要、曲線だけで良い"
	ds noDot; connectColor: Color blue.
	ds points: (errors collectWithIndex: [ :y :i | i -> y]).
	ds x: #key.
	ds y: #value.
	ds dotShape rectangle color: Color blue.
	b add: ds.
	
	ds := RTData new.
	ds samplingIfMoreThan: 2000.
	ds noDot.
	ds connectColor: Color red.
	ds points: (precisions collectWithIndex: [ :y :i | i -> y]).
	ds x: #key.
	ds y: #value.
	ds dotShape rectangle color: Color blue .
	b addRight: ds.
	b axisX noDecimal ; title: 'エポック'.
	b axisY title: 'エラー'; color: Color blue.
	b axisYRight title: '精度'; color: Color red.
	^ b
]

{ #category : #initialization }
NeuralNetwork >> viewLearningCurveIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2 
		title: 'Learning';
		initializeView: [ self viewLearningCurve ]
]

{ #category : #initialization }
NeuralNetwork >> viewNetwork [
	| b lb |
	b := RTMondrian new.
	b nodes: layers forEach: [ :aLayer |
 		b shape circle size: 20.
		b nodes: aLayer neurons .
		b layout verticalLine .	
	].

	b shape arrowedLine ; withShorterDistanceAttachPoint .
	b edges connectTo: #nextLayer.
	b layout horizontalLine gapSize: 30; center .
	
	b build.
	
	lb := RTLegendBuilder new.
	lb view: b view.
	lb addText: self numberOfNeurons asString, ' neurons'.
	lb addText: self numberOfInputs asString, ' inputs'.
	lb build.
	^ b view 
]

{ #category : #initialization }
NeuralNetwork >> viewNetworkIn: composite [
	<gtInspectorPresentationOrder: -5>
	composite roassal2 
		title: 'Network';
		initializeView: [ self viewNetwork ]
]
