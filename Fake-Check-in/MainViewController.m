//
//  MainViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 5/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property(nonatomic, copy) NSString* _messageToPost;
@property(nonatomic, copy) NSString* _pickedLocation;
@property(nonatomic, strong) NSArray* _pickedFriends;
@property(nonatomic, strong) UIImage* _pickedPhoto;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.profilePictureView = [[FBSDKProfilePictureView alloc]
      initWithFrame:self.profilePictureView.bounds];
  self.profilePictureView.pictureMode = FBSDKProfilePictureModeSquare;
  self.profilePictureView.profileID = @"me";

  // 為了按continue進入系統時也能抓到Profile的資料
  [self _updateContent:nil];

  // 顯示使用者名稱 (必須用Notification)
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(_updateContent:)
             name:FBSDKProfileDidChangeNotification
           object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_updateContent:(NSNotification*)notification {
  if ([FBSDKAccessToken currentAccessToken]) {
    self.profileNameLabel.text = [FBSDKProfile currentProfile].name;
  }
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

@end
