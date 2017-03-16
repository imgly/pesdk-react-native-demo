package com.pesdk;


import android.net.Uri;
import android.support.annotation.NonNull;
import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import ly.img.android.sdk.models.constant.Directory;
import ly.img.android.sdk.models.state.EditorLoadSettings;
import ly.img.android.sdk.models.state.EditorSaveSettings;
import ly.img.android.sdk.models.state.manager.SettingsList;
import ly.img.android.ui.activities.PhotoEditorBuilder;

/**
 * Created by malte on 10/03/2017.
 */

public class PESDKModule extends ReactContextBaseJavaModule {

    public static int PESDK_EDITOR_RESULT = 1;
    public PESDKModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "PESDK";
    }

    @ReactMethod
    public void present(@NonNull String image) {
        if (getCurrentActivity() != null) {
            SettingsList settingsList = new SettingsList();
            settingsList.getSettingsModel(EditorLoadSettings.class)
                .setImageSourcePath(image, true) // Load with delete protection true!

                .getSettingsModel(EditorSaveSettings.class)
                .setExportDir(Directory.DCIM, "test")
                .setExportPrefix("result_")
                .setSavePolicy(
                        EditorSaveSettings.SavePolicy.KEEP_SOURCE_AND_CREATE_ALWAYS_OUTPUT
                );

            new PhotoEditorBuilder(getCurrentActivity())
                    .setSettingsList(settingsList)
                    .startActivityForResult(getCurrentActivity(), PESDK_EDITOR_RESULT);
        }
    }
}
