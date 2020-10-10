<?xml version="1.0"?>

<st-source>
<time-stamp>From VisualWorks®, 9.0 of 20. September 2019 on 10. Oktober 2020 at 10:48:28</time-stamp>


<component-created>
<name>CSV</name> <type>package</type>
</component-created><!-- Package CSV(1.0.0.6,chaider)= -->


<component-property>
<name>CSV</name> <type>package</type>
<property>packageName</property> <value>'CSV'</value>
</component-property>

<component-property>
<name>CSV</name> <type>package</type>
<property>notice</property> <value>'The MIT License

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
THE SOFTWARE.'</value>
</component-property>

<component-property>
<name>CSV</name> <type>package</type>
<property>comment</property> <value>'A CSV (comma separated values) reader and writer

The reader reads a table of strings from a CSV file; i.e. an array (rows) of arrays (fields) of strings.

The functionality is extremely bare on purpose. The fancy stuff, like typing columns and automatic conversions is left out and must be handled by the application using this.

Writing:
	CSV writeTable: #(#(''key'' ''name'' ''value'') #(''answer'' ''the'' ''42'')) to: ''file.csv'' asFilename.
Reading:
	CSV tableFromFile: ''file.csv'' asFilename.
	CSV tableVerboselyFromFile: ''file.csv'' asFilename.
	CSV tableFromFile: ''file.csv'' asFilename encoding: #utf8.
	CSV tableFromStream: ''file.csv'' asFilename readStream.
	CSV tableFromStream: ''file.csv'' asFilename readStream separator: $;.'</value>
</component-property>

<class>
<name>CSV</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>readstream fieldSeparator fieldSeparators count </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category></category>
<attributes>
<package>CSV</package>
</attributes>
</class>

<comment>
<class-id>CSV</class-id>
<body>Can read and write a CSV file or stream into/from a table of strings - an array (rows) of arrays (fields) of strings.
</comment>

<methods>
<class-id>CSV class</class-id> <category>examples</category>

<body package="CSV" selector="exampleData">exampleData

<body package="CSV" selector="writeToUTF8File">writeToUTF8File
</methods>

<methods>
<class-id>CSV class</class-id> <category>scratch</category>

<body package="CSV" selector="allEncodingsByCodes">allEncodingsByCodes

<body package="CSV" selector="reEncode:with:as:">reEncode: aFilename with: aSymbol as: aNewFilename
</methods>

<methods>
<class-id>CSV class</class-id> <category>searching encodings</category>

<body package="CSV" selector="encodingTestString">encodingTestString

<body package="CSV" selector="canReadAsUTF8:">canReadAsUTF8: aFilename

<body package="CSV" selector="funnyCodeMessageFor:in:encoding:">funnyCodeMessageFor: aCharacterCode in: aReadStream encoding: anEncodingSymbol

<body package="CSV" selector="findEncodingOf:">findEncodingOf: aFilename

<body package="CSV" selector="codesByEncoding">codesByEncoding

<body package="CSV" selector="unicodeEncodingOf:">unicodeEncodingOf: aFilename
</methods>

<methods>
<class-id>CSV class</class-id> <category>instance creation</category>

<body package="CSV" selector="tableFromString:">tableFromString: aString

<body package="CSV" selector="tableVerboselyFromFile:">tableVerboselyFromFile: aCSVFilename

<body package="CSV" selector="tableFromFile:">tableFromFile: aCSVFilename

<body package="CSV" selector="tableFromStream:">tableFromStream: aReadStream

<body package="CSV" selector="tableFromFile:encoding:">tableFromFile: aCSVFilename encoding: aSymbol

<body package="CSV" selector="tableFromStream:separator:">tableFromStream: aReadStream separator: aCharacter

<body package="CSV" selector="writeTable:to:">writeTable: listOfLinesOfStrings to: aCSVFilename
</methods>


<methods>
<class-id>CSV</class-id> <category>accessing</category>

<body package="CSV" selector="count">count

<body package="CSV" selector="readstream">readstream

<body package="CSV" selector="fieldSeparator">fieldSeparator
</methods>

<methods>
<class-id>CSV</class-id> <category>writing</category>

<body package="CSV" selector="writeLine:on:">writeLine: listOfStrings on: aStream

<body package="CSV" selector="writeTable:on:">writeTable: listOfLinesOfStrings on: aStream

<body package="CSV" selector="writeField:on:">writeField: aString on: aStream

<body package="CSV" selector="writeTable:to:">writeTable: listOfLinesOfStrings to: aCSVFilename

<body package="CSV" selector="writeQuotedField:on:">writeQuotedField: aString on: aStream
</methods>

<methods>
<class-id>CSV</class-id> <category>reading</category>

<body package="CSV" selector="readQuotedFeld">readQuotedFeld

<body package="CSV" selector="readFieldSeparatorFrom:">readFieldSeparatorFrom: aReadStream

<body package="CSV" selector="readTable">readTable

<body package="CSV" selector="readField">readField

<body package="CSV" selector="tableFromStream:">tableFromStream: aReadStream

<body package="CSV" selector="tableFromFile:encoding:">tableFromFile: aCSVFilename encoding: aSymbolOrNil

<body package="CSV" selector="tableFromStream:separator:">tableFromStream: aReadStream separator: aCharacter

<body package="CSV" selector="nextLineFieldStrings">nextLineFieldStrings

<body package="CSV" selector="fieldSeparators">fieldSeparators
</methods>

<methods>
<class-id>CSV</class-id> <category>reporting</category>

<body package="CSV" selector="statisticsWithStartAt:">statisticsWithStartAt: startTimestamp
</methods>



</st-source>