/**
 * Created by hrbu on 24.11.2015.
 */
'use strict';
var urljoin = require('url-join');
var assert = require('assert');
var request = require('superagent');
var supercouch = require('supercouch');
var opts = require('../lib/opts.js');

/**
 * expects to have a boot2docker-instance running
 */

describe(
    '#upload-api-rootlevel: /' + ' (baseUrl=' + opts.baseUrl + ')',
    function() {
        var uploadApiPath = '_api/upload';
        it('get on ' + uploadApiPath + ' should return 200', function(done) {
            var url = urljoin(opts.baseUploadUrl, uploadApiPath);
            request
                .get(url)
                .end(function(err, res) {
                    if (err) {
                        done(err);
                        return;
                    }
                    assert.equal(res.statusCode, 200);
                    done();
                });
        });

        it('should PUT new document "pack-upload-put-[random]@1.0.0"', function(done) {
            var docId = 'pack-upload-put-' + Math.floor(Math.random() * 1000000) + '@1.0.0';
            var doc = {foo: 'bar'};
            var url = urljoin(opts.baseUploadUrl, uploadApiPath, docId);
            console.log('    Creating document: ', url);
            request
                .put(url)
                .send(doc)
                .end(function(err, res) {
                    if (err) {
                        console.log('    failed', err);
                        return done(err);
                    }
                    done();
                });
        });
    }
)
;
