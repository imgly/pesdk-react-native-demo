# This file is part of the PhotoEditor Software Development Kit.
# Copyright (C) 2016 9elements GmbH <contact@9elements.com>
# All rights reserved.
# Redistribution and use in source and binary forms, without
# modification, are permitted provided that the following license agreement
# is approved and a legal/financial contract was signed by the user.
# The license agreement can be found under the following link:
# https://www.photoeditorsdk.com/LICENSE.txt

function imglyecho {
  echo "[imglyKit] $1"
}

function codesign {
    imglyecho "Code signing $1 using identity \"$EXPANDED_CODE_SIGN_IDENTITY_NAME\""
    /usr/bin/codesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY" --preserve-metadata=identifier,entitlements "$1"
}

function strip_binary {
    binary="$1"
    archs=$(lipo -info "$binary" | rev | cut -d ':' -f1 | rev)
    stripped_archs=""
    for arch in $archs; do
        if [[ "$VALID_ARCHS" != *"$arch"* ]]; then
            # Remove unneeded slices
            lipo -remove "$arch" -output "$binary" "$binary" || exit 1
            stripped_archs="$stripped_archs $arch"
        fi
    done
    echo "$stripped_archs"
}

cd "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH"
framework_folder="./imglyKit.framework"

imglyecho "Running strip-framework.sh..."

if [ "$ACTION" == "install" ]; then
    imglyecho "Removing strip-framework.sh from embedded framework"
    rm -f "$framework_folder/strip-framework.sh"
fi

# Remove *.bcsymbolmap files from framework folder
rm -rf "$framework_folder/BCSymbolMaps"

framework="$framework_folder/imglyKit"
stripped_framework_archs=$(strip_binary "$framework")

if [[ -n "$stripped_framework_archs" ]]; then
    imglyecho "Removed the following architectures from imglyKit framework: $stripped_framework_archs"
    if [ "$CODE_SIGNING_REQUIRED" == "YES" ]; then
        codesign "$framework"
    fi
fi
