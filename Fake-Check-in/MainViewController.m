//
//  MainViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 5/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "MainViewController.h"
#import <ImgurAnonymousAPIClient.h>
#import "LocationPickerTableViewController.h"
#import "FriendsPickerTableViewController.h"
#import "PostUtility.h"

@interface MainViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//@property(nonatomic, copy) NSString* _messageToPost;
@property(nonatomic, copy) NSString *pickedLocation;
@property(nonatomic, strong) NSArray *pickedFriends;
@property(nonatomic, strong) UIImage *pickedPhoto;

@end

@implementation MainViewController

#pragma mark - Object Lifecycle

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

#warning 拿掉好像也沒差多少
- (void)setPickedLocation:(NSString *)pickedLocation {
  if (![_pickedLocation isEqualToString:pickedLocation]) {
    _pickedLocation = [pickedLocation copy];
    // self.checkinButton.enabled = (_pickedLocation != nil);
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
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_updateProfile:)
                                               name:FBSDKProfileDidChangeNotification
                                             object:nil];
}

#pragma mark - Actions

- (IBAction)unwindSegueToMainView:(UIStoryboardSegue *)segue {
  // 選擇地點 or 朋友之後進行處理
  NSString *identifier = segue.identifier;
  if ([identifier isEqualToString:@"locationPickerOK"]) {
    [self _processLocation:segue.sourceViewController];
  } else if ([identifier isEqualToString:@"friendsPickerOK"]) {
    [self _processFriends:segue.sourceViewController];
  }
}

- (IBAction)pickPhoto:(id)sender {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

  // 開啟相機介面
  UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		imagePicker.delegate = self;
		[self presentViewController:imagePicker animated:YES completion:nil];
  }];

  // 有相機才啟用拍照功能
  cameraAction.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

  // 開啟相簿介面
  UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"開啟相簿" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		imagePicker.delegate = self;
		imagePicker.modalPresentationStyle = UIModalPresentationPopover;

		UIPopoverPresentationController *popover = imagePicker.popoverPresentationController;
		popover.sourceView = sender;
		popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
		[self presentViewController:imagePicker animated:YES completion:nil];
  }];

  // 移除目前選擇的照片
  UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"移除照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		self.pickedPhoto = nil;
		self.photoImageView.image = nil;
  }];
  removeAction.enabled = (self.pickedPhoto != nil);

  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

  [alertController addAction:cameraAction];
  [alertController addAction:libraryAction];
  [alertController addAction:removeAction];
  [alertController addAction:cancelAction];
  [self presentViewController:alertController animated:YES completion:nil];
}

#warning for FB post testing
- (IBAction)checkin:(id)sender {
  self.checkinButton.enabled = NO;  // 防止連點按鈕

  PostUtility *postUtility = [[PostUtility alloc] initWithMessage:self.messageTextView.text place:self.pickedLocation friends:self.pickedFriends photo:self.pickedPhoto];

  [postUtility start];

  //  if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
  //
  //    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  //
  //		if (self.messageTextView.text.length > 0) {
  //      [parameters setObject:self.messageTextView.text forKey:@"message"];
  //    }
  //    if (self.pickedLocation.length > 0) {
  //      [parameters setObject:self.pickedLocation forKey:@"place"];
  //    }
  //    if (self.pickedFriends.count > 0) {
  //      // 將朋友名單轉換為csv格式
  //      [parameters setObject:[self.pickedFriends componentsJoinedByString:@","] forKey:@"tags"];
  //    }
  //
  //    if (self.pickedPhoto) {
  //      [[ImgurAnonymousAPIClient client] uploadImage:self.pickedPhoto
  //                                       withFilename:nil
  //                                  completionHandler:^(NSURL *imgurURL, NSError *error) {
  //																		if (!error) {
  //																			[parameters setObject:imgurURL forKey:@"link"];
  //
  //																			[[[FBSDKGraphRequest alloc]
  //																				initWithGraphPath:@"/me/feed"
  //																				parameters:parameters
  //																				HTTPMethod:@"POST"]
  //																			 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
  //																				 if (!error) {
  //																					 NSLog(@"Post id:%@", result[@"id"]);
  //																				 } else {
  //																					 NSLog(@"Error:%@",error);
  //																				 }
  //																			 }];
  //
  //																		} else {
  //																			NSLog(@"%@",error);
  //																		}
  //                                  }];
  //    } else {
  //      [[[FBSDKGraphRequest alloc]
  //          initWithGraphPath:@"/me/feed"
  //                 //        initWithGraphPath:@"/me/photos"
  //                 parameters:parameters
  //                 HTTPMethod:@"POST"]
  //          startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
  //				 if (!error) {
  //					 NSLog(@"Post id:%@", result[@"id"]);
  //				 } else {
  //					 NSLog(@"Error:%@",error);
  //				 }
  //          }];
  //    }
  //  } else {
  //    //沒權限
  //    [[[FBSDKLoginManager alloc] init]
  //        logInWithPublishPermissions:@[ @"publish_actions" ]
  //                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
  //      if ([result.grantedPermissions containsObject:@"publish_actions"]) {
  //    [[[FBSDKGraphRequest alloc]
  //			initWithGraphPath:@"me/feed"
  //			parameters:@{ @"message" : @"hello world"}
  //			HTTPMethod:@"POST"]
  //		 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
  //			 if (!error) {
  //				 NSLog(@"Post id 123:%@", result[@"id"]);
  //			 }else{
  //				 NSLog(@"Error 123:%@",error);
  //			 }
  //		 }];
  //      } else {
  //        // This would be a nice place to tell the user why publishing
  //        // is valuable.
  //        //        [_delegate shareUtility:self didFailWithError:nil];
  //      }
  //                            }];
  //    //
  //    //    [[[FBSDKLoginManager alloc] init] logInWithPublishPermissions:@[ @"publish_actions" ] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error){
  //    //
  //    //    }];
  //  }

  self.checkinButton.enabled = YES;
}

#pragma mark - Navigation

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  self.pickedPhoto = [info valueForKey:UIImagePickerControllerOriginalImage];
  self.photoImageView.image = self.pickedPhoto;
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissViewControllerAnimated:YES completion:nil];
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
    display = [NSString stringWithFormat:@"%@、%@", vc.selectedRows[0][@"name"], vc.selectedRows[1][@"name"]];
  } else if (self.pickedFriends.count == 3) {
    display = [NSString stringWithFormat:@"%@、%@、%@", vc.selectedRows[0][@"name"], vc.selectedRows[1][@"name"], vc.selectedRows[2][@"name"]];
  } else if (self.pickedFriends.count > 3) {
    display = [NSString stringWithFormat:@"%@、%@和其他 %lu 人", vc.selectedRows[0][@"name"], vc.selectedRows[1][@"name"], (unsigned long)self.pickedFriends.count - 2];
  } else if (self.pickedFriends == 0) {
    display = nil;
    self.pickedFriends = nil;
  }
  self.friendsLabel.text = display;
  //
  //  for (NSString *theID in self.pickedFriends) {
  //    NSLog(@"%@", theID);
  //  }
}

@end