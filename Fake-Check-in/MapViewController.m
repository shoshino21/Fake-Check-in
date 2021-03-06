//
//  MapViewController.m
//  Fake-Check-in
//
//  Created by shoshino21 on 5/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "MapViewController.h"
#import "Common.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property(strong, nonatomic, readonly) CLLocationManager *locationManager;

@end

@implementation MapViewController {
  CLLocationManager *_locationManager;
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
  [self.locationManager startUpdatingLocation];
  self.mapView.showsUserLocation = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  // 設定地圖顯示座標和縮放比例
  MKCoordinateRegion region;
  region.center = [[Common sharedStatus] lastSelectedCoordinate];
  region.span = MKCoordinateSpanMake(.01, .01);
  [self.mapView setRegion:region animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.locationManager stopUpdatingLocation];

  // 跳出時儲存最後所在的座標位置
  [[Common sharedStatus]
      setLastSelectedCoordinate:self.mapView.centerCoordinate];
}

#pragma mark - Actions

- (IBAction)showMyLocationButton:(UIButton *)sender {
  CLLocationCoordinate2D userCoordinate = self.mapView.userLocation.coordinate;
  // 用模擬器測試時常因抓不到座標而誤跑到零座標，故姑且攔下。實機測試時是OK的
  if (userCoordinate.latitude != 0 || userCoordinate.longitude != 0) {
    self.mapView.centerCoordinate = userCoordinate;
  }
}

- (IBAction)searchButton:(UIButton *)sender {
  MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
  request.naturalLanguageQuery = self.searchTextField.text;
  MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];

  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  [search startWithCompletionHandler:^(MKLocalSearchResponse *response,
                                       NSError *error) {
    if (error) {
      [Common showAlertMessageWithTitle:@"找不到您想找的地標！"
                                message:nil
                       inViewController:self];
    } else if ([response.mapItems count] == 0) {
      [Common showAlertMessageWithTitle:@"找不到您想找的地標！"
                                message:nil
                       inViewController:self];
    } else {
      // 直接取第一項搜尋結果的座標
      MKMapItem *firstResult = [response.mapItems objectAtIndex:0];
      self.mapView.centerCoordinate = firstResult.placemark.coordinate;
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  }];
}

- (IBAction)backToMapView:(UIStoryboardSegue *)segue {
}

#pragma mark - Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  // 點擊空白處關閉虛擬鍵盤
  if (![self.searchTextField isExclusiveTouch]) {
    [self.searchTextField resignFirstResponder];
  }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
  // 初次啟動MapView時儲存使用者所在位置，以便於viewDidAppear:讀出
  if ([[Common sharedStatus] isMapViewFirstStartUp]) {
    CLLocation *newLocation = [locations lastObject];
    [[Common sharedStatus] setLastSelectedCoordinate:newLocation.coordinate];
    [[Common sharedStatus] setIsMapViewFirstStartUp:NO];
  }
}

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView
                       withError:(NSError *)error {
  if (error) {
    [Common showAlertMessageWithTitle:@"讀取地圖資訊時發生錯誤，請檢查網路狀態！"
                              message:nil
                     inViewController:self];
  }
}

@end
