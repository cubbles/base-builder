'use strict';
var path = require('path');
var exec = require('child_process').exec;

module.exports = new Compose();

function Compose () {
}

Compose.prototype.command = function (composeConfig, callback) {
  var command = getCommand(composeConfig.options, composeConfig.cluster, composeConfig.command, composeConfig.commandArgs);
  (global.command.args.options.verbose) && console.log('VERBOSE: command: %s', command);
  exec(command, composeConfig.commandExecOptions, callback)
};

/*
 #########################################################
 */

// function getCommand (composeOptions, cluster, command, commandArgs, envVariables) {
//   var envString = '';
//   if (envVariables) {
//     for (var envVar in envVariables) {
//       envString += ' -e ' + envVar + '=' + (envVariables[ envVar ]);
//     }
//   }
//   var commandString = (composeOptions ? ' ' + composeOptions : '');
//   commandString += (cluster ? ' --project-name ' + cluster : '');
//   commandString += ((global.command.args.options.verbose && ( composeOptions === undefined || composeOptions.indexOf('--verbose') < 0)) ? ' --verbose' : '');
//   commandString += ' ' + command;
//   commandString += (commandArgs ? ' ' + commandArgs : '');
//
//   // use docker image for docker-compose
//   return 'docker run --rm -v "$(pwd)":"$(pwd)" -v /var/run/docker.sock:/var/run/docker.sock -e COMPOSE_PROJECT_NAME=' + cluster + envString + ' --workdir="$(pwd)" dduportal/docker-compose:1.7.1 ' + commandString;
//   //return 'docker run --rm  -v "$(pwd)":"$(pwd)" -v /var/run/docker.sock:/var/run/docker.sock -e COMPOSE_PROJECT_NAME=$(basename "$(pwd)") --workdir="$(pwd)" dduportal/docker-compose:latest ' + commandString;
// }

function getCommand (composeOptions, cluster, command, commandArgs) {

  var commandString = '';
  commandString += (composeOptions ? ' ' + composeOptions : '');
  commandString += (cluster ? ' --project-name cubbles-base.' + cluster : '');
  commandString += ((global.command.args.options.verbose && ( composeOptions === undefined || composeOptions.indexOf('--verbose') < 0)) ? ' --verbose' : '');
  commandString += ' ' + command;
  commandString += (commandArgs ? ' ' + commandArgs : '');

  return 'docker-compose ' + commandString;
}
