//
//  FriendsPickerTableViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 6/2/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "FriendsPickerTableViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Common.h"

@implementation FriendsPickerTableViewController

#pragma mark - Properties

- (FBSDKGraphRequest *)request {
	// lazy accessor
	if (!super.request) {
		NSDictionary *parameters = @{
			@"fields" : @"id,name,picture.width(100).height(100)"
		};
		super.request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/taggable_friends?limit=100"
		                                                  parameters:parameters];
	}
	return super.request;
}

#pragma mark - View Management

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.allowsMultipleSelection = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	// 確認是否已獲得擷取好友名單的權限，若無則進行要求
	if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"user_friends"]) {
		FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
		[login logInWithReadPermissions:@[@"user_friends"]
		                        handler: ^(FBSDKLoginManagerLoginResult *result, NSError *error) {
		    if ([result.grantedPermissions containsObject:@"user_friends"]) {
		        [super fetchData];
			}
		    else {
		        [self dismissViewControllerAnimated:YES completion:NULL];
			}
		}];
	}
	else {
		[super fetchData];
	}
}

@end
