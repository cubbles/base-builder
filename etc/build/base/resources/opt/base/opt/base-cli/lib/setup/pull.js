/**
 * Created by hrbu on 07.12.2015.
 */
'use strict';
var path = require('path');
var composeProxy = require('../shared/compose');
var execCompose = composeProxy.command;

module.exports = function (vorpal) {

  vorpal
    .command('pull')
    .option('-v, --verbose', 'Show details.')
    .description(
      'Stop the Cubbles Base.')
    .action(start);

  function start (args, done) {
    global.command = { args: args };
    var cluster = args.cluster;
    var execConfig = {
      options: '-f docker-compose.yml',
      cluster: cluster,
      command: 'pull',
      commandArgs: '',
      commandExecOptions: {
        cwd: path.join(__dirname, '../../../..', 'etc/docker-compose-config'),
        env: { BASE_CLUSTER: cluster }
      }
    };
    execCompose(execConfig, function (error, stdout, stderr) {
      if (error) {
        console.error('exec error: ', error);
        done(error);
        return
      }
      stdout && console.log('Compose Response:') && console.log(stdout);
      //stderr && console.log('stderr: ', stderr);
    });
  }
};