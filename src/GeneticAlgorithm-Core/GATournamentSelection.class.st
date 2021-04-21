Class {
	#name : #GATournamentSelection,
	#superclass : #GASelection,
	#instVars : [
		'tournamentSize'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #initialization }
GATournamentSelection >> createNewPopulation [
	"新しく繁殖した個体で作られた新しい集団を返えす。"
    
    | partnerA partnerB child |
    population := (1 to: self populationSize) collect: [ :seed |
		engine random: (Random seed: seed).
        partnerA := self getGoodIndividual.
        partnerB := self getGoodIndividual.
        child := self mutate: (self crossover: partnerA with: partnerB).
        child computeFitnessUsing: engine fitnessBlock.
        child.
	]
]

{ #category : #initialization }
GATournamentSelection >> getGoodIndividual [
	"集団からランダムに選ばれたtournamentSizeの個体の中から最良の個体を返す"
    | best ind |
    best := nil.
    tournamentSize timesRepeat: [
        ind := initialPopulation at: (self randomNumber: initialPopulation size).
        (best isNil or: [ compareFitness value: ind fitness value: best fitness])
       		ifTrue: [ best := ind]
    ].
    ^ best
]

{ #category : #initialization }
GATournamentSelection >> initialize [

	super initialize.
    tournamentSize := 5
]
