//
//  PostUtility.h
//  Fake-Check-in
//
//  Created by shoshino21 on 6/9/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <FBSDKShareKit/FBSDKShareKit.h>

@protocol PostUtilityDelegate;

@interface PostUtility : NSObject

@property(nonatomic, weak) id<PostUtilityDelegate> delegate;

- (instancetype)initWithMessage:(NSString *)message
                          place:(NSString *)place
                        friends:(NSArray *)friends
                          photo:(UIImage *)photo;

- (void)start;

@end

@protocol PostUtilityDelegate

- (void)PostUtilityWillShare:(PostUtility *)PostUtility;
- (void)PostUtilityDidCompleteShare:(PostUtility *)PostUtility;
- (void)PostUtility:(PostUtility *)PostUtility
    didFailWithError:(NSError *)error;
//- (void)PostUtilityUserShouldLogin:(PostUtility *)PostUtility;

@end