//
//  ShareUtility.m
//  Fake-Check-in
//
//  Created by shoshino21 on 6/9/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "ShareUtility.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation ShareUtility {
  NSString* _message;
  NSString* _place;
  NSArray* _friends;
  UIImage* _photo;
  FBSDKShareAPI* _shareAPI;
}

#pragma mark - Object Lifecycle

- (instancetype)initWithMessage:(NSString*)message place:(NSString*)place friends:(NSArray*)friends photo:(UIImage*)photo {
  if (self = [super init]) {
    _message = [message copy];
    _place = [place copy];
    _friends = [friends copy];
    _photo = [photo copy];

    //    FBSDKShareOpenGraphContent* shareContent = ;

    _shareAPI = [[FBSDKShareAPI alloc] init];
    _shareAPI.delegate = self;
//    _shareAPI.shareContent = [self _contentForSharing];
  }
  return self;
}

- (void)dealloc {
  _shareAPI.delegate = nil;
}

#pragma mark - Public API

#pragma mark - Helper Methods
//
//- (FBSDKShareOpenGraphContent*)_contentForSharing {
//  FBSDKShareOpenGraphContent* content = [[FBSDKShareOpenGraphContent alloc] init];
//
//#warning 不確定title, description的具體呈現是如何
//
//  NSDictionary* objectProperties = @{
//    @"og:type" : @"fb_checkin",
//    @"og:title" : _message,
//    @"og:description" : _message,
//  };
//  FBSDKShareOpenGraphObject* object = [FBSDKShareOpenGraphObject objectWithProperties:objectProperties];
//
//  FBSDKShareOpenGraphAction* action = [[FBSDKShareOpenGraphAction alloc] init];
//	action.actionType=@"";
//}

@end
