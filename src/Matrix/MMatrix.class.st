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
MMatrix >> + matrixOrVector [
	"レシーバにマトリックスまたはベクトルを加算する。
    引数には同じサイズのマトリックスかベクトルをとる。
    結果として新しいマトリックスを返す
    "

	| m |
	((nbRows = matrixOrVector nbRows) and: [ nbColumns = matrixOrVector nbColumns ])
		ifTrue: [ ^ self add: matrixOrVector ].
	matrixOrVector nbColumns ~= 1 ifTrue: [ self error: 'not a n * 1 vector'].
	m := matrixOrVector stretchToColumns: nbColumns.
	^ self + m
]

{ #category : #initialization }
MMatrix >> add: aMatrix [
	"レシーバと引数の２つのマトリックスを加算し、新しいマトリックスを生成する"
    
    | result resultArray |
	nbColumns = aMatrix nbColumns ifFalse: [ self error: 'dimensions do not confirm' ].
	nbRows = aMatrix nbRows ifFalse: [ self error: 'dimensions do not confirm' ].
	
	resultArray := ByteArray new: (nbRows * aMatrix nbColumns * 8).
	self assert: [ nbRows * nbColumns = array size ].
	self assert: [ aMatrix nbRows * aMatrix nbColumns = aMatrix size ].
	self assert: [ nbRows * aMatrix nbColumns * 8 = resultArray size ].
	self add: self getHandle with: nbRows with: nbColumns with: aMatrix getHandle in: resultArray .
	
	result := MMatrix newHandle: resultArray rows: nbRows columns: nbColumns.
	^ result 
]

{ #category : #initialization }
MMatrix >> add: m1 with: nb_rows with: nb_columns with: m2 in: res [ 
	
	^ self
		ffiCall: #(void add(double *m1, int nb_rows, int nb_columns,
							double *m2, double *res))
		module: 'libmatrix.so'
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
MMatrix >> asStructuredArray [
	"マトリックスを記述する構造化配列を返す"
    ^ (1 to: nbRows) collect: [ :i | self atRow: i] as: Array
]

{ #category : #initialization }
MMatrix >> at: aPoint [
	"マトリックスの要素にアクセスする"
    
    ^ array at: ((aPoint x - 1) * nbColumns + (aPoint y - 1)) + 1
]

{ #category : #initialization }
MMatrix >> at: aPoint put: aNumber [
	"マトリックスの要素を更新する"
    
    array at: ((aPoint x -1) * nbColumns + (aPoint y - 1)) + 1 put: aNumber asFloat

]

{ #category : #initialization }
MMatrix >> atRow: rowNumber [
	"行を返す"
    (rowNumber between: 1 and: rowNumber)
    	ifFalse: [self error: 'index out of range'].
        ^ (1 to: nbColumns) collect: [ :x | self at: rowNumber @ x]

]

{ #category : #initialization }
MMatrix >> fromContents: content [
	"マトリックスを線形コンテントで初期化する"
    
    self assert: [content size = (nbColumns * nbRows)] description: 'size mismatch'.
    content doWithIndex: [ :v :i | array at:i put: v]
]

{ #category : #initialization }
MMatrix >> getHandle [
	""
	
	^ array getHandle
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
MMatrix >> max [
	"マトリックスの最大値を返す"
    ^ self asArray max
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

{ #category : #initialization }
MMatrix >> sumHorizontal [
	"Horizontal summing"
	
	| result sum |
	result := MMatrix newRows: nbRows columns: 1.
	1 to: nbRows do: [ :y |
		sum := 0.
		1 to: nbColumns do: [ :x |
			sum := sum + (self at: y @ x)
		].
		result at: y @ 1 put: sum
	].
	^ result
]
