//
//  ShareUtility.h
//  Fake-Check-in
//
//  Created by shoshino21 on 6/9/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@protocol ShareUtilityDelegate;

@interface ShareUtility : NSObject<FBSDKSharingDelegate>

@property(nonatomic, weak) id<ShareUtilityDelegate> delegate;

- (instancetype)initWithMessage:(NSString *)message place:(NSString *)place friends:(NSArray *)friends photo:(UIImage *)photo;

@end

@protocol ShareUtilityDelegate

- (void)shareUtilityWillShare:(ShareUtility *)shareUtility;
- (void)shareUtilityDidCompleteShare:(ShareUtility *)shareUtility;
- (void)shareUtility:(ShareUtility *)shareUtility didFailWithError:(NSError *)error;
//- (void)shareUtilityUserShouldLogin:(ShareUtility *)shareUtility;

@end