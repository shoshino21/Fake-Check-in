//
//  FriendsPickerTableViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 6/2/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "FriendsPickerTableViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Common.h"

@interface FriendsPickerTableViewController ()

@property(nonatomic, strong) FBSDKGraphRequest *request;

@end

@implementation FriendsPickerTableViewController {
  NSArray *_fetchResults;
}

#pragma mark - Properties

- (NSArray *)selectedRows {
  NSMutableArray *selected = [NSMutableArray array];
  for (NSIndexPath *index in self.tableView.indexPathsForSelectedRows) {
    [selected addObject:@{
      @"id" : _fetchResults[index.row][@"id"],
      @"name" : _fetchResults[index.row][@"name"]
    }];
  }
  return selected;
}

- (FBSDKGraphRequest *)request {
  // lazy accessor
  if (!_request) {
    NSDictionary *parameters = @{ @"fields" : @"id,name,picture.width(100).height(100)" };
    _request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/taggable_friends?limit=100"
                                                 parameters:parameters];
  }
  return _request;
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
    [login logInWithReadPermissions:@[ @"user_friends" ]
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
															if ([result.grantedPermissions containsObject:@"user_friends"]) {
																[self fetchData];
															} else {
																[self dismissViewControllerAnimated:YES completion:NULL];
															}
                            }];
  } else {
    [self fetchData];
  }
}

#pragma mark - Actions

- (void)fetchData {
  [self.request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
		if (error) {
			NSLog(@"Picker loading error:%@", error);
			[Common showAlertMessageWithTitle:@"無法取得好友清單" message:@"取得好友清單時發生錯誤！" inViewController:self];
			[self dismissViewControllerAnimated:YES completion:nil];
		} else {
			_fetchResults = result[@"data"];
			[self.tableView reloadData];
		}
  }];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _fetchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  cell.textLabel.text = _fetchResults[indexPath.row][@"name"];
  NSString *pictureURL = _fetchResults[indexPath.row][@"picture"][@"data"][@"url"];

  // 若有圖片則另開一thread抓圖
  if (pictureURL) {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
			NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pictureURL]];

			// 讀取完成時顯示圖片
			dispatch_async(dispatch_get_main_queue(), ^{
				cell.imageView.image = [UIImage imageWithData:image];
				[cell setNeedsLayout];
			});
    });
  }
  return cell;
}

#pragma mark - TableViewDataDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

@end
