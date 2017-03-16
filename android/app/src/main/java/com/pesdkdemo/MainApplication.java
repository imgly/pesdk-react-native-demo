package com.pesdkdemo;

import android.support.annotation.NonNull;

import com.facebook.react.ReactPackage;
import com.facebook.soloader.SoLoader;
import com.pesdk.PESDKPackage;
import com.reactnativenavigation.NavigationApplication;
import com.rnfs.RNFSPackage;

import java.util.Arrays;
import java.util.List;

import ly.img.android.PESDK;

public class MainApplication extends NavigationApplication {

    @Override
    public void onCreate() {
        super.onCreate();

        SoLoader.init(this, /* native exopackage */ false);
        PESDK.init(this);
    }

    @Override
    public boolean isDebug() {
        // Make sure you are using BuildConfig from your own application
        return BuildConfig.DEBUG;
    }

    @NonNull
    @Override
    public List<ReactPackage> createAdditionalReactPackages() {
        // Add the packages you require here.
        // No need to add RnnPackage and MainReactPackage
        return Arrays.<ReactPackage>asList(
                new RNFSPackage(),
                new PESDKPackage()
        );
    }
}
