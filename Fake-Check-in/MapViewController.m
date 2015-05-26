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

@property(nonatomic, strong, readonly) CLLocationManager *locationManager;

//- (void)_showAlertMessageWithTitle:(NSString *)title message:(NSString *)message;

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
  [[Common sharedStatus] setLastSelectedCoordinate:self.mapView.centerCoordinate];
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

- (IBAction)showMyLocationButton:(UIButton *)sender {
  self.mapView.centerCoordinate = self.mapView.userLocation.coordinate;
}

- (IBAction)searchButton:(UIButton *)sender {
  MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
  request.naturalLanguageQuery = self.searchTextField.text;
  MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];

  [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
		if (error) {
//			NSLog(@"Searching map error: %@", error);
//      [self _showAlertMessageWithTitle:@"搜尋地標時發生錯誤" message:@"搜尋地標時發生錯誤，請檢查網路狀態！"];
			[Common showAlertMessageWithTitle:@"搜尋地標時發生錯誤" message:@"搜尋地標時發生錯誤，請檢查網路狀態！" inViewController:self];
			
		} else if ([response.mapItems count] == 0){
//      [self _showAlertMessageWithTitle:@"找不到地標" message:@"找不到您想找的地標！"];
			[Common showAlertMessageWithTitle:@"找不到地標" message:@"找不到您想找的地標！" inViewController:self];

		} else {
			// 直接取第一項搜尋結果的座標
			MKMapItem *firstResult = [response.mapItems objectAtIndex:0];
			self.mapView.centerCoordinate = firstResult.placemark.coordinate;
		}
  }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  // 初次啟動MapView時儲存使用者所在位置，以便於viewDidAppear:讀出
  if ([[Common sharedStatus] isMapViewFirstStartUp]) {
    CLLocation *newLocation = [locations lastObject];
    [[Common sharedStatus] setLastSelectedCoordinate:newLocation.coordinate];
    [[Common sharedStatus] setIsMapViewFirstStartUp:NO];
  }
}

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
  if (error) {
    //    NSLog(@"MapView loading error: %@", error);
    //    [self _showAlertMessageWithTitle:@"讀取地圖資訊錯誤" message:@"讀取地圖資訊時發生錯誤，請檢查網路狀態！"];
    [Common showAlertMessageWithTitle:@"讀取地圖資訊錯誤" message:@"讀取地圖資訊時發生錯誤，請檢查網路狀態！" inViewController:self];
  }
}
//
//#pragma mark - Helper methods
//
//- (void)_showAlertMessageWithTitle:(NSString *)title message:(NSString *)message {
//  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//  [alertController addAction:okAction];
//  [self presentViewController:alertController animated:YES completion:nil];
//}

@end