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
NMNetwork >> backWardX: x y: y [
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
NMNetwork >> configure: nbOfIputs hidden: nbOfNeurons nbOfOutputs: nbOfOutputs [
	"与えれれたパラメータによりネットワークを設定する。ネットワークは1つの隠れ層のみ持つ"
    
    self addLayer: (NMLayer  new nbInputs: nbOfNeurons nbOutputs: nbOfOutputs random: random)
]

{ #category : #initialization }
NMNetwork >> initialize [
	"層は持たずに乱数ジェネレータだけの状態でネットワークを初期化する"
	
	super initialize.
	layers := OrderedCollection new.
	random := Random seed: 42
]
