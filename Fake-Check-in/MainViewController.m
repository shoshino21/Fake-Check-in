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
  NSString* identifier = segue.identifier;
  NSLog(@"%@", identifier);

  if ([identifier isEqualToString:@"locationPickerOK"]) {  // 選擇地點
    LocationPickerTableViewController* locationPicker = segue.sourceViewController;
    if (locationPicker.selectedRows.count) {
      _pickedLocation = locationPicker.selectedRows[0][@"id"];
      self.locationLabel.text = locationPicker.selectedRows[0][@"name"];
    } else {
      _pickedLocation = nil;
      self.locationLabel.text = nil;
    }

  } else if ([identifier isEqualToString:@"friendsPickerOK"]) {  // 選擇好友
    FriendsPickerTableViewController* friendsPicker = segue.sourceViewController;
    _pickedFriends = [friendsPicker.selectedRows valueForKeyPath:@"id"];
    // TODO: 要依人數不同修改顯示方式
    self.friendsLabel.text = friendsPicker.selectedRows[0][@"name"];
  }
}

#pragma mark - Helper methods

- (void)_updateContent:(NSNotification*)notification {
  if ([FBSDKAccessToken currentAccessToken]) {
    self.profileNameLabel.text = [FBSDKProfile currentProfile].name;
  }
}

@end