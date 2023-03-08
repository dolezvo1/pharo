Class {
	#name : #SHRBStyleAttributionTest,
	#superclass : #TestCase,
	#instVars : [
		'styler',
		'oldSetting'
	],
	#classVars : [
		'Test'
	],
	#pools : [
		'SHRBMockSharedPoolStyler'
	],
	#category : #'Shout-Tests-Styling'
}

{ #category : #asserting }
SHRBStyleAttributionTest >> assertStyleOf: aText at: index shouldBe: aStyleSymbol [

	self
		assertStyleOf: aText
		between: index
		and: index
		shouldBe: aStyleSymbol
]

{ #category : #asserting }
SHRBStyleAttributionTest >> assertStyleOf: aText between: min and: max shouldBe: aStyleSymbol [

	min to: max do: [ :index | self assert: (aText attributesAt: index) anyOne name equals: aStyleSymbol ]
]

{ #category : #running }
SHRBStyleAttributionTest >> setUp [

	super setUp.
	styler := SHRBMockTextStyler new.
	oldSetting := SHRBMockTextStyler instVarNamed: #formatIncompleteIdentifiers
]

{ #category : #accessing }
SHRBStyleAttributionTest >> style: aText [

	| ast |
	ast := self class compiler
		       source: aText asString;
		       noPattern: false;
		       class: self class;
		       options: #( + optionParseErrors + optionSkipSemanticWarnings );
		       parse.
	styler style: aText ast: ast.

	^ ast
]

{ #category : #running }
SHRBStyleAttributionTest >> tearDown [

	SHRBMockTextStyler formatIncompleteIdentifiers: oldSetting.
	super tearDown
]

{ #category : #tests }
SHRBStyleAttributionTest >> testArgumentStyle [

	| aText |
	aText := 'm: arg ^ arg' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 10
		and: 12
		shouldBe: #argument
]

{ #category : #tests }
SHRBStyleAttributionTest >> testAssignmentStyle [

	| aText |
	aText := 'm ^ styler := 2' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 10
		shouldBe: #instVar.
	self assertStyleOf: aText at: 15 shouldBe: #number
]

{ #category : #tests }
SHRBStyleAttributionTest >> testBinaryStyle [

	| aText |
	aText := 'm self / 3' asText.
	self style: aText.

	self assertStyleOf: aText at: 8 shouldBe: #keyword
]

{ #category : #tests }
SHRBStyleAttributionTest >> testBlockArgColonStyle [

	| aText |
	aText := 'm ^ [ :arg | arg ]' asText.
	self style: aText.

	self assertStyleOf: aText at: 7 shouldBe: #blockArgColon
]

{ #category : #tests }
SHRBStyleAttributionTest >> testBlockArgStyle [

	| aText |
	aText := 'm ^ [ :arg | arg ]' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 14
		and: 16
		shouldBe: #blockArg
]

{ #category : #tests }
SHRBStyleAttributionTest >> testBlockArgsBarStyle [

	| aText |
	aText := 'm [ :a | ^ a ]' asText.
	self style: aText.

	self assertStyleOf: aText at: 8 shouldBe: #blockArgsBar
]

{ #category : #tests }
SHRBStyleAttributionTest >> testBlockPatternArgStyle [

	| aText |
	aText := 'm ^ [ :arg | arg ]' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 8
		and: 10
		shouldBe: #blockPatternArg
]

{ #category : #tests }
SHRBStyleAttributionTest >> testBlockPatternTempVarStyle [

	| aText |
	aText := 'm ^ [ | arg | arg ]' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 9
		and: 11
		shouldBe: #blockPatternTempVar
]

{ #category : #tests }
SHRBStyleAttributionTest >> testBlockStyle [

	| aText |
	aText := 'm ^ [ self a and: [ self b and: [ self c and: [ self d and: [ self e and: [ self f and: [ self h and: [ self i ]]]]]]]]' asText.
	self style: aText.

	self assertStyleOf: aText at: 5 shouldBe: #blockStart.
	self assertStyleOf: aText at: 19 shouldBe: #blockStart1.
	self assertStyleOf: aText at: 33 shouldBe: #blockStart2.
	self assertStyleOf: aText at: 47 shouldBe: #blockStart3.
	self assertStyleOf: aText at: 61 shouldBe: #blockStart4.
	self assertStyleOf: aText at: 75 shouldBe: #blockStart5.
	self assertStyleOf: aText at: 89 shouldBe: #blockStart6.
	self assertStyleOf: aText at: 103 shouldBe: #blockStart7.
	self assertStyleOf: aText at: 112 shouldBe: #blockEnd7.
	self assertStyleOf: aText at: 113 shouldBe: #blockEnd6.
	self assertStyleOf: aText at: 114 shouldBe: #blockEnd5.
	self assertStyleOf: aText at: 115 shouldBe: #blockEnd4.
	self assertStyleOf: aText at: 116 shouldBe: #blockEnd3.
	self assertStyleOf: aText at: 117 shouldBe: #blockEnd2.
	self assertStyleOf: aText at: 118 shouldBe: #blockEnd1.
	self assertStyleOf: aText at: 119 shouldBe: #blockEnd
]

{ #category : #tests }
SHRBStyleAttributionTest >> testBlockTempBarStyle [

	| aText |
	aText := 'm [ | a | ^ a ]' asText.
	self style: aText.

	self assertStyleOf: aText at: 5 shouldBe: #blockTempBar.
	self assertStyleOf: aText at: 9 shouldBe: #blockTempBar
]

{ #category : #tests }
SHRBStyleAttributionTest >> testBlockTempVarStyle [

	| aText |
	aText := 'm ^ [ | arg | arg ]' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 15
		and: 17
		shouldBe: #blockTempVar
]

{ #category : #tests }
SHRBStyleAttributionTest >> testCascadeSeparatorStyle [

	| aText |
	aText := 'm self a; b' asText.
	self style: aText.

	self assertStyleOf: aText at: 9 shouldBe: #cascadeSeparator
]

{ #category : #tests }
SHRBStyleAttributionTest >> testCharacterStyle [

	| aText |
	aText := 'm ^ $1' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 6
		shouldBe: #character
]

{ #category : #tests }
SHRBStyleAttributionTest >> testClassVarStyle [

	| aText |
	aText := 'm ^ Test' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 9
		shouldBe: #classVar
]

{ #category : #tests }
SHRBStyleAttributionTest >> testCommentStyle [

	| aText |
	aText := 'm "return class" ^ SHRBStyleAttributionTest' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 3
		and: 16
		shouldBe: #comment
]

{ #category : #tests }
SHRBStyleAttributionTest >> testDefaultStyle [

	| aText |
	aText := 'm thisContext senders' asText.
	self style: aText.

	self assertStyleOf: aText at: 2 shouldBe: #default
]

{ #category : #tests }
SHRBStyleAttributionTest >> testFalseStyle [

	| aText |
	aText := 'm false' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 3
		and: 7
		shouldBe: #false
]

{ #category : #tests }
SHRBStyleAttributionTest >> testGlobalVarStyle [

	| aText |
	aText := 'm ^ Smalltalk' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 11
		shouldBe: #globalVar
]

{ #category : #tests }
SHRBStyleAttributionTest >> testIncompleteIdentifierStyle [

	| aText |
	SHRBMockTextStyler formatIncompleteIdentifiers: true.
	aText := 'm ^ style' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 9
		shouldBe: #incompleteIdentifier
]

{ #category : #tests }
SHRBStyleAttributionTest >> testIncompleteKeywordStyle [

	| aText |
	SHRBMockTextStyler formatIncompleteIdentifiers: true.
	aText := 'm ^ self setU' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 10
		and: 13
		shouldBe: #incompleteKeyword
]

{ #category : #tests }
SHRBStyleAttributionTest >> testInstanceVarStyle [

	| aText |
	aText := 'm ^ styler' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 10
		shouldBe: #instVar
]

{ #category : #tests }
SHRBStyleAttributionTest >> testInvalidStyle [

	| aText |
	aText := 'm ^ #(' asText.
	self style: aText.

	self assertStyleOf: aText at: 6 shouldBe: #invalid
]

{ #category : #tests }
SHRBStyleAttributionTest >> testKeywordStyle [

	| aText |
	aText := 'm self style: ''test''' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 8
		and: 13
		shouldBe: #keyword
]

{ #category : #tests }
SHRBStyleAttributionTest >> testMethodTempBarStyle [

	| aText |
	aText := 'm | a | ^ a' asText.
	self style: aText.

	self assertStyleOf: aText at: 3 shouldBe: #methodTempBar.
	self assertStyleOf: aText at: 7 shouldBe: #methodTempBar
]

{ #category : #tests }
SHRBStyleAttributionTest >> testNilStyle [

	| aText |
	aText := 'm nil' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 3
		and: 6
		shouldBe: #nil
]

{ #category : #tests }
SHRBStyleAttributionTest >> testNumberStyle [

	| aText |
	aText := 'm ^ 12' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 6
		shouldBe: #number
]

{ #category : #tests }
SHRBStyleAttributionTest >> testNumberStyle2 [

	| aText |
	aText := 'm ^ -12' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 7
		shouldBe: #number
]

{ #category : #tests }
SHRBStyleAttributionTest >> testParenthesisStyle [

	| aText |
	aText := 'm ^ (1 + (2 + (3 + (4 + (5 + (6 + (7 + (8 + (9 +1))))))))' asText.
	self style: aText.

	self assertStyleOf: aText at: 10 shouldBe: #leftParenthesis.
	self assertStyleOf: aText at: 15 shouldBe: #leftParenthesis1.
	self assertStyleOf: aText at: 20 shouldBe: #leftParenthesis2.
	self assertStyleOf: aText at: 25 shouldBe: #leftParenthesis3.
	self assertStyleOf: aText at: 30 shouldBe: #leftParenthesis4.
	self assertStyleOf: aText at: 35 shouldBe: #leftParenthesis5.
	self assertStyleOf: aText at: 40 shouldBe: #leftParenthesis6.
	self assertStyleOf: aText at: 45 shouldBe: #leftParenthesis7.
	self assertStyleOf: aText at: 50 shouldBe: #rightParenthesis7.
	self assertStyleOf: aText at: 51 shouldBe: #rightParenthesis6.
	self assertStyleOf: aText at: 52 shouldBe: #rightParenthesis5.
	self assertStyleOf: aText at: 53 shouldBe: #rightParenthesis4.
	self assertStyleOf: aText at: 54 shouldBe: #rightParenthesis3.
	self assertStyleOf: aText at: 55 shouldBe: #rightParenthesis2.
	self assertStyleOf: aText at: 56 shouldBe: #rightParenthesis1.
	self assertStyleOf: aText at: 57 shouldBe: #rightParenthesis
]

{ #category : #tests }
SHRBStyleAttributionTest >> testPatternArgStyle [

	| aText |
	aText := 'm: arg ^ arg' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 4
		and: 6
		shouldBe: #patternArg
]

{ #category : #tests }
SHRBStyleAttributionTest >> testPatternKeywordStyle [

	| aText |
	SHRBMockTextStyler formatIncompleteIdentifiers: true.
	aText := 'test: arg1 with: arg2  ^ arg1 > arg2' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 1
		and: 5
		shouldBe: #patternKeyword.
	self
		assertStyleOf: aText
		between: 12
		and: 16
		shouldBe: #patternKeyword
]

{ #category : #tests }
SHRBStyleAttributionTest >> testPatternTempVarStyle [

	| aText |
	aText := 'm | a | ^ a' asText.
	self style: aText.

	self assertStyleOf: aText at: 5 shouldBe: #patternTempVar
]

{ #category : #tests }
SHRBStyleAttributionTest >> testPragmaStyle [

	| aText |
	aText := 'm <test> ^ a' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 4
		and: 8
		shouldBe: #pragmaKeyword
]

{ #category : #tests }
SHRBStyleAttributionTest >> testReturnStyle [

	| aText |
	aText := 'm ^ 3' asText.
	self style: aText.

	self
		assertStyleOf: aText
		at: 3
		shouldBe: #return
]

{ #category : #tests }
SHRBStyleAttributionTest >> testSelfStyle [

	| aText |
	aText := 'm self' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 3
		and: 7
		shouldBe: #self
]

{ #category : #tests }
SHRBStyleAttributionTest >> testSharedPoolVarStyle [

	| aText |
	aText := 'm ^ PoolVar' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 11
		shouldBe: #poolConstant
]

{ #category : #tests }
SHRBStyleAttributionTest >> testStatementSeparatorStyle [

	| aText |
	aText := 'm self a. self b' asText.
	self style: aText.

	self assertStyleOf: aText at: 9 shouldBe: #statementSeparator
]

{ #category : #tests }
SHRBStyleAttributionTest >> testStringStyle [

	| aText |
	aText := 'm ^ ''ab''' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 8
		shouldBe: #string
]

{ #category : #tests }
SHRBStyleAttributionTest >> testStringSymbolStyle [

	| aText |
	aText := 'm ^ #''ab''' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 9
		shouldBe: #symbol
]

{ #category : #tests }
SHRBStyleAttributionTest >> testSuperStyle [

	| aText |
	aText := 'm super initialize' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 3
		and: 7
		shouldBe: #super
]

{ #category : #tests }
SHRBStyleAttributionTest >> testSymbolStyle [

	| aText |
	aText := 'm ^ #ab' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 7
		shouldBe: #symbol
]

{ #category : #tests }
SHRBStyleAttributionTest >> testTempVarStyle [

	| aText |
	aText := 'm | a | ^ a' asText.
	self style: aText.

	self assertStyleOf: aText at: 11 shouldBe: #tempVar
]

{ #category : #tests }
SHRBStyleAttributionTest >> testThisContextStyle [

	| aText |
	aText := 'm thisContext senders' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 3
		and: 12
		shouldBe: #thisContext
]

{ #category : #tests }
SHRBStyleAttributionTest >> testTrueStyle [

	| aText |
	aText := 'm true' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 3
		and: 6
		shouldBe: #true
]

{ #category : #tests }
SHRBStyleAttributionTest >> testUnaryStyle [

	| aText |
	aText := 'm self testKeywordStyle' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 8
		and: 23
		shouldBe: #keyword
]

{ #category : #tests }
SHRBStyleAttributionTest >> testUndefinedIdentifierStyle [

	| aText |
	SHRBMockTextStyler formatIncompleteIdentifiers: true.
	aText := 'm ^ toto' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 5
		and: 9
		shouldBe: #undefinedIdentifier
]

{ #category : #tests }
SHRBStyleAttributionTest >> testUndefinedKeywordStyle [

	| aText |
	SHRBMockTextStyler formatIncompleteIdentifiers: true.
	aText := 'm ^ self toto' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 10
		and: 13
		shouldBe: #undefinedKeyword
]

{ #category : #tests }
SHRBStyleAttributionTest >> testUnfinishedCommentStyle [

	| aText |
	aText := 'm "return class ^ SHRBStyleAttributionTest' asText.
	self style: aText.

	self
		assertStyleOf: aText
		between: 3
		and: 42
		shouldBe: #invalid
]