//
//  SettingsViewController.m
//  icarpool
//
//  Created by XCode Developer on 7/21/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize picker;
@synthesize pickerCurrentChoice;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _dataSourceArray = @[@"Doak Campbell Stadium", @"Strozier Library", @"Dirac Library", @"Leach Recreation Center",
                          @"Main Campus Fields",@"Denny's/Traditions Garage",@"Dick Howser Stadium",@"College of Medicine",@"College of Law",
                          @"College of Music",@"Diffenbaugh",@"Oglesby Union"];
    picker.dataSource = self;
    picker.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Segue stuff

- (IBAction)SubmitButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"settingsToMapViewSugue" sender:sender];
}


// Segues into the mapViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [[segue identifier] isEqualToString:@"settingsToMapViewSugue"]) {
        MapViewController * mapVC = [segue destinationViewController];
        
        mapVC.isPassenger = true;
        mapVC.destinationLocation = [self getLocationFromAddress];
        self.currentUserPassengerModel.destinationLatitude = mapVC.destinationLocation.coordinate.latitude;
        self.currentUserPassengerModel.destinationLongitude = mapVC.destinationLocation.coordinate.longitude;
        self.currentUserPassengerModel.destinationAddress = pickerCurrentChoice;
        mapVC.currentUserPassengerModel = self.currentUserPassengerModel;

    }
    
}

-(CLLocation *) getLocationFromAddress {
    float latitude;
    float longitude;
    if ([pickerCurrentChoice isEqualToString:@"Doak Campbell Stadium"])
    {
        latitude = 30.4379465;
        longitude = -84.3022762;
        
    }
    else if ([pickerCurrentChoice isEqualToString:@"Strozier Library"])
    {
        latitude = 30.443264;
        longitude = -84.294949;
        
    }
    else if ([pickerCurrentChoice isEqualToString:@"Dirac Library"])
    {
        latitude = 30.445201;
        longitude = -84.299993;
        
    }
    else if ([pickerCurrentChoice isEqualToString:@"Main Campus Fields"])
    {
        latitude = 30.437776;
        longitude = -84.300659;
        
    }
    else if ([pickerCurrentChoice isEqualToString:@"Traditions Garage"])
    {
        latitude = 30.441837;
        longitude = -84.297865;
        
    }
    else if ([pickerCurrentChoice isEqualToString:@"Dick Howser Stadium"])
    {
        latitude = 30.440043;
        longitude = -84.303562;
        
    }
    else if ([pickerCurrentChoice isEqualToString:@"College of Medicine"])
    {
        latitude = 30.445465;
        longitude = -84.305614;
        
    }
    else if ([pickerCurrentChoice isEqualToString:@"College of Law"])
    {
        latitude = 30.439268;
        longitude = -84.286795;
        
    }
    else if ([pickerCurrentChoice isEqualToString:@"College of Music"])
    {
        latitude = 30.441867;
        longitude = -84.291398;
        
    }
    else if ([pickerCurrentChoice isEqualToString:@"Diffenbaugh"])
    {
        latitude = 30.440036;
        longitude = -84.291666;
        
    }
    else if ([pickerCurrentChoice isEqualToString:@"Oglesby Union"])
    {
        latitude = 30.444568;
        longitude = -84.297127;
        
    }
    
    // Doak: 30.4379465 longitude:-84.3022762];
    // Strozier: 30.443264, -84.294949
    // Dirac: 30.445201, -84.299993
    // Leach: 30.442218, -84.301823
    // Main Campus Fields: 30.437776, -84.300659
    // Denny's/Traditions Garage/Welness Center: 30.441837, -84.297865
    // Dick Howser Stadium: 30.440043, -84.303562
    // College of Medicine: 30.445465, -84.305614
    // College of Law: 30.439268, -84.286795
    // College of Music: 30.441867, -84.291398
    // Diffenbaugh: 30.440036, -84.291666
    // Oglesby Union/ Chilli's: 30.444568, -84.297127
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude]; //Doak Campbell Stadium
    return loc;
}

#pragma mark PickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *resultString = _dataSourceArray[row];
    
    _resultLabel.text = resultString;
}


#pragma mark PickerView DataSource

// Number of columns
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

// Number of rows
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  _dataSourceArray.count;
}

// data to return when row has been selected
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    pickerCurrentChoice = _dataSourceArray[row];
    return _dataSourceArray[row];
}


@end
