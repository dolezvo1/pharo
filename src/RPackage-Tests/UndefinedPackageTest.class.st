Class {
	#name : 'UndefinedPackageTest',
	#superclass : 'RPackageTestCase',
	#category : 'RPackage-Tests',
	#package : 'RPackage-Tests'
}

{ #category : 'tests' }
UndefinedPackageTest >> testCannotRemoveUndefinedPackage [

	| undefinedPackage |
	undefinedPackage := self undefinedPackage.

	undefinedPackage removeFromSystem.

	self assert: self undefinedPackage isNotNil.
	self assert: self undefinedPackage identicalTo: undefinedPackage
]

{ #category : 'tests' }
UndefinedPackageTest >> testIsUndefined [

	self assert: self undefinedPackage isUndefined.

	self deny: (self ensurePackage: #Package1) isUndefined
]

{ #category : 'tests' }
UndefinedPackageTest >> testName [

	self assert: self undefinedPackage name equals: UndefinedPackage undefinedPackageName
]

{ #category : 'tests' }
UndefinedPackageTest >> undefinedPackage [

	^ self organizer undefinedPackage
]