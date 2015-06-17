//
//  MainViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 5/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "MainViewController.h"
//#import <ImgurAnonymousAPIClient.h>
#import "Common.h"
#import "LocationPickerTableViewController.h"
#import "FriendsPickerTableViewController.h"
#import "PostUtility.h"

@interface MainViewController () <UINavigationControllerDelegate,
                                  UIImagePickerControllerDelegate,
                                  PostUtilityDelegate>

//@property(nonatomic, copy) NSString* _messageToPost;
@property(nonatomic, copy) NSString *pickedLocation;
@property(nonatomic, strong) NSArray *pickedFriends;
@property(nonatomic, strong) UIImage *pickedPhoto;
@property(nonatomic, strong) PostUtility *postUtility;

#warning temp
@property(nonatomic, strong) UIView *activityOverlayView;

@end

@implementation MainViewController

#pragma mark - Object Lifecycle

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

//#warning 拿掉好像也沒差多少
//- (void)setPickedLocation:(NSString *)pickedLocation {
//  if (![_pickedLocation isEqualToString:pickedLocation]) {
//    _pickedLocation = [pickedLocation copy];
//    // self.checkinButton.enabled = (_pickedLocation != nil);
//  }
//}
#warning Temp
- (void)setActivityOverlayView:(UIView *)activityOverlayView {
  if (_activityOverlayView != activityOverlayView) {
    [_activityOverlayView removeFromSuperview];
    _activityOverlayView = activityOverlayView;
  }
}

- (void)setPostUtility:(PostUtility *)postUtility {
  if (![_postUtility isEqual:postUtility]) {
    _postUtility.delegate = nil;
    _postUtility = postUtility;
  }
}

#pragma mark - View Management

- (void)viewDidLoad {
  [super viewDidLoad];

  self.profilePictureView = [[FBSDKProfilePictureView alloc]
      initWithFrame:self.profilePictureView.bounds];
  self.profilePictureView.pictureMode = FBSDKProfilePictureModeSquare;
  self.profilePictureView.profileID = @"me";

  // 為使按continue進入系統時也能抓到Profile
  [self _updateProfile:nil];

  // 顯示使用者名稱 (須用Notification)
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(_updateProfile:)
             name:FBSDKProfileDidChangeNotification
           object:nil];
}

#pragma mark - Actions

- (IBAction)backToMainView:(UIStoryboardSegue *)segue {
  // 選完地點or朋友之後進行處理
  NSString *identifier = segue.identifier;
  if ([identifier isEqualToString:@"locationPickerOK"]) {
    [self _processLocation:segue.sourceViewController];
  } else if ([identifier isEqualToString:@"friendsPickerOK"]) {
    [self _processFriends:segue.sourceViewController];
  }
}

- (IBAction)pickPhoto:(id)sender {
  UIAlertController *alertController = [UIAlertController
      alertControllerWithTitle:nil
                       message:nil
                preferredStyle:UIAlertControllerStyleActionSheet];

  // 開啟相機介面
  UIAlertAction *cameraAction =
      [UIAlertAction actionWithTitle:@"拍照"
                               style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {
                               UIImagePickerController *imagePicker =
                                   [[UIImagePickerController alloc] init];
                               imagePicker.sourceType =
                                   UIImagePickerControllerSourceTypeCamera;
                               imagePicker.delegate = self;
                               [self presentViewController:imagePicker
                                                  animated:YES
                                                completion:nil];
                             }];

  // 有相機才啟用拍照功能
  cameraAction.enabled = [UIImagePickerController
      isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

  // 開啟相簿介面
  UIAlertAction *libraryAction = [UIAlertAction
      actionWithTitle:@"開啟相簿"
                style:UIAlertActionStyleDefault
              handler:^(UIAlertAction *action) {

                UIImagePickerController *imagePicker =
                    [[UIImagePickerController alloc] init];
                imagePicker.sourceType =
                    UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = self;
                imagePicker.modalPresentationStyle = UIModalPresentationPopover;

                UIPopoverPresentationController *popover =
                    imagePicker.popoverPresentationController;
                popover.sourceView = sender;
                popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
                [self presentViewController:imagePicker
                                   animated:YES
                                 completion:nil];
              }];

  // 移除目前選擇的照片
  UIAlertAction *removeAction =
      [UIAlertAction actionWithTitle:@"移除照片"
                               style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {
                               self.pickedPhoto = nil;
                               self.photoImageView.image = nil;
                             }];
  removeAction.enabled = (self.pickedPhoto != nil);

  UIAlertAction *cancelAction =
      [UIAlertAction actionWithTitle:@"取消"
                               style:UIAlertActionStyleCancel
                             handler:nil];

  [alertController addAction:cameraAction];
  [alertController addAction:libraryAction];
  [alertController addAction:removeAction];
  [alertController addAction:cancelAction];
  [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)checkin:(id)sender {
  //  self.checkinButton.enabled = NO;  // 防止連點按鈕

  PostUtility *postUtility =
      [[PostUtility alloc] initWithMessage:self.messageTextView.text
                                     place:self.pickedLocation
                                   friends:self.pickedFriends
                                     photo:self.pickedPhoto];

  self.postUtility = postUtility;
  postUtility.delegate = self;
  [postUtility start];

  //  self.checkinButton.enabled = YES;
}

#pragma mark - Navigation

#pragma mark - UIImagePickerControllerDelegate

#warning 注意要check FB可接受的照片大小!

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
  self.pickedPhoto = [info valueForKey:UIImagePickerControllerOriginalImage];
  self.photoImageView.image = self.pickedPhoto;
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PostUtilityDelegate

- (void)postUtilityWillPost:(PostUtility *)postUtility {
  [self _startActivityIndicator];
}

- (void)postUtilityDidCompletePost:(PostUtility *)postUtility {
  [self _stopActivityIndicator];
  [Common showAlertMessageWithTitle:nil
                            message:@"發佈成功！"
                   inViewController:self];
}

- (void)postUtility:(PostUtility *)postUtility
    didFailWithError:(NSError *)error {
  [self _stopActivityIndicator];
  [Common showAlertMessageWithTitle:nil
                            message:@"發佈時發生錯誤！"
                   inViewController:self];
}

#pragma mark - Helper methods

- (void)_updateProfile:(NSNotification *)notification {
  if ([FBSDKAccessToken currentAccessToken]) {
    self.profileNameLabel.text = [FBSDKProfile currentProfile].name;
  }
}

- (void)_processLocation:(LocationPickerTableViewController *)vc {
  if (vc.selectedRows.count) {
    self.pickedLocation = vc.selectedRows[0][@"id"];
    self.locationLabel.text = vc.selectedRows[0][@"name"];
  } else {
    self.pickedLocation = nil;
    self.locationLabel.text = nil;
  }
}

- (void)_processFriends:(FriendsPickerTableViewController *)vc {
  self.pickedFriends = [vc.selectedRows valueForKeyPath:@"id"];

  // 依選擇人數使用不同顯示方式
  NSString *display = nil;
  if (self.pickedFriends.count == 1) {
    display = vc.selectedRows[0][@"name"];
  } else if (self.pickedFriends.count == 2) {
    display = [NSString stringWithFormat:@"%@、%@", vc.selectedRows[0][@"name"],
                                         vc.selectedRows[1][@"name"]];
  } else if (self.pickedFriends.count == 3) {
    display =
        [NSString stringWithFormat:@"%@、%@、%@", vc.selectedRows[0][@"name"],
                                   vc.selectedRows[1][@"name"],
                                   vc.selectedRows[2][@"name"]];
  } else if (self.pickedFriends.count > 3) {
    display = [NSString
        stringWithFormat:@"%@、%@和其他 %lu 人", vc.selectedRows[0][@"name"],
                         vc.selectedRows[1][@"name"],
                         (unsigned long)self.pickedFriends.count - 2];
  } else if (self.pickedFriends == 0) {
    display = nil;
    self.pickedFriends = nil;
  }
  self.friendsLabel.text = display;
}

#warning 暫時，之後改用AFNetwork的進度指示器

// NOTE: 顯示轉圈圈進度顯示器，share過程中顯示用的
- (void)_startActivityIndicator {
  UIView *view = self.view;
  CGRect bounds = view.bounds;
  UIView *activityOverlayView = [[UIView alloc] initWithFrame:bounds];
  activityOverlayView.backgroundColor = [UIColor colorWithWhite:0.65 alpha:0.5];
  activityOverlayView.autoresizingMask =
      (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
  self.activityOverlayView = activityOverlayView;
  UIActivityIndicatorView *activityIndicatorView = [
      [UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  activityIndicatorView.center =
      CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
  activityIndicatorView.autoresizingMask =
      (UIViewAutoresizingFlexibleTopMargin |
       UIViewAutoresizingFlexibleRightMargin |
       UIViewAutoresizingFlexibleBottomMargin |
       UIViewAutoresizingFlexibleLeftMargin);
        [activityOverlayView addSubview:activityIndicatorView];
	[view addSubview:activityOverlayView];
	[activityIndicatorView startAnimating];
}

- (void)_stopActivityIndicator {
	self.activityOverlayView = nil;
}

@end