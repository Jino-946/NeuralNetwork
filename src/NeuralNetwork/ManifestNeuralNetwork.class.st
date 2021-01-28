"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestNeuralNetwork,
	#superclass : #PackageManifest,
	#category : #'NeuralNetwork-Manifest'
}

{ #category : #'code-critics' }
ManifestNeuralNetwork class >> ruleRBCodeCruftLeftInMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#NeuralNetworkTest #testXOR #false)) #'2021-01-28T12:46:48.063138+09:00') )
]

{ #category : #'code-critics' }
ManifestNeuralNetwork class >> ruleRBGlobalVariablesUsageV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#NeuralNetworkTest #testXOR #false)) #'2021-01-28T12:46:36.62886+09:00') )
]

{ #category : #'code-critics' }
ManifestNeuralNetwork class >> ruleRBImplementedNotSentRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#NeuronFigures)) #'2021-01-17T14:44:47.429824+09:00') )
]

{ #category : #'code-critics' }
ManifestNeuralNetwork class >> ruleRBLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#NeuronFigures)) #'2021-01-17T14:44:33.706312+09:00') )
]

{ #category : #'code-critics' }
ManifestNeuralNetwork class >> ruleReTestClassNotInPackageWithTestEndingNameV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#NeuralNetwork)) #'2021-01-26T16:37:47.676437+09:00') )
]
