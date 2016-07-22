/**
 * Created by hrbu on 07.12.2015.
 */
'use strict';
var path = require('path');
var Mocha = require('mocha');

module.exports = function (vorpal) {

  vorpal
    .command('api-test')
    .description('Test the Base API`s. Requires the Base to be up.')
    .action(start);

  function start (args, done) {
    // global.command = { args: args };
    // var cluster = args.cluster;

    /*
     Run mocha tests.
     @see https://github.com/mochajs/mocha/wiki/Using-mocha-programmatically
     */
    // Instantiate a Mocha instance.
    var mocha = new Mocha({});
    mocha.addFile('api-test/test/_mocha-global-hooks.js');
    mocha.addFile('api-test/test/authentication-api.js');
    mocha.addFile('api-test/test/download-api-storelevel.js');
    mocha.addFile('api-test/test/replicate-api-storelevel.js');
    mocha.addFile('api-test/test/search-api-storelevel.js');
    mocha.addFile('api-test/test/upload-api-storelevel.js');
    mocha.addFile('api-test/test/upload-api-storelevelWithCookie.js');

    var resultLog = '';
    var failedLog = '';
    console.log("Testsuite: Running tests ...");

    /*
     * @see https://github.com/mochajs/mocha/blob/master/lib/runner.js#L41
     */
    mocha.run(function (failures) {
      process.on('exit', function () {
        resultLog += '\n' + 'Failures: ' + failures;
        console.log(resultLog);
        console.log(failedLog);
        done();  // exit with non-zero status if there were failures
      })
    })
      .on('start', function () {
        resultLog += '\n\n' + '================';
        resultLog += '\n' + 'Test result:';
        resultLog += '\n' + '================';
      })
      .on('suite', function (suite) {
        resultLog += '\n\n' + '>>> ';
        resultLog += 'Suite started: ' + suite.title;
      })
      .on('suite end', function (suite) {
        if (suite.title) {
          resultLog += '\n' + '<<< ';
          resultLog += 'Suite finished: ' + suite.title;
        }
      })
      .on('test', function (test) {
        resultLog += '\n' + ' ---';
        resultLog += '\n' + ' Test started: ' + test.title;
      })
      .on('test end', function (test) {
        resultLog += '\n' + ' Test finished: ' + test.title;
        resultLog += '\n' + ' ---';
      })
      .on('pass', function (test) {
        resultLog += '\n' + ' Passed.';
      })
      .on('fail', function (test, err) {
        resultLog += '\n' + ' FAILED!';
        failedLog += '\n' + 'Test failed: ' + test.title;
        failedLog += '\n' + JSON.stringify(err);
      })
      .on('end', function () {
        resultLog += '\n' + '================';
        resultLog += '\n' + 'All tests done.';
      });
  }
};
