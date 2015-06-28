//
//  MapViewController.h
//  Fake-Check-in
//
//  Created by shoshino21 on 5/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

- (IBAction)backToMapView:(UIStoryboardSegue *)segue;

@end
