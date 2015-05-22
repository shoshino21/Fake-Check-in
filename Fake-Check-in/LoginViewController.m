//
//  LoginViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 5/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.loginButton = [[FBSDKLoginButton alloc] init];
  self.loginButton.readPermissions = @[ @"public_profile", @"user_friends" ];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
  if (error) {
    NSLog(@"Login error: %@", error);

    NSString *alertTitle = @"登入錯誤";
    NSString *alertMessage = @"登入發生錯誤，請稍候再試一次";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
  } else {
    [self performSegueWithIdentifier:@"showMain" sender:self];
  }
}

#warning 保留，guest登入用?
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
}

#warning 設定直接登入，測試用
- (IBAction)continueButtonPressed:(UIButton *)sender {
  if ([FBSDKAccessToken currentAccessToken]) {
    [self performSegueWithIdentifier:@"showMain" sender:self];
  }
}

@end
