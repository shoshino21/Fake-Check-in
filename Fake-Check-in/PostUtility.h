//
//  PostUtility.h
//  Fake-Check-in
//
//  Created by shoshino21 on 6/9/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PostUtilityDelegate;

@interface PostUtility : NSObject

@property(weak, nonatomic) id<PostUtilityDelegate> delegate;

- (instancetype)initWithMessage:(NSString *)message
                          place:(NSString *)place
                        friends:(NSArray *)friends
                          photo:(UIImage *)photo;

- (void)start;

@end

@protocol PostUtilityDelegate

- (void)postUtilityWillPost:(PostUtility *)postUtility;
- (void)postUtilityDidCompletePost:(PostUtility *)postUtility;
- (void)postUtility:(PostUtility *)postUtility
    didFailWithError:(NSError *)error;

@end
