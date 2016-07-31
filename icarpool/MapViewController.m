//
//  MapViewController.m
//  icarpool
//
//  Created by XCode Developer on 7/20/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize locationManager;
@synthesize currentLocation;
@synthesize mapView;
@synthesize destinationLocation;
@synthesize rideSegmentControl;
@synthesize isPassenger;
@synthesize goToButton;
@synthesize currentUserPassengerModel;
@synthesize passengersArray;
@synthesize driversArray;
@synthesize chosenPassengerIndex;
@synthesize chosenPassenger;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mapView.delegate = self;
    
    [self startLocationManager];
    //[self zoomMap:3];
    [self showCurrentLocation];
    
    // Initialize arrays
    passengersArray = [[NSMutableArray alloc] init];
    driversArray = [[NSMutableArray alloc] init];
    rideSegmentControl.selectedSegmentIndex =-1;
    
    // Have nothing selected on startup
    if (!self.justLoggedIn) {
        if(isPassenger) {
            rideSegmentControl.selectedSegmentIndex = 0;
            [self retrieveDriverLocationData];
            goToButton.enabled = true;
            goToButton.hidden = false;
            NSLog(@"destination cords lat:%f  long: %f" , destinationLocation.coordinate.latitude, destinationLocation.coordinate.longitude);
        }
        else {
            // drivers dont need destinations
            goToButton.enabled = false;
            goToButton.hidden = true;
            destinationLocation = nil;
            
            rideSegmentControl.selectedSegmentIndex = 1;
            if(chosenPassenger) {
                [self addChosenPassenger];
            }
            else {
                [self retrievePassengerLocationData];
            }
        }
    }
    
    
    // current passenger information
    currentUserPassengerModel.currentLatitude = currentLocation.coordinate.latitude;
    currentUserPassengerModel.currentLongitude = currentLocation.coordinate.longitude;
    //currentUserPassengerModel.currentAddress = [self getAddress:currentLocation];
    currentUserPassengerModel.currentAddress = [NSMutableString stringWithString:@"FSU, Tallahassee, FL"];
    [currentUserPassengerModel printContents];
    
    [self postPassengerInformation];
    
    self.justLoggedIn = false;
}

-(void) addChosenPassenger {
    NSString * title = [NSString stringWithFormat:@"Client: %@ %@", chosenPassenger.firstName, chosenPassenger.lastName];
    CLLocation * loc = [[CLLocation alloc] initWithLatitude:chosenPassenger.currentLatitude longitude:chosenPassenger.currentLongitude];
    [self addAnnotation:title currentAddress:chosenPassenger.currentAddress currentLocation:loc];
}

- (IBAction)rideSegmentControlChange:(id)sender {
    NSInteger selectedSegment = rideSegmentControl.selectedSegmentIndex;
    // Clears current points
    [mapView removeAnnotations:mapView.annotations];
    
    chosenPassenger = nil;
    
    if(selectedSegment == 0) {
        // Rider looking for drivers
        isPassenger = true;
        goToButton.enabled = true;
        goToButton.hidden = false;
        [self retrieveDriverLocationData];
    }
    else if (selectedSegment == 1){
        // Driver looking for riders
        isPassenger = false;
        goToButton.enabled = false;
        goToButton.hidden = true;
        [self retrievePassengerLocationData];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Geolocation stuff
- (void)startLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; //whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    currentLocation = locationManager.location;
}

// Get current Location
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations lastObject];
}

// Zoom map in by given factor
-(void)zoomMap: (int) zoomFactor{
    MKMapRect rect = [mapView visibleMapRect];
    rect.size.width /= zoomFactor;
    rect.size.height /= zoomFactor;
    rect.origin.x += rect.size.width / zoomFactor;
    rect.origin.y += rect.size.height / zoomFactor;
    mapView.visibleMapRect = rect;
    mapView.showsUserLocation = YES;
}


// Focuses map around the current location
-(void)showCurrentLocation {
    MKCoordinateRegion region;
    region = MKCoordinateRegionMake(currentLocation.coordinate, MKCoordinateSpanMake(0.025, 0.025));
    NSLog(@"Showing location: %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    [mapView setCenterCoordinate:currentLocation.coordinate animated:NO];
    [mapView setRegion:region animated:YES];
}

- (IBAction)currentLocationClick:(id)sender {
    [self showCurrentLocation];
}

// Adds points to the map
-(void) addAnnotation:(NSString *) name
       currentAddress: (NSString *) address
      currentLocation: (CLLocation *) location {
    
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = name;
    point.subtitle = address;
    
    [mapView addAnnotation:point];
}

// Adds button too pin notes clicked
-(MKAnnotationView *) mapView:(MKMapView *) mV viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView * pinAnnotation = nil;
        
    NSLog(@"annotiation custom called!");
    
    if(annotation != mapView.userLocation && !chosenPassenger && !isPassenger) {
        pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"my Pin"];
        UIButton * moreInfoBtn =[UIButton buttonWithType:UIButtonTypeInfoLight];
        [moreInfoBtn addTarget:self action:@selector(showMoreInfo) forControlEvents:UIControlEventTouchUpInside];
        moreInfoBtn.tag = [mapView.annotations indexOfObject:annotation];
        
        pinAnnotation.canShowCallout = YES;
        pinAnnotation.rightCalloutAccessoryView = moreInfoBtn;
    }
    
    return pinAnnotation;
}


-(void)showMoreInfo {
    
    NSLog(@"more info clicked");
    
    [self performSegueWithIdentifier:@"mapToPassengerDetailViewSegue" sender:nil];
}

- (void)mapView:(MKMapView *)mV didSelectAnnotationView:(MKAnnotationView *)view {
    self.lastClickedAnnoation = [mV.annotations indexOfObject:view.annotation];
    NSLog(@"chosen title: %@", [[mV.annotations objectAtIndex:self.lastClickedAnnoation] title]);
    NSString * tmpTitle = [[mV.annotations objectAtIndex:self.lastClickedAnnoation] title];
    NSString * tmpFirstName = [tmpTitle componentsSeparatedByString:@" "][1];
    NSString * tmpLastName = [tmpTitle componentsSeparatedByString:@" "][2];
    
    NSLog(@"first: %@    last:%@", tmpFirstName, tmpLastName);
    
    // find element associated with passengers
    for(NSUInteger i = 0; i < [passengersArray count]; i++) {
        if( [[[passengersArray objectAtIndex:i] firstName] containsString:tmpFirstName] && [[[passengersArray objectAtIndex:i] lastName] containsString:tmpLastName]) {
            NSLog(@"FOUND");
            chosenPassengerIndex = i;
        }
    }
}

#pragma mark - Segue

- (IBAction)goToButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"mapToSettingsViewSegue" sender:sender];
}


// Segues into the mapViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [[segue identifier] isEqualToString:@"mapToSettingsViewSegue"]) {
        SettingsViewController * settingsVC = [segue destinationViewController];
        
        // This passenger is just for testing, real passenger data will be retrive from database [not implemented yet]        
        settingsVC.currentUserPassengerModel = currentUserPassengerModel;
    }
    
    if( [[segue identifier] isEqualToString:@"mapToPassengerDetailViewSegue"]) {
        PassengerDetailViewController * detailsVC = [segue destinationViewController];
        
        detailsVC.passenger = [passengersArray objectAtIndex:chosenPassengerIndex];
    }
}

#pragma mark - server stuff

// Get driver data from the server and fill driver array
- (void) retrieveDriverLocationData {
    // Send synchronous request
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:
                                [NSURL URLWithString:@"http://www.icarpoolforschool.com/drivers-service.php"]];
    NSURLResponse * reponse = nil;
    NSError * err = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&reponse error:&err];
    
    if(err == nil) {
        // Parse data here
        NSLog(@"Data retreived");
        NSError * parseErr = nil;
        id jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0
                                                          error:&parseErr];
        if(parseErr){
            NSLog(@"Data Parse Error");
        }
        
        // print results
        if(jsonResult != nil) {
            NSDictionary * tmp;
            
            for(int i = 0; i< [jsonResult count]; ++i) {
                tmp = [jsonResult objectAtIndex:i];
                
                /*
                NSLog(@"DriverID: %d" , i);
                NSLog(@"FirstName:%@", [tmp objectForKey:@"FirstName"]);
                NSLog(@"LastName:%@", [tmp objectForKey:@"LastName"]);
                NSLog(@"CurrentAddress:%@", [tmp objectForKey:@"CurrentAddress"]);
                NSLog(@"CurrentLatitude:%@", [tmp objectForKey:@"CurrentLatitude"]);
                NSLog(@"CurrentLongitude:%@", [tmp objectForKey:@"CurrentLongitude"]);
                NSLog(@"PhoneNumber:%@", [tmp objectForKey:@"PhoneNumber"]);
                NSLog(@"Email:%@", [tmp objectForKey:@"Email"]);
                NSLog(@"AvailableSeats:%@", [tmp objectForKey:@"AvailableSeats"]);
                NSLog(@"CarMake:%@", [tmp objectForKey:@"CarMake"]);
                NSLog(@"CarModel:%@", [tmp objectForKey:@"CarModel"]);
                NSLog(@"CarColor:%@", [tmp objectForKey:@"CarColor"]);
                NSLog(@" "); // spacing
                */
                
                DriverModel * d = [[DriverModel alloc] init];
                d.driverID = [tmp objectForKey:@"DriverID"];
                d.firstName = [tmp objectForKey:@"FirstName"];
                d.lastName = [tmp objectForKey:@"LastName"];
                d.currentAddress = [tmp objectForKey:@"CurrentAddress"];
                d.currentLatitude = [[tmp objectForKey:@"CurrentLatitude"] floatValue];
                d.currentLongitude = [[tmp objectForKey:@"CurrentLongitude"] floatValue];
                d.phoneNumber = [tmp objectForKey:@"PhoneNumber"];
                d.email = [tmp objectForKey:@"Email"];
                
                // Update if already exists
                if ( [driversArray count] > i && [[[driversArray objectAtIndex:i] email] isEqualToString:d.email]) {
                 
                    
                }
                else{
                    [driversArray insertObject:d atIndex:i];
                }
                
            
                NSString * driverName = [NSString stringWithFormat:@"Driver: %@ %@", [tmp objectForKey:@"FirstName"],
                                            [tmp objectForKey:@"LastName"]];
                NSString * driverCurrentAddress = [tmp objectForKey:@"CurrentAddress"];
                CLLocation * driverCurrentLocation = [[CLLocation alloc]
                                                         initWithLatitude:[[tmp objectForKey:@"CurrentLatitude"] floatValue]
                                                         longitude:[[tmp objectForKey:@"CurrentLongitude"] floatValue]];
                
               
                // Add Driver point too map
                [self addAnnotation:driverName currentAddress:driverCurrentAddress
                                                 currentLocation:driverCurrentLocation];
            }
        }
    }
}

- (void) retrievePassengerLocationData {
    
    // Send synchronous request
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:
                                [NSURL URLWithString:@"http://www.icarpoolforschool.com/passengers-service.php"]];
    NSURLResponse * reponse = nil;
    NSError * err = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&reponse error:&err];
    
    if(err == nil) {
        // Parse data here
        NSLog(@"Data retreived");
        NSError * parseErr = nil;
        id jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0
                                                          error:&parseErr];
        if(parseErr){
            NSLog(@"Data Parse Error");
        }
        
        // print results
        if(jsonResult != nil) {
            NSDictionary * tmp;
            
            for(int i = 0; i< [jsonResult count]; ++i) {
                tmp = [jsonResult objectAtIndex:i];
                
                
                NSLog(@"PassengerID: %d" , i);
                NSLog(@"FirstName:%@", [tmp objectForKey:@"FirstName"]);
                NSLog(@"LastName:%@", [tmp objectForKey:@"LastName"]);
                NSLog(@"CurrentAddress:%@", [tmp objectForKey:@"CurrentAddress"]);
                NSLog(@"CurrentLatitude:%@", [tmp objectForKey:@"CurrentLatitude"]);
                NSLog(@"CurrentLongitude:%@", [tmp objectForKey:@"CurrentLongitude"]);
                NSLog(@"PhoneNumber:%@", [tmp objectForKey:@"PhoneNumber"]);
                NSLog(@"Email:%@", [tmp objectForKey:@"Email"]);
                NSLog(@"TimeStamp:%@", [tmp objectForKey:@"TimeStamp"]);
                NSLog(@"HasDriver:%@", [tmp objectForKey:@"HasDriver"]);
                NSLog(@"DestinationLatitude:%@", [tmp objectForKey:@"DestinationLatitude"]);
                NSLog(@"DestinationLongitude:%@", [tmp objectForKey:@"DestinationLongitude"]);
                NSLog(@"DestinationAddress:%@", [tmp objectForKey:@"DestinationAddress"]);
                NSLog(@"RequestTimeLeft:%@", [tmp objectForKey:@"RequestTimeLeft"]);
                NSLog(@" "); // spacing
                 
                
                
                PassengerModel * p = [[PassengerModel alloc] init];
                p.passengerID = [tmp objectForKey:@"PassengerID"];
                p.firstName = [tmp objectForKey:@"FirstName"];
                p.lastName = [tmp objectForKey:@"LastName"];
                p.currentAddress = [tmp objectForKey:@"CurrentAddress"];
                p.currentLatitude = [[tmp objectForKey:@"CurrentLatitude"] floatValue];
                p.currentLongitude = [[tmp objectForKey:@"CurrentLongitude"] floatValue];
                p.phoneNumber = [tmp objectForKey:@"PhoneNumber"];
                p.email = [tmp objectForKey:@"Email"];
                //p.hasDriver = [tmp objectForKey:@"HasDriver"];
                if([tmp objectForKey:@"DestinationLatitude"])
                    p.destinationLatitude = [[tmp objectForKey:@"DestinationLatitude"] floatValue];
                if([tmp objectForKey:@"DestinationLongitude"])
                    p.destinationLongitude = [[tmp objectForKey:@"DestinationLongitude"] floatValue];
                if([tmp objectForKey:@"DestinationAddress"])
                    p.destinationAddress = [tmp objectForKey:@"DestinationAddress"];
                 
                
                
                // Update if already exists
                if ( [passengersArray count] > i && [[[passengersArray objectAtIndex:i] email] isEqualToString:p.email]) {
                    
                    
                }
                else{
                    [passengersArray insertObject:p atIndex:i];
                    NSLog(@"added object");
                }
                
                
                NSString * passengerName = [NSString stringWithFormat:@"Passenger: %@ %@", [tmp objectForKey:@"FirstName"],
                                                                        [tmp objectForKey:@"LastName"]];
                NSString * passengerCurrentAddress = [tmp objectForKey:@"CurrentAddress"];
                CLLocation * passengerCurrentLocation = [[CLLocation alloc]
                                                         initWithLatitude:[[tmp objectForKey:@"CurrentLatitude"] floatValue]
                                                                longitude:[[tmp objectForKey:@"CurrentLongitude"] floatValue]];
                // Add passenger point too map
                [self addAnnotation:passengerName currentAddress:passengerCurrentAddress
                                                 currentLocation:passengerCurrentLocation];
            }
        }
    }
}

// Inserts current passenger information to database
- (void) postPassengerInformation {
    NSLog(@"Posting to passenger database");
    NSString * requestStr = [NSString stringWithFormat:@"FirstName=%@&LastName=%@&CurrentAddress=%@&CurrentLatitude=%f&CurrentLongitude=%f&Email=%@&PhoneNumber=%@&DestinationLatitude=%f&DestinationLongitude=%f&DestinationAddress=%@",
                                currentUserPassengerModel.firstName, currentUserPassengerModel.lastName, currentUserPassengerModel.currentAddress,
                                currentUserPassengerModel.currentLatitude, currentUserPassengerModel.currentLongitude, currentUserPassengerModel.email,
                                currentUserPassengerModel.phoneNumber, currentUserPassengerModel.destinationLatitude,
                                currentUserPassengerModel.destinationLongitude, currentUserPassengerModel.destinationAddress];
    NSURL * domainStr = [NSURL URLWithString:@"http://www.icarpoolforschool.com/passengers-post-service.php?"];
    NSData * requestData = [NSData dataWithBytes:[requestStr UTF8String] length:[requestStr length]]; // create data from request
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:domainStr];
    NSError * err = nil;
    
    // set request type
    [request setHTTPMethod:@"POST"];
    // set content type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // set request body
    [request setHTTPBody:requestData];
    // send a request and get Response
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    
    if(err == nil) {
        // receive message back
        NSString * results = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
        NSLog(@"post results: %@", results);
    }
    else {
        NSLog(@"error: %@", err);
    }
}


@end
