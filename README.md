# CSV
A CSV (comma separated values) reader and writer

The reader reads a table of strings from a CSV file; i.e. an array (rows) of arrays (fields) of strings.

The functionality is extremely bare on purpose. The fancy stuff, like typing columns and automatic conversions is left out and must be handled by the application using this.

Writing:
```smalltalk
	CSV writeTable: #(#('key' 'name' 'value') #('answer' 'the' '42')) to: 'file.csv' asFilename.
```
Reading:
```smalltalk
	CSV tableFromFile: 'file.csv' asFilename.
	CSV tableVerboselyFromFile: 'file.csv' asFilename.
	CSV tableFromFile: 'file.csv' asFilename encoding: #utf8.
	CSV tableFromStream: 'file.csv' asFilename readStream.
	CSV tableFromStream: 'file.csv' asFilename readStream separator: $;.
```
