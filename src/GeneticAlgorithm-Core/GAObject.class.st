Class {
	#name : #GAObject,
	#superclass : #Object,
	#instVars : [
		'random'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #utilities }
GAObject >> checkForRandomNumber [

	self assert: [ random notNil ]
		 description: 'Need to provide a random number generator'
]

{ #category : #accessing }
GAObject >> random [
	"オブジェクトに関連する乱数ジェネレータを返す"
    
    ^ random
]

{ #category : #accessing }
GAObject >> random: aRandomNumberGenerator [
	"オブジェクトに関連する乱数ジェネレータをセットする。
    引数はRandomのインスタンスでなければならない。"
    
    random := aRandomNumberGenerator
]

{ #category : #accessing }
GAObject >> randomNumber [
	"0.0から1.0の間の乱数を返す"
    
    ^ random next
]
