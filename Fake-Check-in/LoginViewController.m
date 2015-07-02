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

@implementation LoginViewController {
  BOOL _isBackFromMainView;
}

#pragma mark - View Management

- (void)viewDidLoad {
  [super viewDidLoad];

  self.loginButton.delegate = self;
  self.loginButton.readPermissions = @[ @"public_profile", @"user_friends" ];
  [self.goMainViewButton setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  // 已經登入過且剛開啟程式，則直接跳到主畫面
  if ([FBSDKAccessToken currentAccessToken] && !_isBackFromMainView) {
    [self performSegueWithIdentifier:@"showMain" sender:self];
  }
}

#pragma mark - Actions

- (IBAction)backToLoginView:(UIStoryboardSegue *)segue {
  // 供unwindSegue連結回登入畫面用
  _isBackFromMainView = YES;
  [self.goMainViewButton setHidden:NO];
}

- (IBAction)goMainView:(id)sender {
  if ([FBSDKAccessToken currentAccessToken]) {
    [self performSegueWithIdentifier:@"showMain" sender:self];
  }
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton
    didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                    error:(NSError *)error {
  if (error) {
    [Common
        showAlertMessageWithTitle:@"登入時發生錯誤，請稍候再試！"
                          message:nil
                 inViewController:self];
  } else if (!result.isCancelled) {
    [self performSegueWithIdentifier:@"showMain" sender:self];
  }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
  [self.goMainViewButton setHidden:YES];
}

@end
