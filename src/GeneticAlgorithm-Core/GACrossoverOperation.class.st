Class {
	#name : #GACrossoverOperation,
	#superclass : #GAAbstractCrossoverOperation,
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GACrossoverOperation >> pickCutPointFor: partnerA [
	"単純に1から引数で与えられた個体の遺伝子数の間の乱数を返す"
    
    ^ random nextInt: partnerA numberOfGenes 

]
