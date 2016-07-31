//
//  ViewController.m
//  icarpool
//
//  Created by XCode Developer on 7/19/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingsViewController.h"

@interface LoginViewController ()
@end


@implementation LoginViewController

@synthesize listTableView;
@synthesize currentUserPassengerModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if(!currentUserPassengerModel) {
        currentUserPassengerModel = [[PassengerModel alloc] init];
    }
}

- (IBAction)loginButtonClick:(id)sender {
    if([self postLoginInfo]) {
        self.emailLabel.textColor = [UIColor blackColor];
        self.passwordLabel.textColor = [UIColor blackColor];
        [self performSegueWithIdentifier:@"loginToMapSegue" sender:sender];
    }
    else {
        self.emailLabel.textColor = [UIColor redColor];
        self.passwordLabel.textColor = [UIColor redColor];
        UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:@"Login Fail"
                                                             message:@"Email/Password combination not found" delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [ErrorAlert show];
        
    }
}


// Segues into the mapViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [[segue identifier] isEqualToString:@"loginToMapSegue"]) {
        MapViewController * mapVC = [segue destinationViewController];
        
        // This passenger is just for testing, real passenger data will be retrive from database [not implemented yet]
        
        currentUserPassengerModel.firstName = [NSMutableString stringWithString:@"John"];
        currentUserPassengerModel.lastName = [NSMutableString stringWithString:@"Smith"];
        currentUserPassengerModel.email = [NSMutableString stringWithString:@"John@my.fsu.edu"];
        currentUserPassengerModel.phoneNumber = [NSMutableString stringWithString:@"1234567"];
        
        mapVC.currentUserPassengerModel = currentUserPassengerModel;
        mapVC.justLoggedIn = true;
        mapVC.rideSegmentControl.selectedSegmentIndex = -1;
        NSLog(@"Segue from login to map");
    }
    
}


- (bool) postLoginInfo {
    NSLog(@"info posted: %@, %@", self.email.text, self.password.text);
    bool validLogin = false;
    
    NSString * requestStr = [NSString stringWithFormat:@"Email=%@&Password=%@",
                             self.email.text,
                             self.password.text];
    NSURL * domainStr = [NSURL URLWithString:@"http://www.icarpoolforschool.com/login-service.php?"];
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
        if([results containsString:@"failure"]) {
            validLogin = false;
        }
        else {
            validLogin = true;
        }
        
    }
    else {
        NSLog(@"error: %@", err);
    }
    
    NSLog(@"login status: %d", validLogin);
    return validLogin;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
