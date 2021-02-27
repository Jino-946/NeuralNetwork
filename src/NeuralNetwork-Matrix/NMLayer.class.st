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
NMLayer >> initialize [ 

	super initialize.
	lr := 0.1
]

{ #category : #initialization }
NMLayer >> lr: learningRate [

	lr := learningRate
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
NMLayer >> w [
	"重みを表現するMMatrixを返す"
    
    ^w
]

{ #category : #initialization }
NMLayer >> w: matrixForWeights [
	"MMatrixを引数に取る"
    
    w := matrixForWeights
]
