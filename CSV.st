'From VisualWorks®, 9.0 of 20. September 2019 on 10. Oktober 2020 at 10:56:28'!


CodeComponent create: #package named: 'CSV'!"Package CSV(1.0.0.6,chaider)="!


CodeComponent type: #package named: 'CSV' property: #packageName value: 'CSV'!

CodeComponent type: #package named: 'CSV' property: #notice value: 'The MIT License

Copyright © 2020 Christian Haider

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.'!

CodeComponent type: #package named: 'CSV' property: #comment value: 'A CSV (comma separated values) reader and writer

The reader reads a table of strings from a CSV file; i.e. an array (rows) of arrays (fields) of strings.

The functionality is extremely bare on purpose. The fancy stuff, like typing columns and automatic conversions is left out and must be handled by the application using this.

Writing:
	CSV writeTable: #(#(''key'' ''name'' ''value'') #(''answer'' ''the'' ''42'')) to: ''file.csv'' asFilename.
Reading:
	CSV tableFromFile: ''file.csv'' asFilename.
	CSV tableVerboselyFromFile: ''file.csv'' asFilename.
	CSV tableFromFile: ''file.csv'' asFilename encoding: #utf8.
	CSV tableFromStream: ''file.csv'' asFilename readStream.
	CSV tableFromStream: ''file.csv'' asFilename readStream separator: $;.'!

Smalltalk defineClass: #CSV
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'readstream fieldSeparator fieldSeparators count '
	classInstanceVariableNames: ''
	imports: ''
	category: ''!

CSV comment:
'Can read and write a CSV file or stream into/from a table of strings - an array (rows) of arrays (fields) of strings.

When reading a file, the field separator character is automatically detected by searching for the first semicolon ($;), comma ($,) or tab. Whichever occurs first is used as field separator.
This will fail when another character was used as separator or when there is some text before the table. In this case you can use CSV class>>#tableFromStream:separator: to set it explicitly.

Quoted fields (enclosed by doublequote ($")) are read according to the https://tools.ietf.org/html/rfc4180.

For writing, the semicolon ($;) is used as field separator. Any field string including the separator, a quote ($") or a line break are quoted as described in the https://tools.ietf.org/html/rfc4180.

The class method #findEncodingOf: tries to find the right encoding automatically. 
This is not used by default, because it needs to be adapted the targeted language of the files to read. The default code uses German umlauts to find an encoding.
See the class methods in the protocol ''searching encodings''.

'!

!CSV class methodsFor: 'examples'!

exampleData
	^#( #('' 'Name' 'abc"xyz' 'a, b; c	d')
		 #('€20.3' 'à bientôt' 'schön' 'Knækbrød')
		 #('φορές' 'pożegnać' 'довиждане' 'normal'))!

writeToUTF8File
	"CSV writeToUTF8File"
	"CSV tableFromFile: 'exampleUTF8.csv' asFilename encoding: #utf8"
	
	self writeTable: self exampleData to: ('exampleUTF8.csv' asFilename withEncoding: #utf8)! !

!CSV class methodsFor: 'scratch'!

allEncodingsByCodes
	"<Dictionary key: ByteArray value: (Set of: Symbol)>
	used for development to get all encoding with the same codes for the special chars"
	"CSV allEncodingsByCodes"

	| specialChars namesAtBytes |
	specialChars := self encodingTestString.
	namesAtBytes := Dictionary new.
	StreamEncoder encoderDirectory keys do: [:symbol |
		| byteArray |
		byteArray := [specialChars asByteArrayEncoding: symbol] on: UnsupportedCharacterError , ImproperStoreError do: [:ex |
			ex return: nil].
		(byteArray notNil and: [
		byteArray size = specialChars size]) ifTrue: [
				(namesAtBytes at: byteArray ifAbsentPut: [Set new]) add: symbol]].
	^namesAtBytes!

reEncode: aFilename with: aSymbol as: aNewFilename
	"reads aFilename with encoding aSymbol and writes it with UTF8 encoding"

	| rst wst |
	rst := (aFilename withEncoding: aSymbol) readStream.
	wst := (aNewFilename withEncoding: #UTF8) writeStream.
	[[rst atEnd] whileFalse: [wst nextPut: rst next asInteger]] ensure: [
		wst close.
		rst close]! !

!CSV class methodsFor: 'searching encodings'!

encodingTestString
	"<String>
	Non-ASCII characters occuring in the targeted files.
	Default is for German (my use case)"
	
	^'äöüÄÖÜß§'!

canReadAsUTF8: aFilename
	"<Boolean>
	true, iff no illegal character is read;
	false, otherwise"

	| illegalCharacter rst |
	illegalCharacter := Character illegalCode asCharacter.
	rst := (aFilename withEncoding: #UTF8) readStream.
	[
	[rst atEnd] whileFalse: [
		rst next = illegalCharacter ifTrue: [
			^false]]] ensure: [
			rst close].
	^true!

funnyCodeMessageFor: aCharacterCode in: aReadStream encoding: anEncodingSymbol
	"<String>"

	| before wst found pos after |
	pos := aReadStream position.
	before := (pos > 10
		ifTrue: [
		aReadStream skip: -11.
		aReadStream next: 10]
		ifFalse: [
		aReadStream skip: pos negated.
		aReadStream next: pos]) asByteString.
	aReadStream position: pos.
	after := (aReadStream next: 10) asByteString.
	aReadStream position: pos.
	found := before , '_' , (ByteString with: aCharacterCode asCharacter) , '_' , after.
	wst := String new writeStream.
	wst
		nextPutAll: 'Funny character ';
		nextPutAll: ((StreamEncoder new: anEncodingSymbol) encoder decode: aCharacterCode) printString;
		nextPutAll: ' found in ';
		nextPutAll: (found asByteArrayEncoding: anEncodingSymbol) asByteString printString;
		nextPutAll: ' encoded as ';
		nextPutAll: aCharacterCode printString;
		nextPutAll: ' in encoding ';
		nextPutAll: anEncodingSymbol printString;
		nextPutAll: ' at position ';
		nextPutAll: aReadStream position printString.
	^wst contents!

findEncodingOf: aFilename
	"<Symbol | nil>
	tries to derrive the encoding from the contents.
	Only applicable to files with German words, since only German umlauts are tested.
	Needs to be adapted for other languages to test for local characters occuring in the file."

	| rst codesByEncoding seenCodes possibleEncodings |
	(self unicodeEncodingOf: aFilename) ifNotNil: [:symbol |
		^symbol].
	(self canReadAsUTF8: aFilename) ifTrue: [
		^#UTF8].
	codesByEncoding := self codesByEncoding.
	seenCodes := Set new.
	possibleEncodings := codesByEncoding keys asSet.
	rst := aFilename readStream binary.
	[
	[rst atEnd] whileFalse: [
		| code |
		code := rst next.
		code > 127 ifTrue: [
			(seenCodes includes: code) ifFalse: [
				seenCodes add: code.
				possibleEncodings copy do: [:symbol |
					((codesByEncoding at: symbol) includes: code) ifFalse: [
						possibleEncodings remove: symbol.
						possibleEncodings isEmpty ifTrue: [
							self error: (self funnyCodeMessageFor: code in: rst encoding: symbol)]]]]]]] ensure: [
			rst close].
	possibleEncodings isEmpty ifTrue: [
		^nil].
	possibleEncodings size = 1 ifTrue: [
		^possibleEncodings any].
	self error: 'several matching encodings found: ' , possibleEncodings asArray printString!

codesByEncoding
	"<Dictionary key: Symbol value: ByteArray>"
	"CSV codesByEncoding"

	^#(#iso8859_1 #cp850 #macroman #hp_roman8) inject: Dictionary new into: [:dict :symbol |
		dict at: symbol put: (self encodingTestString asByteArrayEncoding: symbol).
		dict]!

unicodeEncodingOf: aFilename
	"<Symbol | nil>
	return the unicode encoding based on the markers;
	nil if no markers are found.
	VW does not support UTF 32 encoding"

	| rst first2 |
	rst := aFilename readStream binary.
	[
	first2 := rst next: 2.
	(first2 = #(16rEF 16rBB) and: [
	rst peek = 16rBF]) ifTrue: [
			^#UTF8].
	first2 = #(16rFE 16rFF) ifTrue: [
		^#utf16BE].
	first2 = #(16rFF 16rFE) ifTrue: [
		^(rst next: 2) = #(0 0)
			ifTrue: [#utf32LE]
			ifFalse: [#utf16LE]].
	(first2 = #(0 0) and: [
	(rst next: 2) = #(16rFE 16rFF)]) ifTrue: [
			^#utf32BE]] ensure: [
			rst close].
	^nil! !

!CSV class methodsFor: 'instance creation'!

tableFromString: aString
	"<SequenceableCollection of: (SequenceableCollection of: String)>
	useful for tests"

	^self tableFromStream: aString readStream!

tableVerboselyFromFile: aCSVFilename
	"<SequenceableCollection of: (SequenceableCollection of: String)>
	Prints statistics on the Transcript"

	| inst table start |
	Transcript
		cr;
		show: 'reading ' , aCSVFilename tail, ' : ';
		flush.
	start := Timestamp now.
	inst := self new.
	table := inst tableFromFile: aCSVFilename encoding: nil.
	Transcript
		show: (inst statisticsWithStartAt: start);
		flush.
	^table!

tableFromFile: aCSVFilename
	"<SequenceableCollection of: (SequenceableCollection of: String)>
	Read a CSV file and return all lines with fields as strings.
	No encoding is applied"

	^self new tableFromFile: aCSVFilename encoding: nil!

tableFromStream: aReadStream
	"<SequenceableCollection of: (SequenceableCollection of: String)>
	Read aReadStream and return all lines with fields as strings"

	^self new tableFromStream: aReadStream!

tableFromFile: aCSVFilename encoding: aSymbol
	"<SequenceableCollection of: (SequenceableCollection of: String)>
	Read a CSV file and return all lines with fields as strings"

	^self new tableFromFile: aCSVFilename encoding: aSymbol!

tableFromStream: aReadStream separator: aCharacter
	"<SequenceableCollection of: (SequenceableCollection of: String)>
	Read aReadStream and return all lines with fields as strings.
	This variant is useful when the field separator cannot easily be determined (because there may be text before the table)"

	^self new tableFromStream: aReadStream separator: aCharacter!

writeTable: listOfLinesOfStrings to: aCSVFilename
	"Writes a CSV file"

	^self new writeTable: listOfLinesOfStrings to: aCSVFilename! !


!CSV methodsFor: 'accessing'!

count
	"<Integer>
	the number of lines read or written"

	^count ifNil: [0]!

readstream
	^readstream!

fieldSeparator
	"<Character>"

	^fieldSeparator! !

!CSV methodsFor: 'writing'!

writeLine: listOfStrings on: aStream
	listOfStrings do: [:string | self writeField: string on: aStream] separatedBy: [
		aStream nextPut: $;].
	count := self count + 1!

writeTable: listOfLinesOfStrings on: aStream
	| start |
	start := Timestamp now.
	[
	listOfLinesOfStrings do: [:strings | self writeLine: strings on: aStream] separatedBy: [
		aStream cr]] ensure: [
			aStream close].
	Transcript
		show: ': ' , (self statisticsWithStartAt: start);
		flush!

writeField: aString on: aStream
	(aString anySatisfy: [:char |
		'
";' includes: char]) ifTrue: [
			^self writeQuotedField: aString on: aStream].
	aStream nextPutAll: aString!

writeTable: listOfLinesOfStrings to: aCSVFilename
	"Writes a CSV file"

	Transcript
		cr;
		show: 'writing ' , aCSVFilename printString;
		flush.
	self writeTable: listOfLinesOfStrings on: aCSVFilename writeStream!

writeQuotedField: aString on: aStream
	aStream nextPut: $".
	aString do: [:char |
		char = $" ifTrue: [
			aStream nextPut: $"].
		aStream nextPut: char].
	aStream nextPut: $"! !

!CSV methodsFor: 'reading'!

readQuotedFeld
	"<String>"

	| wst |
	wst := String new writeStream.
	[self readstream peek = $"] whileTrue: [
		self readstream next.
		wst nextPutAll: (self readstream upTo: $").
		self readstream peek = $" ifTrue: [
			wst nextPut: $"]].
	^wst contents!

readFieldSeparatorFrom: aReadStream
	"<Character | nil>
	resets the stream"

	[aReadStream atEnd] whileFalse: [
		| char |
		char := aReadStream next.
		(';,	' includes: char) ifTrue: [
			aReadStream reset.
			^char]].
	aReadStream reset.
	^nil!

readTable
	"<SequenceableCollection of: (SequenceableCollection of: String)>"

	| lines |
	lines := OrderedCollection new.
	[self readstream atEnd] whileFalse: [
		| strings |
		strings := self nextLineFieldStrings collect: [:string |
			string trimBlanks reject: [:character | character = Character cr]].
		(strings allSatisfy: #isEmpty) ifFalse: [
			lines add: strings]].
	^lines!

readField
	"<String>
	read a string up to separator or CR, but leave it in the stream
	respect quotes according to https://tools.ietf.org/html/rfc4180 "

	| wst |
	self readstream peek = $" ifTrue: [
		^self readQuotedFeld].
	wst := String new writeStream.
	[self readstream atEnd] whileFalse: [
		(self fieldSeparators includes: self readstream peek) ifTrue: [
			^wst contents].
		wst nextPut: self readstream next].
	^wst contents!

tableFromStream: aReadStream
	"<SequenceableCollection of: (SequenceableCollection of: String)>"

	^self tableFromStream: aReadStream separator: (self readFieldSeparatorFrom: aReadStream)!

tableFromFile: aCSVFilename encoding: aSymbolOrNil
	"<SequenceableCollection of: (SequenceableCollection of: String)>"

	| stream |
	aCSVFilename asString isEmpty ifTrue: [
		^#()].
	stream := (aSymbolOrNil ifNil: [aCSVFilename] ifNotNil: [
		aCSVFilename withEncoding: aSymbolOrNil]) readStream.
	stream lineEndAuto.
	^self tableFromStream: stream!

tableFromStream: aReadStream separator: aCharacter
	"<SequenceableCollection of: (SequenceableCollection of: String)>"

	readstream := aReadStream.
	^[
	fieldSeparator := aCharacter.
	self readTable] ensure: [
			self readstream close.
			readstream := nil]!

nextLineFieldStrings
	"<Array on: String>"

	| fields |
	fields := OrderedCollection with: self readField.
	[self readstream atEnd not and: [self readstream next = self fieldSeparator]]
		whileTrue: [fields add: self readField].
	count := self count + 1.
	^fields asArray!

fieldSeparators
	^fieldSeparators ifNil: [
		fieldSeparators := Array
			with: self fieldSeparator
			with: Character cr
			with: Character lf]! !

!CSV methodsFor: 'reporting'!

statisticsWithStartAt: startTimestamp
	"<String>"

	^self count printString , ' Lines in ' , (Timestamp now - startTimestamp) printString! !

