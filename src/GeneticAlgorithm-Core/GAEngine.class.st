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
GAEngine >> beforeCreatingInitialIndividual: aOneArgBlock [
	"個体を作成する前に実行する動作を設定する。
    ブロックは引数として乱数ジェネレータをとる。"
    beforeCreatingInitialIndividual := aOneArgBlock
]

{ #category : #accessing }
GAEngine >> beforeRun [
	"最初の母集団が作られる前にメソッドは実行される"
    self checkIfReadyToRun.
    selection fitnessBlock: fitnessBlock.
    selection populationSize: populationSize
]

{ #category : #accessing }
GAEngine >> checkIfReadyToRun [
	"実行用の設定が整えられていない時に例外を発生する"
    self assert: [ fitnessBlock notNil ] 
    		description: 'Need to set a fitnessBlock'.
    self assert: [ createGeneBlock notNil ] 
    		description: 'Need to set a createGeneBlock'.
    self assert: [ numberOfGenes notNil ]
			description: 'Need to set how many genes you wish to have, using numberOfGenes:'.
    self assert: [ logs isEmpty]
			description: 'Already been run'
    
]

{ #category : #accessing }
GAEngine >> createGeneBlock: threeArgBlock [
	"3個の引数は乱数、インデックス及び入力する個体であること"
    
    createGeneBlock := threeArgBlock.
    mutationOperator geneFactoryBlock: threeArgBlock
]

{ #category : #accessing }
GAEngine >> crossoverOperator: aCrossoverOperator [
	"アルゴリズム内で使用する交配オペレータをセットする"
    crossoverOperator := aCrossoverOperator.
    crossoverOperator random: random
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

{ #category : #accessing }
GAEngine >> initialize [
	super initialize.
    logs := OrderedCollection new.
    random := Random seed: 42.
    self endForMaxNumberOfGeneration: 10.
    populationSize := 10.
    self maximizeComparator.
    mutationOperator := GAMutationOperation new.
    mutationOperator mutationRate: 0.01.
    mutationOperator random: random.
    
    crossoverOperator := GACrossoverOperation new.
    crossoverOperator random: random.
    
    self selection: GATournamentSelection new.
    
    beforeCreatingInitialIndividual := [ :rand | "do nothing per default"] 
]

{ #category : #accessing }
GAEngine >> maximizeComparator [
	"より良い個体は最も高い最適値の個体である"
    compareFitness := [ :f1 :f2 | f1 > f2]
]

{ #category : #accessing }
GAEngine >> minimizeComparator [
	"最適値が最も低い個体がより良い個体であることもあり得る。"
    compareFitness := [ :f1 :f2 | f1 < f2 ]
]

{ #category : #accessing }
GAEngine >> mutationOperator: aMutationOperator [
	mutationOperator := aMutationOperator.
    mutationOperator random: random
]

{ #category : #accessing }
GAEngine >> mutationRate: aFloat [
	"エンジンが使う変異率をセットする。デフォルト値は0.01"
    mutationOperator mutationRate: aFloat
]

{ #category : #accessing }
GAEngine >> numberOfGenes: anInteger [
	"それぞれの個体が持つ遺伝子数をセットする"
    numberOfGenes := anInteger
]

{ #category : #accessing }
GAEngine >> populationSize: anInteger [
	"母集団のサイズをセットする"
    populationSize := anInteger
]

{ #category : #accessing }
GAEngine >> selection [
	"選択オペレータを返す"
    ^ selection
]

{ #category : #accessing }
GAEngine >> selection: aSelection [
	"新しい母集団の作成に使う選択メソッドをセットする"
	selection := aSelection.
	selection engine: self
]
