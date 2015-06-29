//
//  MessageEditorViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 6/19/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "MessageEditorViewController.h"

@implementation MessageEditorViewController

#pragma mark - View Management

- (void)viewDidLoad {
	[super viewDidLoad];

	self.messageTextView.placeholder = @"留下你想要的訊息...";
	[self.messageTextView becomeFirstResponder];

	if ([self.currentMessage length] > 0) {
		self.messageTextView.text = self.currentMessage;
	}
}

@end
