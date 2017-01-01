//
//  replace.js
//  dendro-install
//
//  Created by João Rocha on 2016-12-22.
//  Copyright 2016 João Rocha. All rights reserved.
// 	Replaces a multiline string with another in a file
//

//newline \u000A

if(!process.argv[2] || !process.argv[3] || !process.argv[4])
{
  process.exit("1");
}

function toUnicode(theString) {
  var unicodeString = '';
  for (var i=0; i < theString.length; i++) {
    var theUnicode = theString.charCodeAt(i).toString(16).toUpperCase();
    while (theUnicode.length < 4) {
      theUnicode = '0' + theUnicode;
    }
    theUnicode = '\\u' + theUnicode;
    unicodeString += theUnicode;
  }
  return unicodeString;
}

function fromUnicode(theString) {
  var finalString='';
  var splitString=theString.split("\\u");

  for (var i=0; i < splitString.length; i++) {
    var unicodeChar = splitString[i]
    var n = parseInt(unicodeChar, 16);
    var char = String.fromCharCode(n);
    finalString+=char;
  }

  return finalString;
}

function replaceCRLFWithLF(theStringInUnicode)
{
	return theStringInUnicode.replace(/\\u000D\\u000A/g , "\\u000A");
}

function replaceLFWithCRLF(theStringInUnicode)
{
	return theStringInUnicode.replace(/\\u000A/g , "\\u000D\\u000A");
}

var old_line=process.argv[2];
old_line=toUnicode(old_line);

var file =process.argv[4];
var fs = require('fs');
var contents = fs.readFileSync(file, 'utf8');
contents=toUnicode(contents);
contents=replaceCRLFWithLF(contents);

var new_line=process.argv[3];
new_line=toUnicode(new_line);

contents=contents.replace(old_line, new_line);
contents=replaceLFWithCRLF(contents);

recovered_contents=fromUnicode(contents);

console.log(recovered_contents);
