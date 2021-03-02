Class {
	#name : #NMNetwork,
	#superclass : #Object,
	#instVars : [
		'random',
		'errors',
		'layers'
	],
	#category : #'NeuralNetwork-Matrix'
}

{ #category : #initialization }
NMNetwork >> addLayer: aLayer [
	"ネットワークに層を加える。層は双方向に接続することに注意すること"
    
    layers ifNotEmpty: [
        layers last next: aLayer.
        aLayer previous: layers last
	].
    layers add: aLayer
]

{ #category : #initialization }
NMNetwork >> backwardX: x y: y [
	"エラーを計算し後方伝播する"
    
    | lastLayer dz currentLayer |
    lastLayer := layers last.
    dz := lastLayer output - y.
    lastLayer delta: dz.
    currentLayer := lastLayer previous.
    [ currentLayer notNil ] whileTrue: [
        dz := (currentLayer next w transposed +* dz)
        	multiplyPerElement: (currentLayer output collect: [ : v |
    			v * (1 - v)
    		]).
        currentLayer delta: dz.
        currentLayer := currentLayer previous.
	]
]

{ #category : #initialization }
NMNetwork >> computeCost: v1 and: v2 [
	"与えられた２つのベクトルのコスト関数を計算する"
    
    ^ ((v1 - v2) collect: [ :v | v * v]) sum
]

{ #category : #initialization }
NMNetwork >> configure: nbOfInputs hidden: nbOfNeurons1 
						hidden: nbOfNeurons2 nbOfOutPuts: nbOfOutputs [
	"与えれれたパラメータによりネットワークを設定する。ネットワークは2つの隠れ層を持つ"
    
	self addLayer: (NMLayer new nbInputs: nbOfInputs  nbOutputs: nbOfNeurons1 random: random).
    self addLayer: 
    	(NMLayer  new nbInputs: nbOfNeurons1 nbOutputs: nbOfNeurons2 random: random).
    self addLayer:
    	(NMLayer  new nbInputs: nbOfNeurons2 nbOutputs: nbOfOutputs random: random)
]

{ #category : #initialization }
NMNetwork >> configure: nbOfIputs hidden: nbOfNeurons nbOfOutputs: nbOfOutputs [
	"与えれれたパラメータによりネットワークを設定する。ネットワークは1つの隠れ層のみ持つ"
	
 	self addLayer: (NMLayer new nbInputs: nbOfIputs nbOutputs: nbOfNeurons random: random).   
    self addLayer: (NMLayer  new nbInputs: nbOfNeurons nbOutputs: nbOfOutputs random: random)
]

{ #category : #initialization }
NMNetwork >> feed: inputs [
	"引数で与えられたベクトルinputsをネットワークに供給する"
    
    | mat |
    mat := inputs.
    layers do: [ :l | mat := l feed: mat].
    ^ mat
]

{ #category : #initialization }
NMNetwork >> initialize [
	"層は持たずに乱数ジェネレータだけの状態でネットワークを初期化する"
	
	super initialize.
	layers := OrderedCollection new.
	random := Random seed: 42
]

{ #category : #initialization }
NMNetwork >> lr: aLearningRateAsFloat [
	"学習率をグローバルにセットする"
    
    layers do: [ :l | l lr: aLearningRateAsFloat]
]

{ #category : #initialization }
NMNetwork >> predict: inputs [
	" 予測を行う。このメソッドはネットワークの出力数と同じ出力数であることを想定している"
 	"Pharo ではコレクションの添字は1から始まる"
	| outputs |
	outputs := self feed: inputs.
	^ (outputs asArray indexOf: (outputs max)) - 1 
]

{ #category : #initialization }
NMNetwork >> train: data nbEpochs: nbEpochs [
	"データは配列のコレクションとして与えられる。
    サンプルデータは数値でラベル化されている必要がある"
    
    | x y labels numberOfOutputs |
    x := (MMatrix newFromArrays: (data collect: #allButLast)) transposed.
    layers do: [ :l | l numberOfExamples: data size].
    labels := data collect: #last.
    numberOfOutputs := labels asSet size.
    labels := labels collect: [ :row |
		| expectedOutput |
        expectedOutput := Array new: numberOfOutputs withAll: 0.
        expectedOutput at: row + 1 put: 1.
        expectedOutput
	].
    y := (MMatrix newFromArrays: labels) transposed.
    ^ self trainX: x y: y nbOfEpochs: nbEpochs
]

{ #category : #initialization }
NMNetwork >> trainX: x y: y nbOfEpochs: nbEpochs [
	"ネットワークを期待値に対する入力のセットで訓練する"
    | cost output |
    "各層にサンプル数を伝える"
    layers do: [ :l | l numberOfExamples: y nbColumns].
    errors := OrderedCollection new.
    nbEpochs timesRepeat: [
        output := self feed: x.
        cost := self computeCost: output and: y.
        self backwardX: x y: y.
        self update: x.
        errors add: cost.
	].
    ^ cost
]

{ #category : #initialization }
NMNetwork >> update: input [
	"重みとバイアスを引数input(ベクトル)で更新する"
    
    layers first update: input
]

{ #category : #initialization }
NMNetwork >> viewLearningCurve [ 
    | b ds |
    errors
        ifEmpty: [ ^ RTView new 
                add: (RTLabel elementOn: 'Should first run the network');
                yourself ].
    b := RTGrapher new.
    "We define the size of the charting area"
    b extent: 500 @ 300.
    ds := RTData new.
    ds samplingIfMoreThan: 2000.
    ds noDot.
    ds connectColor: Color blue.
    ds points: (errors collectWithIndex: [ :y :i | i -> y ]). 
    ds x: #key.
    ds y: #value.
    ds dotShape rectangle color: Color blue.
    b add: ds. 
    b axisX noDecimal; title: 'Epoch'.
    b axisY title: 'Error'.
    ^ b 

]

{ #category : #initialization }
NMNetwork >> viewLearningCurveIn: composite [
    <gtInspectorPresentationOrder: -10>
    composite roassal2
        title: 'Cost';
        initializeView: [ self viewLearningCurve ]

]
