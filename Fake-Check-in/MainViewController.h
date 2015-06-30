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

#warning 到時把一些用不到的東西拿掉(button之類)

//@property(strong, nonatomic)
//    IBOutlet FBSDKProfilePictureView* profilePictureView;

@property(weak, nonatomic) IBOutlet ProfilePictureButton *profilePictureButton;
@property(weak, nonatomic) IBOutlet UILabel *profileNameLabel;
//@property(strong, nonatomic) IBOutlet UITextView* messageTextView;
//@property(strong, nonatomic) IBOutlet UIButton* locationButton;
@property(weak, nonatomic) IBOutlet UILabel *locationLabel;
//@property(strong, nonatomic) IBOutlet UIButton* friendsButton;
@property(weak, nonatomic) IBOutlet UILabel *messageLabel;
@property(weak, nonatomic) IBOutlet UILabel *friendsLabel;
//@property(strong, nonatomic) IBOutlet UIButton* photoButton;
@property(weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property(weak, nonatomic) IBOutlet UIButton *checkinIconButton;
@property(weak, nonatomic) IBOutlet UIButton *checkinTextButton;

- (IBAction)backToMainView:(UIStoryboardSegue *)segue;
//- (IBAction)pickPhoto:(id)sender;

@end
