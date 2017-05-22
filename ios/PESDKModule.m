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
  PESDKToolbarController *toolbarController = [PESDKToolbarController new];
  PESDKPhotoEditViewController *photoEditViewController = [[PESDKPhotoEditViewController alloc] initWithData:[NSData dataWithContentsOfFile:path]];
  photoEditViewController.delegate = self;
  UIViewController *currentViewController = RCTPresentedViewController();

  dispatch_async(dispatch_get_main_queue(), ^{
    [toolbarController pushViewController:photoEditViewController animated:NO completion:NULL];
    [currentViewController presentViewController:toolbarController animated:YES completion:NULL];
  });
}

#pragma mark - IMGLYPhotoEditViewControllerDelegate

- (void)photoEditViewController:(PESDKPhotoEditViewController *)photoEditViewController didSaveImage:(UIImage *)image imageAsData:(NSData *)data {
  [self sendEventWithName:@"PhotoEditorDidSave" body:@{ @"image": UIImageJPEGRepresentation(image, 1.0), @"data": data }];
}

- (void)photoEditViewControllerDidCancel:(PESDKPhotoEditViewController *)photoEditViewController {
  [photoEditViewController.toolbarController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
  [self sendEventWithName:@"PhotoEditorDidCancel" body:@{}];
}

- (void)photoEditViewControllerDidFailToGeneratePhoto:(PESDKPhotoEditViewController *)photoEditViewController {
  [self sendEventWithName:@"PhotoEditorDidFailToGeneratePhoto" body:@{}];
}

#pragma mark - RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents {
  return @[ @"PhotoEditorDidSave", @"PhotoEditorDidCancel", @"PhotoEditorDidFailToGeneratePhoto" ];
}

@end
