Class {
	#name : #GAIndividual,
	#superclass : #GAObject,
	#instVars : [
		'genes',
		'fitness'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #utilities }
GAIndividual >> computeFitnessUsing: fitnessBlock [
	"fitnessが未計算の時fitnessを計算する"
    self assert: [ genes notNil ] description: 'Need to have some genes first'.
    
    "計算済みの時はそのままexitする"
    fitness ifNotNil: [ ^ self ].
    
    "適合度を計算する"
    fitness := fitnessBlock value: genes
]

{ #category : #accesing }
GAIndividual >> fitness [
	"個体の適合度を返す"
    ^ fitness
]

{ #category : #accesing }
GAIndividual >> genes [
	"個体の遺伝子を返す"
    ^ genes
]

{ #category : #accesing }
GAIndividual >> genes: someGenes [
	"個体に遺伝子をセットする。遺伝的操作で使用される"
    genes := someGenes
]

{ #category : #accesing }
GAIndividual >> numberOfGenes [
	"個体の持つ遺伝子数を返す"
    ^ self genes size
]

{ #category : #utilities }
GAIndividual >> set: numberOfGenes genesUsing: geneBlockFactory [
	"パブリックメソッド - 個体の遺伝子を生成する"
    
    self checkForRandomNumber.
    genes := (1 to: numberOfGenes) collect: [ :index |
		geneBlockFactory cull: random cull: index cull: self
	]
]
