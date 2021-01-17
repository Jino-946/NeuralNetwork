"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestNeuralNetwork,
	#superclass : #PackageManifest,
	#category : #'NeuralNetwork-Manifest'
}

{ #category : #'code-critics' }
ManifestNeuralNetwork class >> ruleRBImplementedNotSentRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#NeuronFigures)) #'2021-01-17T14:44:47.429824+09:00') )
]

{ #category : #'code-critics' }
ManifestNeuralNetwork class >> ruleRBLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#NeuronFigures)) #'2021-01-17T14:44:33.706312+09:00') )
]
