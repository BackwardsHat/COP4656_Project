//
//  PassengerDetailViewController.m
//  icarpool
//
//  Created by XCode Developer on 7/26/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

#import "PassengerDetailViewController.h"

@interface PassengerDetailViewController ()

@end


@implementation PassengerDetailViewController
@synthesize passenger;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.nameLabel.text, passenger.firstName, passenger.lastName];
    self.locationLabel.text = [NSString stringWithFormat:@"%@ %@", self.locationLabel.text, passenger.currentAddress];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@ %@", self.phoneLabel.text, passenger.phoneNumber];
    self.emailLabel.text = [NSString stringWithFormat:@"%@ %@", self.emailLabel.text, passenger.email];
    self.destinationLabel.text = [NSString stringWithFormat:@"%@ %@", self.destinationLabel.text, passenger.destinationAddress];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pickupButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"pickupToMapViewSegue" sender:sender];
}

- (IBAction)cancelButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"cancelToMapViewSegue" sender:sender];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [[segue identifier] isEqualToString:@"pickupToMapViewSegue"]) {
        MapViewController * mv = [segue destinationViewController];
        mv.isPassenger = false;
        passenger.hasDriver = true;
        mv.chosenPassenger = passenger;
        
    }
    else if( [[segue identifier] isEqualToString:@"cancelToMapViewSegue"]) {
        MapViewController * mv = [segue destinationViewController];
        mv.isPassenger = false;
        mv.chosenPassenger = nil;
    }
}


@end
