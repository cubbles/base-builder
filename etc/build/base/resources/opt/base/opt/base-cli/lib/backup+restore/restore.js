/**
 * Created by hrbu on 07.12.2015.
 */
'use strict';
var path = require('path');
var fs = require('fs');
var exec = require('child_process').exec;
var Promise = require('promise');
var composeProxy = require('../shared/compose');
var execCompose = composeProxy.command;

// for dev only
require('promise/lib/rejection-tracking').enable(
  { allRejections: true }
);

/*
 * Important:
 * ----------
 * Running a restore, requires
 * 1) the 'cubbles/base' container mounted with the 'cubbles/base.coredatastore' volumes.
 *    This is expected as we want to replace the couchdb db files within the container.
 * 2) the 'cubbles/base' container mounted with a folder containing the backupFile to the 'backups' folder.
 *    The script expects the passed backupFile within this folder (inside the container).
 */
module.exports = function (vorpal) {
  var backupFolder = '/backups';

  vorpal
    .command('restore <cluster> <backupFile>')
    .option('-v, --verbose', 'Show details.')
    .description(
      'Restore the coredatastore with the given backupFile.')
    .action(
      function (args, done) {
        // Does 'backupFile' exist?
        if (!fs.existsSync(backupFolder + '/' + args.backupFile) || !fs.lstatSync(backupFolder + '/' + args.backupFile).isFile()) {
          console.error('CANCELED: Passed file "%s" does NOT exist in folder "%s" or is NOT a file.', args.backupFile, backupFolder);
          done();
          return
        }
        // If yes, go on ..
        global.command = { args: args };
        compose('stop base.coredatastore', args)
          .then(function (fulfillmentValue) {return restore(args.cluster, args.backupFile)})
          .then(function (fulfillmentValue) {return compose('start base.coredatastore', args)})
          .catch(function (rejectValue) {
            console.log('Restore failed: %s', rejectValue);
            compose('start base.coredatastore', args);
          })
      }
    );

  /**
   *
   * @param cluster
   * @param sourceFilename
   */
  function restore (cluster, sourceFilename) {
    return new Promise(
      function (resolve, reject) {
        console.log(' > Restoring data');
        /*
         1) clean the /usr/local/var/lib/couchdb folder
         2) extract the selected backup into the target folder.
         */
        var couchdbFolder = '/usr/local/var/lib/couchdb';
        var cleanCouchdbFolder = 'cd ' + couchdbFolder + ' && rm -r *';
        var extractBackup = 'cd / && tar xfz ' + backupFolder + '/' + sourceFilename + ' --same-owner --preserve-permissions';

        var execCommand = 'cd / && echo && echo "OLD directory content:" && ls -la ' + couchdbFolder + ' && ' + cleanCouchdbFolder + ' && ' + extractBackup + ' && echo && echo "NEW directory content:" && cd / && ls -la ' + couchdbFolder;
        console.log('Executing command: ', execCommand);
        exec(execCommand, {}, function (error, stdout, stderr) {
          //exec('ls', commandExecOptions, function (error, stdout, stderr) {
          if (error) {
            //console.error('exec error: ', error);
            reject(error);
            return
          }
          stdout && console.log(stdout);
          //stderr && console.log('stderr: ', stderr);
          resolve()
        })
      }
    )
  }
};

/**
 *
 * @param composeCommand
 * @param args
 * @return {Promise}
 */
function compose (composeCommand, args) {
  console.log(' > %s', composeCommand);
  global.command = { args: args };
  var cluster = args.cluster;
  var composeEnv = process.env;
  var composeConfig = {
    options: '-f docker-compose.yml -f docker-compose-' + cluster + '.yml',
    cluster: cluster,
    command: composeCommand,
    commandArgs: '',
    commandExecOptions: {
      cwd: path.join(__dirname, '../../../..', 'etc/docker-compose-config'),
      env: composeEnv
    },
    envVariables: { BASE_CLUSTER: cluster }
  };
  return new Promise(
    function (resolve, reject) {
      execCompose(composeConfig, function (error, stdout, stderr) {
        if (error) {
          console.error('!!!' + composeCommand + 'exec error: ', error);
          reject(error);
          return
        }
        stdout && console.log('stdout: %s', stdout);
        //stderr && console.log('stderr: >> %s <<', stderr);
        console.log(' > %s (Done)', composeCommand);
        resolve(stdout);
      });
    }
  )
}