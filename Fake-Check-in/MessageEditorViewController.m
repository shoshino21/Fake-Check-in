//
//  MessageEditorViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 6/19/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "MessageEditorViewController.h"

@implementation MessageEditorViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.messageTextView.text = self.currentMessage;
}

@end
