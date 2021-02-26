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
MMatrix class >> newFromVector: array [
	""
	
	^self basicNew 
		initializeRows: array size columns: 1;
		fromContents: array;
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
MMatrix >> * aFactor [
	"マトリックスの各要素にaFactorを掛ける"
    
    ^ self collect: [ :v | v * aFactor]
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
MMatrix >> +* anotherMatrix [
	" dot:メソッドのショートカット"
    
    ^ self dot: anotherMatrix
]

{ #category : #initialization }
MMatrix >> / value [
	"マトリックスの各要素をvalueで割る"
    
    ^self collect: [ :v | v / value]
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
MMatrix >> collect: aOneArgBlock [
	"引数で与えられたブロックを使って変換した要素を持つ新しいマトリックスを返す"
    
    | result |
    result := MMatrix newRows: nbRows columns: nbColumns.
    1 to: nbRows do: [ :y |
    	1 to: nbColumns do: [ :x |
        	result at: y @ x put: (aOneArgBlock value: (self at: y @ x))
    	].
	].
    ^ result
]

{ #category : #initialization }
MMatrix >> dot: anotherMatrix [
	"レシーバ・マトリックスと引数の積を計算する"
    
    | result resultArray |
    nbColumns = anotherMatrix nbRows ifFalse: [self error: 'dimensions do not confirm'].
    self assert: [ nbRows * nbColumns = array size].
    self assert: [ anotherMatrix nbRows * anotherMatrix nbColumns = anotherMatrix size].
    
    resultArray := ByteArray new: (nbRows * anotherMatrix nbColumns * 8).
    self dot: self getHandle with: nbRows with: nbColumns with: anotherMatrix getHandle
    						with: anotherMatrix nbRows with: anotherMatrix nbColumns
                            in: resultArray.
    result := MMatrix newHandle: resultArray rows: nbRows columns: anotherMatrix nbColumns.
    ^ result
]

{ #category : #initialization }
MMatrix >> dot: array1 with: m1_nb_rows with: m1_nb_columns with: array2
		with: m2_nb_rows with: m2_nb_columns in: res [
	"Cライブラリを呼び出してドット演算子を実行する"
    
    ^ self
    	ffiCall: #(void dot(void *array1, int m1_nb_rows, int m1_nb_columns,
        		void *array2, int m2_nb_rows, int m2_nb_columns, void *res))
        module: 'libmatrix.so'
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
MMatrix >> multiplyPerElement: mat [
	"2つのマトリックスで要素同士を乗算する"
    
    | r |
    self assert: [nbRows = mat nbRows].
    self assert: [nbColumns = mat nbColumns].
    r := MMatrix newRows: nbRows columns: nbColumns.
    r fromContents: (self asArray with: 
    		mat array asArray collect: [ :a :b | a * b ]).
    ^ r
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
MMatrix >> printOn: aStream [
	"ストリームにマトリックスを小数点以下4桁でプリントする"
    
    self printOn: aStream round: 4
]

{ #category : #initialization }
MMatrix >> printOn: aStream round: nbDecimals [
	"マトリックスをストリームにプリントする。すべての数値は固定の桁数に丸められる"
    
    aStream nextPutAll: '('. 
    	(1 to: nbRows) do: [ :r |
    		(self atRow: r) do: [ :each |
            	aStream nextPutAll: (each round: nbDecimals) printString
    		]
           separatedBy: [aStream space]
		]
       separatedBy: [ aStream cr].
    aStream nextPutAll: ')'
]

{ #category : #initialization }
MMatrix >> size [
	"マトリックスに格納されている値の数"
    
    ^ nbColumns * nbRows
]

{ #category : #initialization }
MMatrix >> stretchToColumns: nbOfColumns [
	"垂直ベクトルを列に展開する"
    | content result |
    content := OrderedCollection new.
    1 to: nbRows do: [ :row |
    1 to: nbOfColumns do: [ :columns |
    		content add: (self at: row @ 1)
    	].		
	].
    result := MMatrix newRows: nbRows columns: nbOfColumns.
    result fromContents: content.
    ^ result
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
