//
//  Coordinate.h
//  Fake-Check-in
//
//  Created by shoshino21 on 5/23/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Common : NSObject

@property(assign, nonatomic) CLLocationCoordinate2D lastSelectedCoordinate;
@property(assign, nonatomic) BOOL isMapViewFirstStartUp;

+ (id)sharedStatus;

+ (void)showAlertMessageWithTitle:(NSString *)title
                          message:(NSString *)message
                 inViewController:(UIViewController *)viewController;

@end