Class {
	#name : #GAAbstractCrossoverOperation,
	#superclass : #GAOperation,
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #crossover }
GAAbstractCrossoverOperation >> crossover: partnerA with: partnerB [
	"自分自身と引数をミックスした結果の新しい子供を返す"
    
    ^ self crossover: partnerA with: partnerB midpoint: (self pickCutPointFor: partnerA)
]

{ #category : #crossover }
GAAbstractCrossoverOperation >> crossover: partnerA with: partnerB midpoint: midpoint [
	"自分自身と引数をミックスした結果の新しい子供を返す"
    
	| child crossOverGenes |
    child := GAIndividual new.
    child random: random.
    crossOverGenes := 
    	(partnerA genes first: midpoint), (partnerB genes allButFirst: midpoint).
    child genes: crossOverGenes.
    ^ child
]

{ #category : #'as yet unclassified' }
GAAbstractCrossoverOperation >> pickCutPointFor: anIndividual [
	"サブクラスでオーバーライドされる必要がある"
    
    self subclassResponsibility

]
