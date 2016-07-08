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
    '#search-api-rootlevel: /' + ' (baseUrl=' + opts.baseUrl + ')',
    function() {
        var apiPath = '_api/webpackgesearch';
        it('get on ' + apiPath + ' should return 200', function(done) {
            var url = urljoin(opts.baseUploadUrl, apiPath);
            console.log('    Requesting url: ', url);
            request
                .get(url)
                .end(function(err, res) {
                    if (err) {
                        done(err);
                    }
                    assert.equal(res.statusCode, 200);
                    done();
                });
        });
    }
)
;
