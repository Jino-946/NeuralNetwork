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
NeuralNetwork >> numberOfOutputs [
	" ネットワークの出力数を返す"
	^ layers last numberOfNeurons 
]
