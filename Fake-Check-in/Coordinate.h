//
//  Coordinate.h
//  Fake-Check-in
//
//  Created by shoshino21 on 5/23/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Coordinate : NSObject

@property(nonatomic, assign) CLLocationCoordinate2D lastSelectedCoordinate;

+ (id)sharedCoordinate;

@end