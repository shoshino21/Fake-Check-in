//
//  MainViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 5/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "MainViewController.h"
#import "LocationPickerTableViewController.h"
#import "FriendsPickerTableViewController.h"

@interface MainViewController ()

//@property(nonatomic, copy) NSString* _messageToPost;
//@property(nonatomic, copy) NSString* _pickedLocation;
//@property(nonatomic, strong) NSArray* _pickedFriends;
@property(nonatomic, strong) UIImage* _pickedPhoto;

@end

@implementation MainViewController {
  NSString* _pickedLocation;
  NSArray* _pickedFriends;
}

#pragma mark - View Management

- (void)viewDidLoad {
  [super viewDidLoad];

  self.profilePictureView = [[FBSDKProfilePictureView alloc]
      initWithFrame:self.profilePictureView.bounds];
  self.profilePictureView.pictureMode = FBSDKProfilePictureModeSquare;
  self.profilePictureView.profileID = @"me";

  // 為了按continue進入系統時也能抓到Profile的資料
  [self _updateContent:nil];

  // 顯示使用者名稱 (須用Notification)
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(_updateContent:)
             name:FBSDKProfileDidChangeNotification
           object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Navigation

- (IBAction)unwindSegueToMainView:(UIStoryboardSegue*)segue {
  // 選擇地點 or 朋友之後進行處理
  NSString* identifier = segue.identifier;

  if ([identifier isEqualToString:@"locationPickerOK"]) {  // 選擇地點
    LocationPickerTableViewController* locationPicker = segue.sourceViewController;
    if (locationPicker.selectedRows.count) {
      _pickedLocation = locationPicker.selectedRows[0][@"id"];
      self.locationLabel.text = locationPicker.selectedRows[0][@"name"];
    } else {
      _pickedLocation = nil;
      self.locationLabel.text = nil;
    }

  } else if ([identifier isEqualToString:@"friendsPickerOK"]) {  // 選擇朋友
    FriendsPickerTableViewController* friendsPicker = segue.sourceViewController;
    _pickedFriends = [friendsPicker.selectedRows valueForKeyPath:@"id"];

    // 依選擇人數使用不同顯示方式
    NSString* display = nil;
    if (_pickedFriends.count == 1) {
      display = friendsPicker.selectedRows[0][@"name"];
    } else if (_pickedFriends.count == 2) {
      display = [NSString stringWithFormat:@"%@、%@", friendsPicker.selectedRows[0][@"name"], friendsPicker.selectedRows[1][@"name"]];
    } else if (_pickedFriends.count == 3) {
      display = [NSString stringWithFormat:@"%@、%@、%@", friendsPicker.selectedRows[0][@"name"], friendsPicker.selectedRows[1][@"name"], friendsPicker.selectedRows[2][@"name"]];
    } else if (_pickedFriends.count > 3) {
      display = [NSString stringWithFormat:@"%@、%@和其他 %lu 人", friendsPicker.selectedRows[0][@"name"], friendsPicker.selectedRows[1][@"name"], (unsigned long)_pickedFriends.count - 2];
    } else if (_pickedFriends == 0) {
      display = nil;
      _pickedFriends = nil;
    }
    self.friendsLabel.text = display;
  }
}

#pragma mark - Helper methods

- (void)_updateContent:(NSNotification*)notification {
  if ([FBSDKAccessToken currentAccessToken]) {
    self.profileNameLabel.text = [FBSDKProfile currentProfile].name;
  }
}

@end