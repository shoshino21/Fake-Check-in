//
//  PickerTableViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 6/5/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "PickerTableViewController.h"
#import "Common.h"

@implementation PickerTableViewController {
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

#pragma mark - Public Methods

- (void)fetchData {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  [self.request
      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                   id result, NSError *error) {

        if (error) {
          [Common showAlertMessageWithTitle:@"取得資料時發生錯誤！"
                                    message:nil
                           inViewController:self];
          [self dismissViewControllerAnimated:YES completion:nil];
        } else {
          _fetchResults = result[@"data"];
          [self.tableView reloadData];
        }

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _fetchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"cell"
                                      forIndexPath:indexPath];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  cell.textLabel.text = _fetchResults[indexPath.row][@"name"];
  NSString *pictureURL =
      _fetchResults[indexPath.row][@"picture"][@"data"][@"url"];

  // 若有圖片則另開一thread抓圖
  if (pictureURL) {
    dispatch_queue_t queue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
      NSData *image = [[NSData alloc]
          initWithContentsOfURL:[NSURL URLWithString:pictureURL]];

      // 讀取完成時顯示圖片
      dispatch_async(dispatch_get_main_queue(), ^{
        cell.imageView.image = [UIImage imageWithData:image];
        [cell setNeedsLayout];
      });
    });
  }
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView cellForRowAtIndexPath:indexPath].accessoryType =
      UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView cellForRowAtIndexPath:indexPath].accessoryType =
      UITableViewCellAccessoryNone;
}

@end
