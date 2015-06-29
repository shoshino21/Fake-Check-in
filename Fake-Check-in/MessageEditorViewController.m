//
//  MessageEditorViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 6/19/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "MessageEditorViewController.h"

@implementation MessageEditorViewController {
	NSString *_defaultPlaceholder;
}

#pragma mark - Properties

- (NSString *)defaultPlaceholder {
	// lazy accessor
	if (!_defaultPlaceholder) {
		_defaultPlaceholder = [NSString stringWithFormat:@"留下你想要的訊息..."];
	}
	return _defaultPlaceholder;
}

#pragma mark - Object Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.messageTextView.delegate = self;

	if ([self.currentMessage length] > 0) {
		self.messageTextView.text = self.currentMessage;
		self.messageTextView.textColor = [UIColor blackColor];
	}
	else {
		self.messageTextView.text = self.defaultPlaceholder;
		self.messageTextView.textColor = [UIColor lightGrayColor];
	}
}

#pragma mark - UITextViewDelegate

// 為TextView設定Placeholder

- (void)textViewDidBeginEditing:(UITextView *)textView {
	if ([self.messageTextView.text isEqualToString:self.defaultPlaceholder]) {
		self.messageTextView.text = nil;
		self.messageTextView.textColor = [UIColor blackColor];
	}
	[textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if ([self.messageTextView.text isEqualToString:nil]) {
		self.messageTextView.text = self.defaultPlaceholder;
		self.messageTextView.textColor = [UIColor lightGrayColor];
	}
	[textView resignFirstResponder];
}

@end
