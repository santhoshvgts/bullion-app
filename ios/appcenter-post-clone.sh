#!/usr/bin/env bash
#Place this script in project/ios/

# fail if any command fails
set -e
# debug log
set -x

cd ..

# set to stable branch unless specified
FLUTTER_VERSION=${FLUTTER_VERSION:-stable}
git clone -b $FLUTTER_VERSION https://github.com/flutter/flutter.git

export PATH=$(pwd)/flutter/bin:$PATH

#flutter channel stable
flutter doctor

echo "Installed flutter to $(pwd)/flutter"

if [[ "$APPCENTER_XCODE_SCHEME" == "prod" ]]; then
    flutter build ios --release --build-name=$MAJOR_VERSION.$MINOR_VERSION.$REV_VERSION --build-number=$BUILD_NUMBER --flavor $APPCENTER_XCODE_SCHEME --no-codesign
else
    flutter build ios --release --build-name=$MAJOR_VERSION.$MINOR_VERSION.$REV_VERSION --build-number=$APPCENTER_BUILD_ID --flavor $APPCENTER_XCODE_SCHEME --no-codesign
fi
