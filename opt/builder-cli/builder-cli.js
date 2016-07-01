/**
 * Created by hrbu on 07.12.2015.
 */
'use strict';
var path = require('path');
var vorpal = require('vorpal')();

//load commands
require('./lib/build/image.js')(vorpal);

var args = cleanArgs(__filename, JSON.parse(JSON.stringify(process.argv)));
if (process.argv.indexOf('-i') > -1) {
  vorpal
    .delimiter('builder-cli$')
    .show()
    .parse(args)
} else {
  vorpal
    .parse(args);
  //
  if (args.length === 0) {
    console.log('Note: Use the option "-i" to run the interactive mode.')
  }
}

/**
 * If this is called from a shell-script, the first argument is the filename.
 * If so, the argument will be removed.
 *
 * @param filename
 * @param processArgv
 * @return {Array}
 */
function cleanArgs (filename, processArgv) {
  var args = processArgv;
  var filenameWithoutExtension = filename.slice(filename.lastIndexOf(path.sep) + 1, filename.length - 3);
  var fileNameIndex = args.indexOf(filenameWithoutExtension);
  fileNameIndex > -1 && args.splice(fileNameIndex, 1);
  //
  var iIndex = args.indexOf('-i');
  iIndex > -1 && args.splice(iIndex, 1);
  //
  //console.log(args)
  if (args.length === 2) {
    args.push('help')
  }
  return args;
}

