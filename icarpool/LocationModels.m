//
//  LocationModels.m
//  icarpool
//
//  Created by XCode Developer on 7/21/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

/*
@property NSMutableString* passengerID;
@property NSMutableString* firstName;
@property NSMutableString* lastName;
@property NSMutableString* currentAddress;
@property NSMutableString* currentLatitude;
@property NSMutableString* currentLongitude;
@property NSMutableString* phoneNumber;
@property NSMutableString* email;
@property NSMutableString* timeStamp;
@property NSMutableString* hasDriver;
@property NSMutableString* destinationLatitude;
@property NSMutableString* destinationLongitude;
@property NSMutableString* destinationAddress;
@property NSMutableString* requestTimeLeft;
*/

#import "LocationModels.h"

@implementation PassengerModel

- (id) initWithPassengerID: (NSMutableString *) passengerID
                 firstName: (NSMutableString *) firstName
                  lastName: (NSMutableString *) lastName
            currentAddress: (NSMutableString *) currentAddress
           currentLatitude: (float) currentLatitude
          currentLongitude: (float) currentLongitude
               phoneNumber: (NSMutableString *) phoneNumber
                     email: (NSMutableString *) email
                 timeStamp: (NSMutableString *) timeStamp
                 hasDriver: (bool) hasDriver
       destinationLatitude: (float) destinationLatitude
      destinationLongitude: (float) destinationLongitude
        destinationAddress: (NSMutableString*) destinationAddress
           requestTimeLeft: (int) requestTimeLeft

    {
    self = [super init];
    if(self) {
        self.passengerID = passengerID;
        self.firstName = firstName;
        self.lastName = lastName;
        //self.fullName = [NSMutableString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
        self.currentAddress = currentAddress;
        self.currentLatitude = currentLatitude;
        self.currentLongitude = currentLongitude;
        self.phoneNumber = phoneNumber;
        self.email = email;
        self.timeStamp = timeStamp;
        self.hasDriver = hasDriver;
        self.destinationLatitude = destinationLatitude;
        self.destinationLongitude = destinationLongitude;
        self.destinationAddress = destinationAddress;
        self.requestTimeLeft = requestTimeLeft;
    }
    return self;
}

-(void) printContents {
    NSLog(@"passengerID: %@", self.passengerID);
    NSLog(@"firstName: %@", self.firstName);
    NSLog(@"lastName: %@", self.lastName);
    NSLog(@"currentAddress: %@", self.currentAddress);
    NSLog(@"currentLatitude: %f", self.currentLatitude);
    NSLog(@"currentLongitude: %f", self.currentLongitude);
    NSLog(@"phoneNumber: %@", self.phoneNumber);
    NSLog(@"email: %@", self.email);
    NSLog(@"timeStamp: %@", self.timeStamp);
    NSLog(@"hasDriver: %d", self.hasDriver);
    NSLog(@"destinationLatitude: %f", self.destinationLatitude);
    NSLog(@"destinationLongitude: %f", self.destinationLongitude);
    NSLog(@"destinationAddress: %@", self.destinationAddress);
    NSLog(@"requestTimeLeft: %d", self.requestTimeLeft);
}

@end

@implementation DriverModel

- (id) initWithDriverID: (NSMutableString *) driverID
                 firstName: (NSMutableString *) firstName
                  lastName: (NSMutableString *) lastName
            currentAddress: (NSMutableString *) currentAddress
           currentLatitude: (float) currentLatitude
          currentLongitude: (float) currentLongitude
               phoneNumber: (NSMutableString *) phoneNumber
                     email: (NSMutableString *) email
{
    self = [super init];
    if(self) {
        self.driverID = driverID;
        self.firstName = firstName;
        self.lastName = lastName;
        self.currentAddress = currentAddress;
        self.currentLatitude = currentLatitude;
        self.currentLongitude = currentLongitude;
        self.phoneNumber = phoneNumber;
        self.email = email;
    }
    return self;
}

-(void) printContents {
    NSLog(@"driverID: %@", self.driverID);
    NSLog(@"firstName: %@", self.firstName);
    NSLog(@"lastName: %@", self.lastName);
    NSLog(@"currentAddress: %@", self.currentAddress);
    NSLog(@"currentLatitude: %f", self.currentLatitude);
    NSLog(@"currentLongitude: %f", self.currentLongitude);
    NSLog(@"phoneNumber: %@", self.phoneNumber);
    NSLog(@"email: %@", self.email);
}

@end

