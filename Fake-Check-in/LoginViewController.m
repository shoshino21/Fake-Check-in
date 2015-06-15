//
//  LoginViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 5/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Common.h"

#warning 還沒登入就show登入畫面，已經登入就show主畫面

//
//@interface LoginViewController ()
//
//@end

@implementation LoginViewController {
  //  BOOL _viewDidAppear;
  //  BOOL _viewIsVisible;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.loginButton = [[FBSDKLoginButton alloc] init];
  self.loginButton.delegate = self;
  self.loginButton.readPermissions = @[ @"public_profile", @"user_friends" ];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  //
  if ([FBSDKAccessToken currentAccessToken]) {
    [self performSegueWithIdentifier:@"showMain" sender:self];
  }
  //
  //  self.backToMainButton.hidden = YES;
  //  if (_viewDidAppear) {
  //		_viewIsVisible = YES;
  //  }
  //	_viewDidAppear = YES;
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton
    didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                    error:(NSError *)error {
  if (error) {
    //    NSLog(@"Login error: %@", error);
    [Common
        showAlertMessageWithTitle:@"登入錯誤"
                          message:@"登入發生錯誤，請稍候再試一次"
                 inViewController:self];
  } else {
    [self performSegueWithIdentifier:@"showMain" sender:self];
  }
}

//#warning 保留，guest登入用?
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
  //  if (_viewIsVisible) {
  //    [self performSegueWithIdentifier:@"showMain" sender:self];
  //  }
}

- (IBAction)backToLoginView:(UIStoryboardSegue *)segue {
  // 跳回登入畫面用
}
- (IBAction)goMain:(id)sender {
  if ([FBSDKAccessToken currentAccessToken]) {
    [self performSegueWithIdentifier:@"showMain" sender:self];
  }
}

//#warning 設定直接登入，測試用
//- (IBAction)continueButtonPressed:(UIButton *)sender {
//  if ([FBSDKAccessToken currentAccessToken]) {
//    [self performSegueWithIdentifier:@"showMain" sender:self];
//  }
//}

@end