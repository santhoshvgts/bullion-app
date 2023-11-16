#!/usr/bin/env bash
#Place this script in project/android/app/

cd ..

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

if [[ "$FLAVOR" == "prod" ]]; then
    # build APK
    flutter build apk --build-name=$MAJOR_VERSION.$MINOR_VERSION.$REV_VERSION --build-number=$BUILD_NUMBER --flavor $FLAVOR --release
    
    # copy the APK where AppCenter will find it
    mkdir -p android/app/build/outputs/apk/
    mv build/app/outputs/apk/$FLAVOR/release/app-$FLAVOR-release.apk $_
    
    # build AAB
    flutter build appbundle --build-name=$MAJOR_VERSION.$MINOR_VERSION.$REV_VERSION --build-number=$BUILD_NUMBER --flavor $FLAVOR --release
    
    # copy the AAB where AppCenter will find it
    mkdir -p android/app/build/outputs/bundle/
    mv build/app/outputs/bundle/${FLAVOR}Release/app-${FLAVOR}-release.aab $_
else
    # build APK
    flutter build apk --build-name=$MAJOR_VERSION.$MINOR_VERSION.$REV_VERSION --build-number=$APPCENTER_BUILD_ID --flavor $FLAVOR --release
    
    # copy the APK where AppCenter will find it
    mkdir -p android/app/build/outputs/apk/
    mv build/app/outputs/apk/$FLAVOR/release/app-$FLAVOR-release.apk $_
fi
