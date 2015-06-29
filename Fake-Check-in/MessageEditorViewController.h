//
//  MessageEditorViewController.h
//  Fake-Check-in
//
//  Created by shoshino21 on 6/19/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTTextView.h"

@interface MessageEditorViewController : UIViewController

@property(weak, nonatomic) IBOutlet CHTTextView *messageTextView;
@property(copy, nonatomic) NSString *currentMessage;

@end
