Class {
	#name : #GAEngine,
	#superclass : #GAObject,
	#instVars : [
		'fitnessBlock',
		'createGeneBlock',
		'numberOfGenes',
		'populationSize',
		'logs',
		'population',
		'terminationBlock',
		'compareFitness',
		'mutationOperator',
		'crossoverOperator',
		'selection',
		'beforeCreatingInitialIndividual'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #accessing }
GAEngine >> createGeneBlock: threeArgBlock [
	"3個の引数は乱数、インデックス及び入力する個体であること"
    
    createGeneBlock := threeArgBlock.
    mutationOperator geneFactoryBlock: threeArgBlock
]

{ #category : #accessing }
GAEngine >> fitnessBlock [
	"エンジンが利用する適合値ブロックを返す"
    
    ^ fitnessBlock
]

{ #category : #accessing }
GAEngine >> fitnessBlock: aOneArgBlock [
	"引数でそれぞれの個体の遺伝子を評価する。 ブロック引数は適合値を計算する必要がある"
    fitnessBlock := aOneArgBlock
]
