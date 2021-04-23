Class {
	#name : #GALog,
	#superclass : #Object,
	#instVars : [
		'generationNumber',
		'timeToProduceGeneration',
		'fittestIndividual',
		'worseFitness',
		'averageFitness'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #accessing }
GALog >> averageFitness: aNumber [
	"提示する世代の平均適合値をセットする"
    
    averageFitness := aNumber
]

{ #category : #accessing }
GALog >> averageFitnesss [
	"提示する世代の平均適合値を返す"
    
    ^ averageFitness
]

{ #category : #accessing }
GALog >> bestFitness [
	"提示する世代の最高の適合値を返す"
    
    ^ fittestIndividual fitness
]

{ #category : #accessing }
GALog >> fittestIndividual [
	"提示する世代の最高の個体を返す"
    
    ^ fittestIndividual
]

{ #category : #accessing }
GALog >> fittestIndividual: anIndividual [
	"提示する世代の最高の個体をセットする"
    
    fittestIndividual := anIndividual
]

{ #category : #accessing }
GALog >> generationNumber [
	"世代数を返す"
    
    ^ generationNumber
]

{ #category : #accessing }
GALog >> generationNumber: generationNumberAsInteger [
	"世代数をセットする"
    
    generationNumber := generationNumberAsInteger
]

{ #category : #accessing }
GALog >> printOn: str [
	"ログオブジェクトを出力する"
    
    super printOn: str.
    str nextPut: $<.
    str nextPutAll: fittestIndividual genes asString.
    str nextPut: $>
]

{ #category : #accessing }
GALog >> timeToProduceGeneration [
	"世代を生成に必要な時間"
    
    ^ timeToProduceGeneration
]

{ #category : #accessing }
GALog >> timeToProduceGeneration: anInteger [
	"世代の生成にかかる時間をセットする"
    
    timeToProduceGeneration := anInteger
]

{ #category : #accessing }
GALog >> worseFitness [
	"提示する世代の最低の適合値を返す"
    
    ^ worseFitness
]

{ #category : #accessing }
GALog >> worseFitness: aNumber [
	"提示する世代の最低の適合値をセットする"
    
    worseFitness := aNumber
]
