Class {
	#name : #NMLayer,
	#superclass : #Object,
	#instVars : [
		'w',
		'b',
		'delta',
		'output',
		'previous',
		'next',
		'lr',
		'numberOfExamples'
	],
	#category : #'NeuralNetwork-Matrix'
}

{ #category : #initialization }
NMLayer >> b [
	"バイアスベクトルを返す"
    
    ^b
]

{ #category : #initialization }
NMLayer >> b: biasVector [
	"ベクトルを -MMatrixのインスタンス- バイアスベクトルにセットする"

	b := biasVector
]

{ #category : #initialization }
NMLayer >> delta [

	^delta
]

{ #category : #initialization }
NMLayer >> delta: deltaMatrix [

	delta := deltaMatrix
]

{ #category : #initialization }
NMLayer >> feed: inputMatrix [
	"入力マトリックスと共に層を送出する"
    
    output := (w +* inputMatrix + b) collect: [ :v | 1 / (1 + v negated exp)].
    ^ output
]

{ #category : #initialization }
NMLayer >> initialize [ 

	super initialize.
	lr := 0.1
]

{ #category : #initialization }
NMLayer >> lr: learningRate [

	lr := learningRate
]

{ #category : #initialization }
NMLayer >> nbInputs: nbOfInputs nbOutputs: nbOfOutputs random: random [
	"層を初期化する"
    
    w := MMatrix newRows: nbOfOutputs columns: nbOfInputs.
    w random: random.
    b := MMatrix newRows: nbOfOutputs columns: 1.
    b random: random

]

{ #category : #initialization }
NMLayer >> next [
	"次の層を返す"
	
	^next
]

{ #category : #initialization }
NMLayer >> next: aLayer [
	"次の層をセットする"
    
    next := aLayer
]

{ #category : #initialization }
NMLayer >> numberOfExamples [
	
    ^ numberOfExamples
]

{ #category : #initialization }
NMLayer >> numberOfExamples: aNumber [
	
    numberOfExamples := aNumber
]

{ #category : #initialization }
NMLayer >> output [
	"前方送出フェーズを通して計算された出力マトリックスを返す"
    
    ^output
]

{ #category : #initialization }
NMLayer >> previous [
	"前の層を返す"
    
    ^previous
]

{ #category : #initialization }
NMLayer >> previous: aLayer [
	"前の層をセットする"
    
    previous := aLayer
]

{ #category : #initialization }
NMLayer >> update [
	"デルタ値を使って重みとバイアスを更新する"
    
    w := w - ((delta * previous output transposed) * lr / numberOfExamples).
    b := b - (delta sumHorizontal * lr / numberOfExamples).
    next ifNotNil: [ next update]
]

{ #category : #initialization }
NMLayer >> update: input [
	"入力値を使って重みとバイアスを更新する"
    
    w := w - ((delta * input transposed) * lr / numberOfExamples).
    b := b - (delta sumHorizontal * lr / numberOfExamples).
    next update
]

{ #category : #initialization }
NMLayer >> w [
	"重みを表現するMMatrixを返す"
    
    ^w
]

{ #category : #initialization }
NMLayer >> w: matrixForWeights [
	"MMatrixを引数に取る"
    
    w := matrixForWeights
]
