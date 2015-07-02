//
//  MainViewController.h
//  Fake-Check-in
//
//  Created by shoshino21 on 5/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "ProfilePictureButton.h"

@interface MainViewController : UIViewController

@property(weak, nonatomic) IBOutlet ProfilePictureButton *profilePictureButton;
@property(weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *locationLabel;
@property(weak, nonatomic) IBOutlet UILabel *messageLabel;
@property(weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property(weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property(weak, nonatomic) IBOutlet UIButton *locationIconButton;
@property(weak, nonatomic) IBOutlet UIButton *locationTextButton;
@property(weak, nonatomic) IBOutlet UIButton *messageIconButton;
@property(weak, nonatomic) IBOutlet UIButton *messageTextButton;
@property(weak, nonatomic) IBOutlet UIButton *friendsIconButton;
@property(weak, nonatomic) IBOutlet UIButton *friendsTextButton;
@property(weak, nonatomic) IBOutlet UIButton *photoIconButton;
@property(weak, nonatomic) IBOutlet UIButton *photoTextButton;
@property(weak, nonatomic) IBOutlet UIButton *checkinIconButton;
@property(weak, nonatomic) IBOutlet UIButton *checkinTextButton;

- (IBAction)backToMainView:(UIStoryboardSegue *)segue;

@end
