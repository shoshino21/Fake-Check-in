//
//  LocationPickerTableViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 6/2/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "LocationPickerTableViewController.h"
#import "Common.h"

@implementation LocationPickerTableViewController

#pragma mark - Properties

- (FBSDKGraphRequest *)request {
  // lazy accessor
  if (!super.request) {
    CLLocationCoordinate2D coordinate =
        [[Common sharedStatus] lastSelectedCoordinate];
    NSDictionary *parameters = @{
      @"type" : @"place",
      @"limit" : @"100",
      @"center" : [NSString stringWithFormat:@"%lf,%lf", coordinate.latitude,
                                             coordinate.longitude],
      @"distance" : @"10000",
      @"fields" : @"id,name,picture.width(100).height(100)"
    };
    super.request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"search"
                                                      parameters:parameters];
  }
  return super.request;
}

#pragma mark - View Management

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.allowsMultipleSelection = NO;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [super fetchData];
}

@end