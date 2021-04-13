Class {
	#name : #GAMutationOperation,
	#superclass : #GAAbstractMutationOperation,
	#instVars : [
		'geneFactoryBlock'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #utilities }
GAMutationOperation >> checkForGeneFactory [

self assert: [ geneFactoryBlock notNil ]
	 description: 'Need to provide a block to create gene'
]

{ #category : #utilities }
GAMutationOperation >> doMutate: individual [
	"引数の遺伝子を変異する"
    
    self checkForRandomNumber.
    self checkForGeneFactory.
    1 to: individual genes size do: [ :index |
		self randomNumber <= mutationRate
        ifTrue: [ individual genes at: index 
        			put:(geneFactoryBlock cull: random cull: index cull:individual)]
	]
]

{ #category : #accessing }
GAMutationOperation >> geneFactoryBlock: oneArgBlock [
	"ブロックは引数として乱数１個とる"
    
    geneFactoryBlock := oneArgBlock
]
