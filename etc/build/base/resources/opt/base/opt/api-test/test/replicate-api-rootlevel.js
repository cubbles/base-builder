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

describe('#replicate-api-rootlevel: / (url=' + opts.baseUrl + ')', function() {
    var apiPath = '_api/replicate';
    var existingDocId;
    before(function(done) {
        // find any exiting doc via couch to have an exisiting 'existingDocId' for the testcase
        couch
            .db('webpackage-store')
            .action('temp view')
            .send({
                map: function(doc) {
                    if ((doc._id).indexOf('cubx.core') > -1) {
                        return emit(doc.name, null);
                    }
                }
            })
            .end(function(err, res) {
                if(err){
                    done(err);
                    return
                }
                existingDocId = res.rows[0].id;
                done()
            })
    });

    it('should return 200', function(done) {
        var url = urljoin(opts.baseReplicateUrl, apiPath);
        request
            .get(opts.baseUrl)
            .end(function(err, res) {
                assert.equal(res.statusCode, 200);
                done();
            });
    });

    it('should receive existingDocId', function(done) {
        var url = urljoin(opts.baseReplicateUrl, apiPath, existingDocId);
        console.log('    Requesting', url);
        request
            .get(url)
            .end(function(err, res) {
                if (err) {
                    done(err);
                    return;
                }
                assert.equal(res.text.indexOf(existingDocId) > -1, true);
                done();
            });
    });
});
