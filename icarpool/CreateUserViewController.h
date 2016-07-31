//
//  CreateUserViewController.h
//  icarpool
//
//  Created by XCode Developer on 7/25/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationModels.h"
#import "LoginViewController.h"


@interface CreateUserViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property bool hasError;

@property PassengerModel * userInfo;

- (IBAction)submitButton:(id)sender;

@end
