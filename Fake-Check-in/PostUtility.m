//
//  PostUtility.m
//  Fake-Check-in
//
//  Created by shoshino21 on 6/9/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

//  備註：
//  由於Facebook Graph API 2.x的先天限制，
//  (以/me/feed發表時不能放圖片，只能放已存在的圖片連結。
//   以/me/photos發表時不能標記好友和地點)
//  因此先將圖片上傳至imgur，再將連結放入Facebook的參數中

#import "PostUtility.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ImgurAnonymousAPIClient.h>

@interface PostUtility ()

@property(nonatomic, strong) NSMutableDictionary* parameters;

//- (void)_checkForPermission;
//- (void)_uploadPhotoToImgur;
//- (void)_postOnFacebook;

@end

@implementation PostUtility {
  NSString* _message;
  NSString* _place;
  NSArray* _friends;
  UIImage* _photo;
  //  NSMutableDictionary* _parameters;
}

#pragma mark - Object Lifecycle

- (instancetype)initWithMessage:(NSString*)message place:(NSString*)place friends:(NSArray*)friends photo:(UIImage*)photo {
  if (self = [super init]) {
    _message = [message copy];
    _place = [place copy];
    _friends = [friends copy];
#warning 要確認用實機拍照時方向對不對，有可能要加normalize method
    _photo = [photo copy];
  }
  return self;
}

//- (void)dealloc {
//  _shareAPI.delegate = nil;
//}
//

#pragma mark - Properties

- (NSMutableDictionary*)parameters {
  if (!_parameters) {
    _parameters = [NSMutableDictionary dictionary];

    // 有輸入值才放入參數當中
    if (_message.length > 0) {
      [_parameters setObject:_message forKey:@"message"];
    }
    if (_place.length > 0) {
      [_parameters setObject:_place forKey:@"place"];
    }
    if (_friends.count > 0) {
      // 將朋友名單轉換為csv格式
      [_parameters setObject:[_friends componentsJoinedByString:@","] forKey:@"tags"];
    }
  }
  return _parameters;
}

#pragma mark - Public API

- (void)start {
  [self _checkForPermission];
}

#pragma mark - Helper Methods

- (void)_checkForPermission {
  if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
    [self _uploadPhotoToImgur];
  } else {
    [[[FBSDKLoginManager alloc] init] logInWithPublishPermissions:@[ @"publish_actions" ] handler:^(FBSDKLoginManagerLoginResult* result, NSError* error) {
			if ([result.grantedPermissions containsObject:@"publish_actions"]) {
				[self _uploadPhotoToImgur];
			}else{
				// 通知user必須取得權限才可執行
				NSLog(@"Need permission");
			}
    }];
  }
}

- (void)_uploadPhotoToImgur {
  if (!_photo) {
    [self _postOnFacebook];
  } else {
    [[ImgurAnonymousAPIClient client] uploadImage:_photo
                                     withFilename:nil
                                completionHandler:^(NSURL* imgurURL, NSError* error) {
																	if (!error) {
																		NSLog(@"Upload Photo Completed.");
																		[self.parameters setObject:imgurURL forKey:@"link"];
																		[self _postOnFacebook];
																	}else{
																		NSLog(@"Upload Photo Error: %@",error);
																	}
                                }];
  }
}

- (void)_postOnFacebook {
  [[[FBSDKGraphRequest alloc]
      initWithGraphPath:@"/me/feed"
             parameters:self.parameters
             HTTPMethod:@"POST"]
      startWithCompletionHandler:^(FBSDKGraphRequestConnection* connection, id result, NSError* error) {
		 if (!error) {
			 NSLog(@"Post id:%@", result[@"id"]);
		 } else {
			 NSLog(@"Post Error:%@",error);
		 }
      }];
}

@end