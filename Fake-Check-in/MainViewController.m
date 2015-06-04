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
@property(nonatomic, copy) NSString* pickedLocation;
@property(nonatomic, strong) NSArray* pickedFriends;
@property(nonatomic, strong) UIImage* pickedPhoto;

@end

@implementation MainViewController
//  NSString* _pickedLocation;
//  NSArray* _pickedFriends;

#pragma mark - Object Lifecycle

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (void)setPickedLocation:(NSString*)pickedLocation {
  if (![_pickedLocation isEqualToString:pickedLocation]) {
    _pickedLocation = [pickedLocation copy];
    self.checkinButton.enabled = (_pickedLocation != nil);
  }
}

#pragma mark - View Management

- (void)viewDidLoad {
  [super viewDidLoad];

  self.profilePictureView = [[FBSDKProfilePictureView alloc]
      initWithFrame:self.profilePictureView.bounds];
  self.profilePictureView.pictureMode = FBSDKProfilePictureModeSquare;
  self.profilePictureView.profileID = @"me";

  // 為了按continue進入系統時也能抓到Profile的資料
  [self _updateProfile:nil];

  // 顯示使用者名稱 (須用Notification)
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_updateProfile:)
                                               name:FBSDKProfileDidChangeNotification
                                             object:nil];
}

#pragma mark - Actions

- (IBAction)unwindSegueToMainView:(UIStoryboardSegue*)segue {
  // 選擇地點 or 朋友之後進行處理
  NSString* identifier = segue.identifier;

  if ([identifier isEqualToString:@"locationPickerOK"]) {  // 選擇地點
    LocationPickerTableViewController* locationPicker = segue.sourceViewController;
    if (locationPicker.selectedRows.count) {
      self.pickedLocation = locationPicker.selectedRows[0][@"id"];
      self.locationLabel.text = locationPicker.selectedRows[0][@"name"];
    } else {
      self.pickedLocation = nil;
      self.locationLabel.text = nil;
    }

  } else if ([identifier isEqualToString:@"friendsPickerOK"]) {  // 選擇朋友
    FriendsPickerTableViewController* friendsPicker = segue.sourceViewController;
    self.pickedFriends = [friendsPicker.selectedRows valueForKeyPath:@"id"];

    // 依選擇人數使用不同顯示方式
    NSString* display = nil;
    if (self.pickedFriends.count == 1) {
      display = friendsPicker.selectedRows[0][@"name"];
    } else if (self.pickedFriends.count == 2) {
      display = [NSString stringWithFormat:@"%@、%@", friendsPicker.selectedRows[0][@"name"], friendsPicker.selectedRows[1][@"name"]];
    } else if (self.pickedFriends.count == 3) {
      display = [NSString stringWithFormat:@"%@、%@、%@", friendsPicker.selectedRows[0][@"name"], friendsPicker.selectedRows[1][@"name"], friendsPicker.selectedRows[2][@"name"]];
    } else if (self.pickedFriends.count > 3) {
      display = [NSString stringWithFormat:@"%@、%@和其他 %lu 人", friendsPicker.selectedRows[0][@"name"], friendsPicker.selectedRows[1][@"name"], (unsigned long)self.pickedFriends.count - 2];
    } else if (self.pickedFriends == 0) {
      display = nil;
      self.pickedFriends = nil;
    }
    self.friendsLabel.text = display;
  }
}

#pragma mark - Navigation

#pragma mark - Helper methods

- (void)_updateProfile:(NSNotification*)notification {
  if ([FBSDKAccessToken currentAccessToken]) {
    self.profileNameLabel.text = [FBSDKProfile currentProfile].name;
  }
}

@end