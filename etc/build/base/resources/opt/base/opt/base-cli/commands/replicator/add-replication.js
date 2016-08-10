/**
 * Created by hrbu on 07.12.2015.
 */
'use strict';
var urlJoin = require('url-join');
const url = require('url');
var uuid = require('node-uuid');
var request = require('superagent');
const querystring = require('querystring');

module.exports = function (vorpal) {

  vorpal
    .command('add-replication <source> <target>')
    .option('-w, --webpackages [optionalList]', 'A comma separated list of webpackageIds: package-a@1.0,package-b@1.1')
    .option('-u, --username <value>', 'This user is allowed to create replication docs.')
    .option('-p, --password <value>', 'The user`s password.')
    .option('-a, --acceptunauthorizedssl [optionalBoolean]', 'Accept unauthorized ssl certs (default=false).')
    .option('-c, --continuous [optionalBoolean]', 'Replicate continuously (default=false).')
    .option('-v, --verbose [optionalBoolean]', 'Print details.')
    .validate(function (args) {
      if (args.options.webpackages) {
        try {
          parseArrayFromWebpackagesOption(args.options.webpackages);
        } catch (err) {
          this.log(err);
          return err.message + '\nExpected value of option "-w" to be an array with at least one item: ["package-a@1.0", "package-b@1.1"]'
        }
      }
      // args.target
      var targetRe = /^[a-z][a-z0-9\_\$()\+\-\/]*$/;
      if(!args.target.match(targetRe)){
        var errorMessage = 'Value for "target" does not match the Regex ' + targetRe;
        process.send(errorMessage);
        return errorMessage;
      }
    })
    .description(
      'Add a new replication. Example: $ add-replication core sandbox -u admin -p secret -d 124lakjsf#234 -c true')
    .action(start);

  function parseArrayFromWebpackagesOption (option) {
    // replace some characters we might receive, but do not need
    var string = option.replace(/\[/g, '');
    string = option.replace(/\]/g, '');
    string = option.replace(/\"/g, '');
    //
    var webpackagesArray = string.split(/\s*,\s*/);
    if (webpackagesArray.length < 1) throw new Error('Empty array.');
    //
    return webpackagesArray
  }

  function start (args, done) {
    var self = this;
    var replicationDocId = uuid.v1();
    var username = args.options.username;
    var password = querystring.escape(args.options.password);
    var continuous = args.options.continuous || false;
    var acceptunauthorizedssl = args.options.acceptunauthorizedssl || false;
    var couchUrl = `http://${username}:${password}@base.coredatastore:5984`;
    var nano = require('nano')(couchUrl);
    var replicator = require('nano')(couchUrl + '/_replicator');

    // source is a url?
    var source = args.source.indexOf('http') == 0 ? args.source : undefined;
    // source is a local store with only the suffix given
    source = (!source && args.source.indexOf('webpackage-store') < 0) ? 'webpackage-store-' + args.source : undefined;
    // source is a local store with the whole database name given
    source = source || args.source;

    // target is expected to receive the suffix only (the public store name)
    var target = 'webpackage-store-' + args.target;

    // format / escape source url
    var sourceUrl = source.indexOf('http') == 0 ? source : urlJoin(couchUrl, source);
    sourceUrl = _escapePassword(sourceUrl);

    // check source
    if(acceptunauthorizedssl) {
      process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";
    }
    request
      .get(sourceUrl)
      .end(function (err, res) {
        if (err) {
          done('Source database not found: ' + sourceUrl + ' | error: ' + JSON.stringify(err));
          return;
        }

        // create replication doc
        var replicationDoc = {
          _id: replicationDocId,
          source: source,
          target: target,
          create_target: true,
          continuous: continuous,
          user_ctx: {
            "roles": [
              "_admin" //this allows to replicate _design-docs as well
            ]
          }
        };
        if (args.options.webpackages) {
          replicationDoc.doc_ids = parseArrayFromWebpackagesOption(args.options.webpackages);
        }

        replicator.insert(replicationDoc,
          function (err, body) {
            if (err) {
              done(err);
              return;
            }
            console.log(body); // this output is expected - do not remove it
            process.send(body);
            done();
          });
      });
  }

  function _escapePassword (url) {
    if (url.indexOf('@') > 0) {
      var password = url.substr(url.lastIndexOf(':') + 1, -1 + url.indexOf('@') - url.lastIndexOf(':'));
      var escapedPassword = querystring.escape(password);
      return url.replace(password, escapedPassword);
    } else {
      return url;
    }
  }
};
