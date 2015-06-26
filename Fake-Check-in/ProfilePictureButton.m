//
//  ProfilePictureButton.m
//  Fake-Check-in
//
//  Created by shoshino21 on 6/27/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "ProfilePictureButton.h"

@interface ProfilePictureButton ()

@property(nonatomic, strong, readonly)
    FBSDKProfilePictureView *profilePictureView;

@end

@implementation ProfilePictureButton {
  FBSDKProfilePictureView *_profilePictureView;
}

#pragma mark - Properties

- (NSString *)profileID {
  return self.profilePictureView.profileID;
}

- (void)setProfileID:(NSString *)profileID {
  self.profilePictureView.profileID = profileID;
}

- (FBSDKProfilePictureView *)profilePictureView {
  // lazy loading
  if (!_profilePictureView) {
    _profilePictureView =
        [[FBSDKProfilePictureView alloc] initWithFrame:self.bounds];
    _profilePictureView.userInteractionEnabled = NO;
    _profilePictureView.pictureMode = FBSDKProfilePictureModeSquare;
    [self insertSubview:_profilePictureView atIndex:0];
  }
  return _profilePictureView;
}

#pragma mark - Layout

- (void)layoutSubviews {
  [super layoutSubviews];
  _profilePictureView.frame = self.bounds;
}

@end