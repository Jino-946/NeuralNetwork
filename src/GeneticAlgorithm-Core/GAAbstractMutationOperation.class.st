Class {
	#name : #GAAbstractMutationOperation,
	#superclass : #GAOperation,
	#instVars : [
		'mutationRate'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #acccessing }
GAAbstractMutationOperation >> doMutate: individual [
	"オーバーライドすること"

	self subclassResponsibility
]

{ #category : #accessing }
GAAbstractMutationOperation >> geneFactoryBlock: oneArgBlock [
	"Do nothing. May be overridden if necessary"
]

{ #category : #initalize }
GAAbstractMutationOperation >> initialize [

	super initialize.
    self mutationRate: 0.01
]

{ #category : #acccessing }
GAAbstractMutationOperation >> mutate: individual [
	"引数として渡された個体を偏した結果である新しい個体を返す。
    (引数と異なるオブジェクト)
    "
	
    | newIndividual |
    newIndividual := GAIndividual new.
    newIndividual random: random.
    newIndividual genes: individual genes copy.
    self doMutate: newIndividual.
    ^ newIndividual
]

{ #category : #acccessing }
GAAbstractMutationOperation >> mutationRate [
	"変異レートを返す。
	通常、この変数の値は小さい正の数値で0.0に近く1.0より大幅に小さい値になる。
    "

	^ mutationRate
]

{ #category : #acccessing }
GAAbstractMutationOperation >> mutationRate: aFloat [
	"変異レートをセット。
	通常、この変数の値は小さい正の数値で0.0に近く1.0より大幅に小さい値になる。
    "

	^ mutationRate := aFloat
]
