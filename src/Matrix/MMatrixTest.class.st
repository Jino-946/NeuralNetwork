Class {
	#name : #MMatrixTest,
	#superclass : #TestCase,
	#category : #Matrix
}

{ #category : #tests }
MMatrixTest >> testAddition1 [
	| m1 m2 |
	m1 := MMatrix newFromArrays: #(#(1 2 3) #(4 5 6)).
	m2 := MMatrix newFromArrays: #(#(4 5 6) #(1 2 3)).
	self assert: (m1 + m2) asStructuredArray equals: #(#(5.0 7.0 9.0) #(5.0 7.0 9.0))
]

{ #category : #tests }
MMatrixTest >> testAddition2 [
	| m |
	m := MMatrix newFromArrays: #(#(1 2 3) #(4 5 6)).
	self assert: (m + m) asStructuredArray equals: #(#(2.0 4.0 6.0) #(8.0 10.0 12.0))
]

{ #category : #tests }
MMatrixTest >> testAt [
	| m |
    m := MMatrix newFromArrays: #(#(1 2) #(3 4)).
    self assert: (m at: 1 @ 1) equals: 1.
    self assert: (m at: 1 @ 2) equals: 2.
    self assert: (m at: 2 @ 1) equals: 3.
    self assert: (m at: 2 @ 2) equals: 4.    
]

{ #category : #tests }
MMatrixTest >> testAtPut [
	| m |
    m := MMatrix newFromArrays: #(#(1 2) #(3 4)).
    m at: 2 @ 1 put: 10.0.
    self assert: (m at: 2 @ 1) equals: 10.0.
    self assert: m asStructuredArray equals: #(#(1 2) #(10 4))
]

{ #category : #tests }
MMatrixTest >> testCreation [ 
	| m |
	m := MMatrix newFromArrays: #(#(1 2) #(3 4)).
	self assert: m asArray equals: #(1.0 2.0 3.0 4.0)
]

{ #category : #tests }
MMatrixTest >> testMax [
	| m |
    m := MMatrix newFromArrays: #(#(1 2) #(3 4)).
    self assert: m max equals: 4

]

{ #category : #tests }
MMatrixTest >> testStretching [
	| m |
	m := (MMatrix newFromVector: #(1 2 3 4)) stretchToColumns: 5.
    self assert: m nbRows equals: 4.
    self assert: m nbColumns equals: 5.
    self assert: (m atRow: 1) equals: #(1 1 1 1 1).
    self assert: (m atRow: 3) equals: #(3 3 3 3 3)

]

{ #category : #tests }
MMatrixTest >> testSumHorizontal [
	| m expectedResult |
	m := MMatrix newFromArrays: #(#(1.0 2.0) #(3.0 4.0) #(5.0 6.0)).
	expectedResult := MMatrix newFromArrays: #(#(3.0) #(7.0) #(11.0)).
	
	self assert: m sumHorizontal asStructuredArray 
			equals: expectedResult asStructuredArray 
]

{ #category : #tests }
MMatrixTest >> testVectorCreation [
	| v |
    v := MMatrix newFromVector: #(1 2 3).
    self assert: v nbColumns equals: 1.
    self assert: v nbRows equals: 3.
    self assert: v asStructuredArray equals: #(#(1) #(2) #(3))
]