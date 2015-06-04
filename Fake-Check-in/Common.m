//
//  Coordinate.m
//  Fake-Check-in
//
//  Created by shoshino21 on 5/23/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "Common.h"

@implementation Common

#pragma mark - Singleton Methods

+ (instancetype)sharedStatus {
  static Common *sharedStatus = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
		sharedStatus = [[self alloc] init];
  });
  return sharedStatus;
}

- (instancetype)init {
  if (self = [super init]) {
    self.lastSelectedCoordinate = CLLocationCoordinate2DMake(25.014338, 121.463803);  // Apple
    self.isMapViewFirstStartUp = YES;
  }
  return self;
}

#pragma mark - Public API

+ (void)showAlertMessageWithTitle:(NSString *)title message:(NSString *)message inViewController:(UIViewController *)viewController {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
  [alertController addAction:okAction];
  [viewController presentViewController:alertController animated:YES completion:nil];
}

@end