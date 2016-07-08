/**
 * Created by hrbu on 07.12.2015.
 */
'use strict';

module.exports = function(vorpal) {

    var init = function(args, done) {
        var self = this;
        var username = args.options.username;
        var password = args.options.password;
        var couchUrl = 'http://' + username + ':' + username + '@' + args.host + ':5984';
        var nano = require('nano')(couchUrl);
        var replicator = require('nano')(couchUrl + '/_replicator');

        var source = 'webpackage-store-' + args.source;
        var target = 'http://' + username + ':' + username + '@localhost:5984/webpackage-store-' +
            args.target;

        // check source
        nano.db.get(source, function(err, body) {
            if (err) {
                done('Source database not found:' + source);
                return;
            }
        });
        // insert replication doc
        replicator.insert({
                _id: args.source + '2' + args.target,
                source: source,
                target: target,
                create_target: true,
                continuous: true
            },
            function(err, body) {
                if (err) {
                    done(err);
                    return;
                }
                done(body);
            });
    };

    vorpal
        .command('replication-init <host> <source> <target>')
        .option('-u, --username', 'User to login and trigger the replication.')
        .option('-p, --password', 'The user\'s password.')
        .option('-v, --verbose', 'Print details.')
        .description(
            'Replication-Manager: Inits a new replication. Example: $ repl-init -u admin -p secret localhost core sandbox ')
        .action(init);

}



