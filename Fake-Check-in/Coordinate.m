//
//  Coordinate.m
//  Fake-Check-in
//
//  Created by shoshino21 on 5/23/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate

#pragma mark - Singleton Methods

+ (instancetype)sharedCoordinate {
  static Coordinate *sharedCoordinate = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
		sharedCoordinate = [[self alloc] init];
  });
  return sharedCoordinate;
}

- (instancetype)init {
  if (self = [super init]) {
    self.lastSelectedCoordinate = CLLocationCoordinate2DMake(25.014338, 121.463803);  // Apple
    self.isMapViewFirstStartUp = YES;
  }
  return self;
}
@end
