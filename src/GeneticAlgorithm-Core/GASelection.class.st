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

{ #category : #'as yet unclassified' }
GASelection >> createNewPopulation [
	"新しい集団を生成する"
    
    self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GASelection >> crossover: partnerA with: partnerB [
	"２つの引数を交配した結果であるところの子供を返す"
    
    ^ engine crossover: partnerA with: partnerB
]

{ #category : #'as yet unclassified' }
GASelection >> doSelection [
	"選択アルゴリズムを用いて新しい集団を作る"
    
    self checkIfEngineSet.
    self checkIfInitialPopulationSet.
    populationSize := initialPopulation size.
    fittest := initialPopulation first.
    initialPopulation do: [ :ind |
    	ind computeFitnessUsing: fitnessBlock.
        (self isIndividual: ind betterThan: fittest)
        	ifTrue: [ fittest := ind]
	].
    self createNewPopulation.
    initialPopulation := population.
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

{ #category : #'as yet unclassified' }
GASelection >> isIndividual: ind betterThan: fittestIndividual [
	"最初の個体が２番目より優れているか判定する"
    
    ^ engine isIndividual: ind betterThan: fittestIndividual
]

{ #category : #'as yet unclassified' }
GASelection >> mutate: child [
	"引数を変異する"
    
    ^ engine mutate: child
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

{ #category : #initialization }
GASelection >> populationSize: anInteger [ 
	"集団のサイズをセットする"
    
    populationSize := anInteger 
]

{ #category : #'as yet unclassified' }
GASelection >> randomNumber: value [
	"1からvalueの間の乱数を返す"
    
    ^ engine randomNumber: value
]
