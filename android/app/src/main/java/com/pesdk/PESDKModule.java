package com.pesdk;


import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.util.Log;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.HashMap;
import java.util.Map;

import ly.img.android.sdk.models.constant.Directory;
import ly.img.android.sdk.models.state.EditorLoadSettings;
import ly.img.android.sdk.models.state.EditorSaveSettings;
import ly.img.android.sdk.models.state.manager.SettingsList;
import ly.img.android.ui.activities.ImgLyIntent;
import ly.img.android.ui.activities.PhotoEditorBuilder;

/**
 * Created by malte on 10/03/2017.
 */

public class PESDKModule extends ReactContextBaseJavaModule {

    public static final int PESDK_EDITOR_RESULT = 1;
    private ReactApplicationContext mReactContext;
    public PESDKModule(ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addActivityEventListener(mActivityEventListener);
        this.mReactContext = reactContext;
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

    // Listen for onActivityResult
    private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
            switch (requestCode) {
                case PESDK_EDITOR_RESULT: {
                    switch (resultCode) {
                        // TODO:
                        // This currently yields JavaScript errors due to a slice
                        // call somewhere within React.
                        case Activity.RESULT_CANCELED:
                            // mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("PhotoEditorDidCancel", null);
                            break;
                        case Activity.RESULT_OK:
                            String resultPath = data.getStringExtra(ImgLyIntent.RESULT_IMAGE_PATH);
                            WritableMap payload = Arguments.createMap();
                            payload.putString("path", resultPath);
                            // mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("PhotoEditorDidSave", payload);
                            break;
                    }
                    break;
                }
            }
        }
    };
}
