//
//  PESDKModule.m
//  PESDKDemo
//
//  Created by Malte Baumann on 09/03/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "PESDKModule.h"
#import <React/RCTUtils.h>
#import <imglyKit/imglyKit.h>

@interface PESDKModule () <IMGLYPhotoEditViewControllerDelegate>
@end

@implementation PESDKModule

RCT_EXPORT_MODULE(PESDK);

RCT_EXPORT_METHOD(present:(NSString *)path) {
  IMGLYToolbarController *toolbarController = [IMGLYToolbarController new];
  IMGLYPhotoEditViewController *photoEditViewController = [[IMGLYPhotoEditViewController alloc] initWithData:[NSData dataWithContentsOfFile:path]];
  photoEditViewController.delegate = self;
  UIViewController *currentViewController = RCTPresentedViewController();

  dispatch_async(dispatch_get_main_queue(), ^{
    [toolbarController pushViewController:photoEditViewController animated:NO completion:NULL];
    [currentViewController presentViewController:toolbarController animated:YES completion:NULL];
  });
}

#pragma mark - IMGLYPhotoEditViewControllerDelegate

- (void)photoEditViewController:(IMGLYPhotoEditViewController *)photoEditViewController didSaveImage:(UIImage *)image imageAsData:(NSData *)data {
  [self sendEventWithName:@"PhotoEditorDidSave" body:@{ @"image": UIImageJPEGRepresentation(image, 1.0), @"data": data }];
}

- (void)photoEditViewControllerDidCancel:(IMGLYPhotoEditViewController *)photoEditViewController {
  [photoEditViewController.toolbarController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
  [self sendEventWithName:@"PhotoEditorDidCancel" body:@{}];
}

- (void)photoEditViewControllerDidFailToGeneratePhoto:(IMGLYPhotoEditViewController *)photoEditViewController {
  [self sendEventWithName:@"PhotoEditorDidFailToGeneratePhoto" body:@{}];
}

#pragma mark - RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents {
  return @[ @"PhotoEditorDidSave", @"PhotoEditorDidCancel", @"PhotoEditorDidFailToGeneratePhoto" ];
}

@end
