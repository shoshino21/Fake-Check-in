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

@property(copy, nonatomic, readonly) NSArray *selectedRows;
@property(strong, nonatomic) FBSDKGraphRequest *request;

- (void)fetchData;

@end
