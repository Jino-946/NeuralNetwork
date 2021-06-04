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
GAEngine >> crossover: partnerA with: partnerB [
	"2つの引数間の交配操作を行う"
    ^ crossoverOperator crossover: partnerA with: partnerB
]

{ #category : #accessing }
GAEngine >> crossoverOperator: aCrossoverOperator [
	"アルゴリズム内で使用する交配オペレータをセットする"
    crossoverOperator := aCrossoverOperator.
    crossoverOperator random: random
]

{ #category : #accessing }
GAEngine >> endForMaxNumberOfGeneration: nbOfGenerations [
	"一定の世代数でアルゴリズムを終了する"
    terminationBlock := [ logs last generationNumber >= nbOfGenerations ]
]

{ #category : #accessing }
GAEngine >> endIfFitnessIsAbove: aFitnessValueThreshold [
	"最適値が特定の閾値を超えたらアルゴリズムを終了する"
    terminationBlock := [ logs last fittestIndividual fitness >= aFitnessValueThreshold]
]

{ #category : #accessing }
GAEngine >> endIfNoImprovementFor: nbOfGenerations [
	"特定の世代数が経過しても改善されない時は終了する"
    ^ self endIfNoImprovementFor: nbOfGenerations withinRangeOf: 0
]

{ #category : #accessing }
GAEngine >> endIfNoImprovementFor: nbOfGenerations withinRangeOf: delta [
	"デルタ値の範囲で特定の世代数が経過しても改善されない時は終了する"
    terminationBlock := [
        (logs last generationNumber >= nbOfGenerations ) and: [
        	| fs |
            fs := (logs last: nbOfGenerations) collect: [ :aLog |
            	aLog fittestIndividual fitness
        	].
            (fs max - fs min) <= delta
    	]  
	]
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
GAEngine >> gtInspectorLogsIn: composite [
	<gtInspectorPresentationOrder: -5>
    composite list
    	title: 'Logs';
        display: [ self logs ]
]

{ #category : #accessing }
GAEngine >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
    composite roassal2
    	title: 'View';
        initializeView: [ self visualize ]
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
GAEngine >> initializePopulation [
	self checkForRandomNumber.
    population := OrderedCollection new.
    populationSize timesRepeat: [
        | ind |
        beforeCreatingInitialIndividual value: random.
       	ind := GAIndividual new.
        population add: (ind random: random;
        					 set: numberOfGenes genesUsing: createGeneBlock)
	]
]

{ #category : #accessing }
GAEngine >> isIndividual: anIndividual betterThan: aFittestIndividual [
	"母集団中の最適な個体と個体を比較する"
    ^ compareFitness value: anIndividual fitness value: aFittestIndividual fitness
]

{ #category : #accessing }
GAEngine >> logs [
	"実行ログを返す"
    ^ logs
]

{ #category : #accessing }
GAEngine >> maximizeComparator [
	"より良い個体は最も高い最適値の個体である"
    compareFitness := [ :f1 :f2 | f1 > f2]
]

{ #category : #accessing }
GAEngine >> microPause [
	"Transcriptにログし進行を監視する時に有用"
	(Delay forMilliseconds: 1) wait.
	World doOneCycleNow
]

{ #category : #accessing }
GAEngine >> minimizeComparator [
	"最適値が最も低い個体がより良い個体であることもあり得る。"
    compareFitness := [ :f1 :f2 | f1 < f2 ]
]

{ #category : #accessing }
GAEngine >> mutate: individual [
	"与えられた引数を変異する"
    ^ mutationOperator mutate: individual
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
GAEngine >> produceNewPopulation [
	"このメソッドは
    	- 新しく母集団を作成し、変数populationに格納する。
        - 母集団の最適な個体を選択する。
    "
    selection doSelection.
    population := selection population
]

{ #category : #accessing }
GAEngine >> randomNumber: maxNumber [
	"1からmaxNumber間の乱数を返す"
    ^ random nextInt: maxNumber
]

{ #category : #accessing }
GAEngine >> result [
	"最適な個体の遺伝子を返す。このメソッドは#runの完了後に実行すること"
    ^ self logs last fittestIndividual genes
]

{ #category : #accessing }
GAEngine >> run [
	"パブリックメソッド -- 遺伝子アルゴリズムを実行する"
    | t log |
    self beforeRun.
    self initializePopulation.
    selection initialPopulation: population.
    selection compareFitness: compareFitness.
    UIManager default informUserDuring: [ :bar |
		| gen |
        gen := 0.
        [self shouldTerminate ] whileFalse: [ 
        	gen := gen  + 1.
            bar label: gen asString.
            self microPause.
            t := Time now asSeconds.
            self produceNewPopulation.
            
            log := GALog new.
            log generationNumber: gen.
            log fittestIndividual: selection fittest.
            log worseFitness: (
            	(population collect: #fitness)
            		inject: log bestFitness into: [ :wFit :current | 
                    	(compareFitness value: wFit value: current) 
                        	ifTrue: [current ] ifFalse: [ wFit]
        			]
            ).
            log averageFitness: (population collect: #fitness) average asFloat.
            log timeToProduceGeneration: Time now asSeconds - t.
            logs add: log 
		]
    ]
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

{ #category : #accessing }
GAEngine >> shouldTerminate [
	logs ifEmpty: [ ^ false ].
	^ terminationBlock value
]

{ #category : #accessing }
GAEngine >> visualize [
	"母集団の進化を可視化する"
    | g d |
    g := RTGrapher new.
    d := RTData new.
    d label: 'Best fitness'.
    d interaction popupText: [ :assoc | assoc value bestFitness ].
    d connectColor: Color blue.
    d noDot.
    d points: self logs.
    d y: #bestFitness.
    d x: #generationNumber.
    g add: d.
    
    d := RTData new.
    d label: 'Worst fitness'.
    d interaction popupText: [ :assoc | assoc value worseFitness ].
    d connectColor: Color red.
    d noDot.
    d points: self logs.
    d y: #worseFitness.
    d x: #generationNumber.
    g add: d.

    d := RTData new.
    d label: 'Average fitness'.
    d interaction popupText: [ :assoc | assoc value averageFitness ].
    d connectColor: Color green.
    d noDot.
    d points: self logs.
    d y: #averageFitness.
    d x: #generationNumber.
    g add: d.

	g legend addText: 'Fitness evolution'.
    g axisY title: 'Fitness'.
    g axisX noDecimal; title: 'Generation'.
    ^ g
    
]
