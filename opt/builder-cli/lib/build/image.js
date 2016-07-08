/**
 * Created by hrbu on 07.12.2015.
 */
'use strict';
var path = require('path');
var fs = require('fs');
var mkdirp = require('mkdirp');
var dateFormat = require('dateformat');
var composeProxy = require('../shared/compose');
var execCompose = composeProxy.command;
var exec = require('child_process').exec;

module.exports = function (vorpal) {

  vorpal
    .command('build <service>')
    .option('-t, --tag', 'pass a tag for the image')
    .option('-v, --verbose', 'Show details.')
    .types({
      string: [ 't', 'tag' ]
    })
    .description('Build an image.')
    .action(build);

  function build (args, done) {
    global.command = { args: args };
    var composeEnv = process.env;
    var config = {
      options: '-f docker-compose.yml',
      command: 'build',
      commandArgs: args.service,
      commandExecOptions: {
        cwd: path.join(__dirname, '../../../..', 'etc/build'),
        env: composeEnv
      },
      envVariables: {}
    };
    /*
     * build image
     */
    execCompose(config, function (error, stdout, stderr) {
      if (error) {
        console.error('exec error: ', error);
        writeLogfile({ content: error, service: args.service }, done);
        return
      }
      stdout && console.log(stdout);
      writeLogfile({ content: stdout, service: args.service }, done, function () {
        var imageQName = 'cubbles/' + args.service;
        if (args.options.tag) {
          /*
           * tag image
           */
          var taggedImageQName = imageQName + ':' + args.options.tag;
          exec('docker tag ' + imageQName + ':latest ' + taggedImageQName, {}, function (error, stdout, stderr) {
            if (error) {
              console.error('exec error: ', error);
              return
            }
            console.log('\n Image "%s" successfully created.\n', taggedImageQName);
            stdout && console.log(stdout);
          });
        } else {
          console.log('\n Image "%s:latest" successfully created.\n', imageQName);
        }
      })
    });
  }

  function writeLogfile (logObject, onError, onSuccess) {
    var logFolder = path.join(__dirname, '../../../../', 'var/log');
    var logFile = path.join(logFolder, 'build_' + logObject.service + '-' + dateFormat(new Date(), "yyyymmdd'T'hh-MM-ss'Z'") + '.log');
    mkdirp(logFolder, function (err) {
      if (err) {
        console.error('ERROR: Failed to create folder "%s"', logFolder);
        console.error(err);
        onError(err)
      } else {
        console.info('For the whole output see \n "%s"', logFile);
        console.info('-----------');
        fs.writeFileSync(logFile, logObject.content);
        onSuccess && onSuccess()
      }
    })
  }
};
