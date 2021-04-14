Class {
	#name : #GASelection,
	#superclass : #Object,
	#instVars : [
		'population',
		'fittest',
		'initialPopulation',
		'fitnessBlock',
		'populationSize',
		'compareFitness',
		'engine'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #initialization }
GASelection >> checkIfEngineSet [

self assert: [ engine notNil ] description: 'Should set the engine'

]

{ #category : #initialization }
GASelection >> checkIfInitialPopulationSet [

self assert: [ initialPopulation notNil ]
		description: 'Should set the initial population'.
        
self assert: [ initialPopulation isCollection ]
		description: 'Has to be a collection'.
        
self assert: [ initialPopulation notEmpty ]
    	description: 'Cannot be empty'
]

{ #category : #initialization }
GASelection >> compareFitness: aTwoArgBlock [
	"引数を2個とるブロックを引数にとり2つの個体の適合値を計算する"
    
    compareFitness := aTwoArgBlock
]

{ #category : #initialization }
GASelection >> engine [
	"選択に関連するGAEngineを返す"
    
    ^ engine

]

{ #category : #initialization }
GASelection >> engine: theEngine [
	"関連するGAEngineをセットする"
    
    engine := theEngine.
    self checkIfEngineSet
]

{ #category : #initialization }
GASelection >> fitnessBlock [
	"各個体の適合度を計算するのに使用する引数1のブロックを返す"
    
    ^ fitnessBlock
]

{ #category : #initialization }
GASelection >> fitnessBlock: aOneArgBlock [
	"引数は各個体の遺伝子について評価される。
    ブロック引数は適合度を計算する必要がある"
    
    fitnessBlock := aOneArgBlock

]

{ #category : #initialization }
GASelection >> fittest [
	"新しい集団の中から最適な個体を返す"
    
    ^ fittest

]

{ #category : #initialization }
GASelection >> initialPopulation: aPopulationAsIndividuals [
	"初期集団をセットする。新しい集団の生成に使用する。"
    
    initialPopulation := aPopulationAsIndividuals.
    self checkIfInitialPopulationSet
]

{ #category : #initialization }
GASelection >> initialize [

	super initialize.
    population := OrderedCollection new.
]

{ #category : #initialization }
GASelection >> population [
	"新しいpopulationを返す"

^ population
]

{ #category : #initialization }
GASelection >> populationSize [
	"集団のサイズを返す"
    
    ^ initialPopulation size
]
