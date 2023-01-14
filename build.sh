#!/bin/bash

npx react-native bundle --platform ios --config metro.common.config.js --dev false --entry-file common.js --bundle-output bundle/common.ios.jsbundle --assets-dest bundle
npx react-native bundle --platform ios --config metro.config.js --dev false --entry-file index.A.js --bundle-output bundle/businessA.ios.jsbundle --assets-dest bundle
npx react-native bundle --platform ios --config metro.config.js --dev false --entry-file index.B.js --bundle-output bundle/businessB.ios.jsbundle --assets-dest bundle

# delete unnecessary require definition
sed -i '' -e '2d' bundle/businessA.ios.jsbundle
sed -i '' -e '2d' bundle/businessB.ios.jsbundle

