# This file is part of the PhotoEditor Software Development Kit.
# Copyright (C) 2016 9elements GmbH <contact@9elements.com>
# All rights reserved.
# Redistribution and use in source and binary forms, without
# modification, are permitted provided that the following license agreement
# is approved and a legal/financial contract was signed by the user.
# The license agreement can be found under the following link:
# https://www.photoeditorsdk.com/LICENSE.txt

function message {
  echo "[PhotoEditorSDK] strip-framework.sh: $1"
}

function codesign {
    message "Code signing $1 using identity \"$EXPANDED_CODE_SIGN_IDENTITY_NAME\""
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

if [ "$SCRIPT_INPUT_FILE_COUNT" -gt 1 ]; then
  message "Only one dSYM folder as input file allowed"
  exit 1
fi

cd "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH"
framework_folder="./PhotoEditorSDK.framework"

# It's important to copy/remove the bcsymbolmap files before code signing,
# otherwise you'll get an "A signed resource has been added, modified, or deleted"
# error on iOS 8.
if [ "$ACTION" == "install" ]; then
    for file in strip-framework.sh; do
      if [ -e "$framework_folder/$file" ]; then
        message "Removing $file from embedded framework"
        rm -f "$framework_folder/$file"
      fi
    done

    message "Copying .bcsymbolmap files to .xcarchive"
    find "$framework_folder/BCSymbolMaps" -name '*.bcsymbolmap' -type f -exec mv {} "$CONFIGURATION_BUILD_DIR" \;
fi

# Remove *.bcsymbolmap files from framework folder
rm -rf "$framework_folder/BCSymbolMaps"

framework="$framework_folder/PhotoEditorSDK"
# No need to strip static libraries
if [[ $(file "$framework") != *"dynamically linked shared library"* ]]; then
    exit 0
fi

stripped_framework_archs=$(strip_binary "$framework")

if [[ -n "$stripped_framework_archs" ]]; then
    message "Removed the following architectures from PhotoEditorSDK framework: $stripped_framework_archs"
    if [ "$CODE_SIGNING_REQUIRED" == "YES" ]; then
        codesign "$framework"
    fi
fi

# Using a "Copy Files" build phase to copy debug symbols and setting the
# `COPY_PHASE_STRIP` build setting to `YES` causes the `strip` command to fail
# with the message "string table not at the end of the file" when processing
# the debug symbols binary. As a workaround we copy the debug symbols within
# this script.
if [ -n "$SCRIPT_INPUT_FILE_0" ]; then
  dSYM_path="$SCRIPT_INPUT_FILE_0"
  dSYM="$dSYM_path/Contents/Resources/DWARF/PhotoEditorSDK"
  # Check if dSYM binary exists
  if [[ $(file "$dSYM") != *"dSYM companion file"* ]]; then
      message "dSYM folder doesn't contain binary: $dSYM_path"
      exit 2
  fi

  # Copy debug symbols into products directory if they aren't there already
  dSYM_folder=$(basename "$dSYM_path")
  if [ ! -d "$BUILT_PRODUCTS_DIR/$dSYM_folder" ]; then
    cp -rf "$dSYM_path" "$BUILT_PRODUCTS_DIR"
    message "Copied $dSYM_folder into products directory"
  fi

  dSYM="$BUILT_PRODUCTS_DIR/$dSYM_folder/Contents/Resources/DWARF/PhotoEditorSDK"
else
  # Check if debug symbols were manually copied into products directory
  dSYM_folder="$BUILT_PRODUCTS_DIR/PhotoEditorSDK.framework.dSYM"
  dSYM="$dSYM_folder/Contents/Resources/DWARF/PhotoEditorSDK"
  # Check if dSYM binary exists
  if [[ $(file "$dSYM") != *"dSYM companion file"* ]]; then
      # Unsetting dSYM variable so we don't try to strip a non-existing binary
      dSYM=""
  fi
fi

if [ -n "$dSYM" ]; then
  stripped_dSYM_archs=$(strip_binary "$dSYM")

  if [[ -n "$stripped_dSYM_archs" ]]; then
      message "Removed the following architectures from PhotoEditorSDK dSYM: $stripped_dSYM_archs"
  fi
fi
