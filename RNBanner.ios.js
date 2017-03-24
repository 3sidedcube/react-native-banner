/**
 * @providesModule RNBanner
 * @flow
 */
'use strict';

import { processColor } from "react-native";

var NativeRNBanner = require('NativeModules').RNBanner;

function _processProperties(properties) {
  for (var property in properties) {
    if (properties.hasOwnProperty(property)) {
      if (property === 'icon' || property.endsWith('Icon') || property.endsWith('Image')) {
        properties[property] = resolveAssetSource(properties[property]);
      }
      if (property === 'color' || property.endsWith('Color')) {
        properties[property] = processColor(properties[property]);
      }
    }
  }
}

/**
 * High-level docs for the RNBanner iOS API can be written here.
 */
export default {
	show: (title, subtitle, config) => {

		let nativeConfig = {
			...config
		}
		_processProperties(nativeConfig);
		NativeRNBanner.showToastWithTitle(title, subtitle, nativeConfig);
	},
}
