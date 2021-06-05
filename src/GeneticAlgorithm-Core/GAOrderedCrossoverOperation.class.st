Class {
	#name : #GAOrderedCrossoverOperation,
	#superclass : #GAAbstractCrossoverOperation,
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GAOrderedCrossoverOperation >> crossOver: individualA with: individualB [
	"2つの個体をミックスした結果である新しい子を返す"
    | i1 i2 |
    i1 := self pickCutPointFor: individualA.
    i2 := self pickCutPointFor: individualB.
    
    "i1はi2より小さいこと確認すること"
    (i1 > i2) ifTrue: [ | t | t := i1. i1 := i2. i2 := t].
    ^ self crossover: individualA with: individualB from: i1 to: i2
]

{ #category : #'as yet unclassified' }
GAOrderedCrossoverOperation >> crossover: individualA with: individualB from: i1 to: i2 [
	"2つの個体をミックスした結果である新しい子を返す。このメソッドは i1 <= i2 を仮定している"
    | child crossOverGenes runningIndex swath |
    child := GAIndividual new.
    child random: random.
    
    swath := individualA genes copyFrom: i1 to: i2.
    crossOverGenes := Array new: individualA genes size.
    crossOverGenes := crossOverGenes copyReplaceFrom: i1 to: i2 with: swath.
    
    runningIndex :=1.
    (individualB genes copyWithoutAll: swath) do: [ :v |
    	(crossOverGenes includes: v) ifFalse: [
    		[(crossOverGenes at: runningIndex) notNil] whileTrue: [
        		runningIndex := runningIndex + 1
    		].
        crossOverGenes at: runningIndex put:v
    	]
	].
    child genes: crossOverGenes.
    ^ child
    
]

{ #category : #'as yet unclassified' }
GAOrderedCrossoverOperation >> pickCutPointFor: partner [
	"単純に1から引数で与えられた個体の遺伝子数の間の乱数を返す"
    ^ random nextInt: partner genes size
]
