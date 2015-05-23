//
//  MapViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 5/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "MapViewController.h"
#import "Coordinate.h"

@interface MapViewController () <CLLocationManagerDelegate>

@property(nonatomic, strong, readonly) CLLocationManager *locationManager;

@end

@implementation MapViewController {
  CLLocationManager *_locationManager;
  CLLocationCoordinate2D _currentCoordinate;  // 儲存目前所在位置
}

#pragma mark - Properties

- (CLLocationManager *)locationManager {
  // lazy accessor
  if (!_locationManager) {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 100;
    [_locationManager requestWhenInUseAuthorization];  // 僅在需要時開啟GPS服務
  }
  return _locationManager;
}

#pragma mark - View Management

- (void)viewDidLoad {
  [super viewDidLoad];
//	self.mapView.showsUserLocation = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [_locationManager startUpdatingLocation];
  self.mapView.centerCoordinate = [[Coordinate sharedCoordinate] lastSelectedCoordinate];
}

- (void)viewDidDisappear:(BOOL)animated {
  [_locationManager stopUpdatingLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions

#pragma mark - Segues

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
}

#pragma mark - Helper Methods

@end