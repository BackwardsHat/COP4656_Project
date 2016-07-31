//
//  MapViewController.h
//  icarpool
//
//  Created by XCode Developer on 7/20/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationModels.h"
#import "SettingsViewController.h"
#import "PassengerDetailViewController.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic) CLLocationManager * locationManager;
@property CLLocation * currentLocation;
@property CLLocation * destinationLocation;

@property NSMutableArray * passengersArray;
@property NSMutableArray * driversArray;

@property PassengerModel * currentUserPassengerModel;
@property DriverModel * currentDriverModel;

@property NSUInteger chosenPassengerIndex;
@property NSUInteger lastClickedAnnoation;

@property PassengerModel * chosenPassenger;

@property (weak, nonatomic) IBOutlet UISegmentedControl *rideSegmentControl;
@property (weak, nonatomic) IBOutlet UIButton *goToButton;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;

@property (nonatomic) bool isPassenger;
@property bool justLoggedIn;


@end
