//
//  PickerTableViewController.h
//  Fake-Check-in
//
//  Created by shoshino21 on 6/5/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface PickerTableViewController : UITableViewController

@property(nonatomic, copy, readonly) NSArray *selectedRows;
@property(nonatomic, strong) FBSDKGraphRequest *request;

- (void)fetchData;

@end