/**
 * @providesModule RNBanner
 * @flow
 */
'use strict';

import { processColor } from "react-native";

var NativeRNBanner = require('NativeModules').RNBanner;

/**
 * High-level docs for the RNBanner iOS API can be written here.
 */

export default {
	show: (title, subtitle, config) => {

		let nativeConfig = {
			...config
		}

		if (nativeConfig.backgroundColor) {
			nativeConfig.backgroundColor = processColor(nativeConfig.backgroundColor)
		}

		NativeRNBanner.showToastWithTitle(title, subtitle, nativeConfig);
	},
}
