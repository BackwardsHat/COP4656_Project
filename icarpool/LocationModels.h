//
//  LocationModels.h
//  icarpool
//
//  Created by XCode Developer on 7/21/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassengerModel : NSObject

@property NSMutableString* passengerID;
@property NSMutableString* firstName;
@property NSMutableString* lastName;
@property NSMutableString* currentAddress;
@property float currentLatitude;
@property float currentLongitude;
@property NSMutableString* phoneNumber;
@property NSMutableString* email;
@property NSMutableString* timeStamp;
@property bool hasDriver;
@property float destinationLatitude;
@property float destinationLongitude;
@property NSMutableString* destinationAddress;
@property int requestTimeLeft;

//@property NSMutableString * fullName;

-(void) printContents;

@end

@interface DriverModel : NSObject

@property NSMutableString* driverID;
@property NSMutableString* firstName;
@property NSMutableString* lastName;
@property NSMutableString* currentAddress;
@property float currentLatitude;
@property float currentLongitude;
@property NSMutableString* phoneNumber;
@property NSMutableString* email;

-(void) printContents;

@end
