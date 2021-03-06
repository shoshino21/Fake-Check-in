//
//  MainViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 5/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "MainViewController.h"
#import "Common.h"
#import "LocationPickerTableViewController.h"
#import "FriendsPickerTableViewController.h"
#import "MessageEditorViewController.h"
#import "PostUtility.h"

@interface MainViewController () <UINavigationControllerDelegate,
                                  UIImagePickerControllerDelegate,
                                  PostUtilityDelegate>

@property(copy, nonatomic) NSString *pickedLocation;
@property(copy, nonatomic) NSString *messageToPost;
@property(strong, nonatomic) NSArray *pickedFriends;
@property(strong, nonatomic) UIImage *pickedPhoto;
@property(strong, nonatomic) PostUtility *postUtility;
@property(strong, nonatomic) UIView *activityOverlayView;

@end

@implementation MainViewController

#pragma mark - Object Lifecycle

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (void)setPickedLocation:(NSString *)pickedLocation {
  if ((![_pickedLocation isEqualToString:pickedLocation])) {
    _pickedLocation = [pickedLocation copy];
    // 選擇完地點才啟用打卡鈕
    BOOL switchTo = (_pickedLocation != nil);
    self.checkinIconButton.enabled = switchTo;
    self.checkinTextButton.enabled = switchTo;
  }
}

- (void)setPostUtility:(PostUtility *)postUtility {
  if (![_postUtility isEqual:postUtility]) {
    _postUtility.delegate = nil;
    _postUtility = postUtility;
  }
}

- (void)setActivityOverlayView:(UIView *)activityOverlayView {
  if (_activityOverlayView != activityOverlayView) {
    [_activityOverlayView removeFromSuperview];
    _activityOverlayView = activityOverlayView;
  }
}

#pragma mark - View Management

- (void)viewDidLoad {
  [super viewDidLoad];
  self.profilePictureButton.profileID = @"me";

  // 使沿用上次登入進入系統時也能抓到Profile
  [self _updateProfile:nil];

  // 顯示使用者名稱 (須用Notification)
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(_updateProfile:)
             name:FBSDKProfileDidChangeNotification
           object:nil];

  // 選擇完地點才啟用打卡鈕
  self.checkinIconButton.enabled = NO;
  self.checkinTextButton.enabled = NO;
}

#pragma mark - Actions

- (IBAction)backToMainView:(UIStoryboardSegue *)segue {
  // 供UnwindSegue連結並進行相對應處理
  NSString *identifier = segue.identifier;
  if ([identifier isEqualToString:@"locationOK"]) {
    [self _processLocation:segue.sourceViewController];
  } else if ([identifier isEqualToString:@"messageOK"]) {
    [self _processMessage:segue.sourceViewController];
  } else if ([identifier isEqualToString:@"friendsOK"]) {
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
  // 防止使用者打卡途中按下其他按鈕
  [self _switchAllButtonsStatus];

  PostUtility *postUtility =
      [[PostUtility alloc] initWithMessage:self.messageToPost
                                     place:self.pickedLocation
                                   friends:self.pickedFriends
                                     photo:self.pickedPhoto];
  self.postUtility = postUtility;
  postUtility.delegate = self;
  [postUtility start];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"showMessageEditor"]) {
    MessageEditorViewController *vc = (MessageEditorViewController *)
        [[segue destinationViewController] topViewController];
    // 若已輸入訊息則傳送給訊息View
    if (self.messageToPost.length > 0) {
      vc.currentMessage = self.messageToPost;
    }
  }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
  // 避免拍照 or 開啟相簿後狀態欄位文字顏色被重置
  // 參考：http://stackoverflow.com/questions/18880364/
  [[UIApplication sharedApplication]
      setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - UIImagePickerControllerDelegate

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

  // 打卡成功後重啟按鈕，並清空輸入內容
  [self _switchAllButtonsStatus];
  [self _clearInput];

  // 詢問使用者是否跳轉至Facebook頁面觀看結果
  UIAlertController *alertController = [UIAlertController
      alertControllerWithTitle:@"打卡成功！"
                       message:@"要去Facebook頁面看結果嗎？"
                preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *okAction = [UIAlertAction
      actionWithTitle:@"好啊！"
                style:UIAlertActionStyleDefault
              handler:^(UIAlertAction *action) {

                NSURL *url = [NSURL URLWithString:@"fb://profile/"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                  [[UIApplication sharedApplication] openURL:url];
                } else {
                  [[UIApplication sharedApplication]
                      openURL:[NSURL URLWithString:@"http://www.facebook.com"]];
                }
              }];

  UIAlertAction *cancelAction =
      [UIAlertAction actionWithTitle:@"不用了"
                               style:UIAlertActionStyleDefault
                             handler:nil];

  [alertController addAction:cancelAction];
  [alertController addAction:okAction];
  [self presentViewController:alertController animated:YES completion:nil];
}

- (void)postUtility:(PostUtility *)postUtility
    didFailWithError:(NSError *)error {
  [self _stopActivityIndicator];
  [self _switchAllButtonsStatus];

  [Common showAlertMessageWithTitle:@"打卡時發生錯誤！"
                            message:nil
                   inViewController:self];
}

#pragma mark - Helper methods

- (void)_updateProfile:(NSNotification *)notification {
  if ([FBSDKAccessToken currentAccessToken]) {
    self.profileNameLabel.text = [FBSDKProfile currentProfile].name;
  }
}

- (void)_processLocation:(LocationPickerTableViewController *)vc {
  if (vc.selectedRows.count > 0) {
    self.pickedLocation = vc.selectedRows[0][@"id"];
    self.locationLabel.text = vc.selectedRows[0][@"name"];
  } else {
    self.pickedLocation = nil;
    self.locationLabel.text = nil;
  }
}

- (void)_processMessage:(MessageEditorViewController *)vc {
  self.messageToPost = vc.messageTextView.text;
  self.messageLabel.text = self.messageToPost;
}

- (void)_processFriends:(FriendsPickerTableViewController *)vc {
  self.pickedFriends = [vc.selectedRows valueForKeyPath:@"id"];

  // 依選取人數採用不同顯示方式
  NSString *display = nil;
  if (self.pickedFriends.count == 1) {
    display = vc.selectedRows[0][@"name"];
  } else if (self.pickedFriends.count == 2) {
    display = [NSString stringWithFormat:@"%@、%@", vc.selectedRows[0][@"name"],
                                         vc.selectedRows[1][@"name"]];
  } else if (self.pickedFriends.count > 2) {
    display = [NSString
        stringWithFormat:@"%@和其他 %lu 人", vc.selectedRows[0][@"name"],
                         (unsigned long)self.pickedFriends.count - 1];
  } else if (self.pickedFriends.count == 0) {
    display = nil;
    self.pickedFriends = nil;
  }
  self.friendsLabel.text = display;
}

- (void)_startActivityIndicator {
  // 顯示打卡時顯示的進度指示器
  UIView *view = self.view;
  CGRect bounds = view.bounds;
  UIView *activityOverlayView = [[UIView alloc] initWithFrame:bounds];
  activityOverlayView.backgroundColor =
      [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
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

- (void)_switchAllButtonsStatus {
  BOOL switchTo = !self.profilePictureButton.enabled;

  self.profilePictureButton.enabled = switchTo;
  self.locationIconButton.enabled = switchTo;
  self.locationTextButton.enabled = switchTo;
  self.messageIconButton.enabled = switchTo;
  self.messageTextButton.enabled = switchTo;
  self.friendsIconButton.enabled = switchTo;
  self.friendsTextButton.enabled = switchTo;
  self.photoIconButton.enabled = switchTo;
  self.photoTextButton.enabled = switchTo;
  self.checkinIconButton.enabled = switchTo;
  self.checkinTextButton.enabled = switchTo;
}

- (void)_clearInput {
  self.pickedLocation = nil;
  self.messageToPost = nil;
  self.pickedFriends = nil;
  self.pickedPhoto = nil;

  self.locationLabel.text = nil;
  self.messageLabel.text = nil;
  self.friendsLabel.text = nil;
  self.photoImageView.image = nil;
}

@end
