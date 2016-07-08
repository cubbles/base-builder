/**
 * Created by hrbu on 24.11.2015.
 */
'use strict';
var urljoin = require('url-join');
var assert = require('assert');
var request = require('superagent');
var opts = require('../lib/opts.js');
var supercouch = require('supercouch');
var couch = supercouch(opts.couchUrl);

/**
 * expects to have a boot2docker-instance running
 */

describe(
    '#replicate-api-storelevel: /' + opts.storeName + ' (baseUrl=' + opts.baseUrl + ')',
    function() {
        var apiPath = '_api/replicate';
        it('should return 200', function(done) {
            var url = urljoin(opts.baseReplicateUrl, opts.storeName, apiPath);
            request
                .get(url)
                .end(function(err, res) {
                    assert.equal(res.statusCode, 200);
                    assert.equal(res.text.indexOf('db_name') > -1, true);
                    done();
                });
        });

        it('should receive "pack@1.0.0"', function(done) {
            var docId = 'pack@1.0.0';
            var url = urljoin(opts.baseReplicateUrl, opts.storeName, apiPath, docId);
            console.log('    Requesting', url);
            request
                .get(url)
                .end(function(err, res) {
                    console.log('    StatusCode', res.statusCode);
                    if (err) {
                        done(err);
                        return
                    }
                    assert.equal(res.text.indexOf(docId) > -1, true);
                    done();
                });
        });
    });
