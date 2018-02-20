//
//  PESDKModule.m
//  PESDKDemo
//
//  Created by Malte Baumann on 09/03/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "PESDKModule.h"
#import <React/RCTUtils.h>
#import <PhotoEditorSDK/PhotoEditorSDK.h>

@interface PESDKModule () <PESDKPhotoEditViewControllerDelegate>
@end

@implementation PESDKModule

RCT_EXPORT_MODULE(PESDK);

RCT_EXPORT_METHOD(present:(NSString *)path) {
  dispatch_async(dispatch_get_main_queue(), ^{
    PESDKPhotoEditViewController *photoEditViewController = [[PESDKPhotoEditViewController alloc] initWithPhotoAsset:[[PESDKPhoto alloc] initWithData:[NSData dataWithContentsOfFile:path]] configuration:[[PESDKConfiguration alloc] init]];
    photoEditViewController.delegate = self;

    UIViewController *currentViewController = RCTPresentedViewController();
    [currentViewController presentViewController:photoEditViewController animated:YES completion:NULL];
  });
}

#pragma mark - IMGLYPhotoEditViewControllerDelegate

- (void)photoEditViewController:(PESDKPhotoEditViewController *)photoEditViewController didSaveImage:(UIImage *)image imageAsData:(NSData *)data {
  [photoEditViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
    [self sendEventWithName:@"PhotoEditorDidSave" body:@{ @"image": [UIImageJPEGRepresentation(image, 1.0) base64EncodedStringWithOptions: 0], @"data": [data base64EncodedStringWithOptions:0] }];
  }];
}

- (void)photoEditViewControllerDidCancel:(PESDKPhotoEditViewController *)photoEditViewController {
  [photoEditViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
    [self sendEventWithName:@"PhotoEditorDidCancel" body:@{}];
  }];
}

- (void)photoEditViewControllerDidFailToGeneratePhoto:(PESDKPhotoEditViewController *)photoEditViewController {
  [self sendEventWithName:@"PhotoEditorDidFailToGeneratePhoto" body:@{}];
}

#pragma mark - RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents {
  return @[ @"PhotoEditorDidSave", @"PhotoEditorDidCancel", @"PhotoEditorDidFailToGeneratePhoto" ];
}

@end
