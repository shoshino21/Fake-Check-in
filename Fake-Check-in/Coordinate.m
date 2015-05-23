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
    // 預設座標 = 台北車站
    self.lastSelectedCoordinate = CLLocationCoordinate2DMake(25.047778, 121.517222);
  }
  return self;
}

@end
