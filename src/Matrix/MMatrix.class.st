Class {
	#name : #MMatrix,
	#superclass : #Object,
	#instVars : [
		'nbRows',
		'nbColumns',
		'array'
	],
	#category : #Matrix
}

{ #category : #'instance creation' }
MMatrix class >> newFromArrays: arrays [
	""
	
	^self basicNew 
		initializeRows: arrays size columns: arrays first size;
		fromContents: (arrays flatCollect: #yourself);
		yourself 
]

{ #category : #'instance creation' }
MMatrix class >> newHandle: aHandle rows: numRows columns: numColumns [
	""
	
	^self basicNew 	
		initializeHandle: aHandle rows: numRows columns: numColumns ;
		yourself 
]

{ #category : #'instance creation' }
MMatrix class >> newRows: numRows columns: numColumns [
	""
	
	^ self basicNew 	
	initializeRows: numRows columns: numColumns;
	yourself
]

{ #category : #initialization }
MMatrix >> array [ 
	""
	
	^array 
]

{ #category : #initialization }
MMatrix >> asArray [ 
	""
	
	^ array asArray 
]

{ #category : #initialization }
MMatrix >> fromContents: content [
	"マトリックスを線形コンテントで初期化する"
    
    self assert: [content size = (nbColumns * nbRows)] description: 'size mismatch'.
    content doWithIndex: [ :v :i | array at:i put: v]
]

{ #category : #initialization }
MMatrix >> initializeHandle: aHandle rows: numRows columns: numColumns [ 
	""
	
	self initialize.
	nbRows := numRows.
	nbColumns := numColumns.
	array := self newArrayFromHandle: aHandle
]

{ #category : #initialization }
MMatrix >> initializeRows: numRows columns: numColumns [
	self initialize.
	nbRows := numRows.
	nbColumns := numColumns.
	array := self newArray
]

{ #category : #initialization }
MMatrix >> nbColumns [
	"マトリックスで定義されている列数"
    
    ^ nbColumns

]

{ #category : #initialization }
MMatrix >> nbRows [
	"マトリックスで定義されている行数"
    
    ^ nbRows
		
]

{ #category : #initialization }
MMatrix >> newArray [ 
	""
	
	^FFIExternalArray 
		newType: 'double' size: nbColumns * nbRows   
]

{ #category : #initialization }
MMatrix >> newArrayFromHandle: aHandle [
	""
	
	^ FFIExternalArray 
		fromHandle: aHandle type: 'double' size: nbColumns * nbRows 
		
]

{ #category : #initialization }
MMatrix >> size [
	"マトリックスに格納されている値の数"
    
    ^ nbColumns * nbRows
]
