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
//#import <FBSDKShareKit/FBSDKShareKit.h>

@interface MainViewController : UIViewController

@property(strong, nonatomic) IBOutlet FBSDKProfilePictureView* profilePictureView;
@property(strong, nonatomic) IBOutlet UILabel* profileNameLabel;
@property(strong, nonatomic) IBOutlet UITextView* messageTextView;
@property(strong, nonatomic) IBOutlet UIButton* locationButton;
@property(strong, nonatomic) IBOutlet UILabel* locationLabel;
@property(strong, nonatomic) IBOutlet UIButton* friendsButton;
@property(strong, nonatomic) IBOutlet UILabel* friendsLabel;
@property(strong, nonatomic) IBOutlet UIButton* photoButton;
@property(strong, nonatomic) IBOutlet UIImageView* photoImageView;

@property(weak, nonatomic) IBOutlet UIButton* checkinButton;

- (IBAction)backToMain:(UIStoryboardSegue*)segue;

@end
