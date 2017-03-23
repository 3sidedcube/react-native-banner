/**
 * @providesModule RNBanner
 * @flow
 */
'use strict';

var NativeRNBanner = require('NativeModules').RNBanner;

/**
 * High-level docs for the RNBanner iOS API can be written here.
 */

var RNBanner = {
  test: function() {
    NativeRNBanner.test();
  }
};

module.exports = RNBanner;
