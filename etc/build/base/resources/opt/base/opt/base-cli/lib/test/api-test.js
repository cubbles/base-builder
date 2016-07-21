/**
 * Created by hrbu on 07.12.2015.
 */
'use strict';
var path = require('path');
var fs = require('fs');
var exec = require('child_process').exec;
var composeProxy = require('../shared/compose');
var execCompose = composeProxy.command;

/*
 *
 */
module.exports = function (vorpal) {

  vorpal
    .command('api-test <cluster>')
    .option('-v, --verbose', 'Show details.')
    .description('Run the API-Test')
    .action(start);

  function start (args, done) {
    global.command = { args: args };
    var cluster = args.cluster;
    var service = 'base.testsuite';
    var command = '"sh -c \'cd /opt/testsuite && node test-cli api-test\'"';
    var commandArgs = '--rm --entrypoint ' + command + ' ' + service;

    var execConfig = {
      options: '-f docker-compose.yml -f docker-compose-' + cluster + '.yml',
      cluster: cluster,
      command: 'run',
      commandArgs: commandArgs,
      commandExecOptions: {
        cwd: path.join(__dirname, '../../../..', 'etc/docker-compose-config'),
        env: {
          BASE_CLUSTER: cluster,
          BASE_AUTH_DATASTORE_ADMINCREDENTIALS: 'admin:admin'
        }
      }
    };

    execCompose(execConfig, function (error, stdout, stderr) {
      if (error) {
        console.error('exec error: ', error);
        done(error);
        return
      }
      stdout && console.log(stdout);
      // stderr && console.log('stderr: ', stderr);
      done()
    });
  }
};
