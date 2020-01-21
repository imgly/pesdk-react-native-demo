/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import <RNPhotoEditorSDK/RNPhotoEditorSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Configure and customize PhotoEditor SDK beyond the configuration options exposed to JavaScript
  RNPhotoEditorSDK.configureWithBuilder = ^(PESDKConfigurationBuilder * _Nonnull builder) {
    // Disable the color pipette for the text color selection tool
    [builder configureTextColorToolController:^(PESDKTextColorToolControllerOptionsBuilder * _Nonnull options) {
      NSMutableArray<PESDKColor *> *colors = [options.availableColors mutableCopy];
      [colors removeObjectAtIndex:0]; // Remove first color item which is the color pipette
      options.availableColors = colors;
    }];
  };
  RNPhotoEditorSDK.willPresentPhotoEditViewController = ^(PESDKPhotoEditViewController * _Nonnull photoEditViewController) {
    NSLog(@"willPresent: %@", photoEditViewController);
  };

  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"PESDKExample"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
