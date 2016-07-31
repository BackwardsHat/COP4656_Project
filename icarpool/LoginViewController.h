//
//  ViewController.h
//  icarpool
//
//  Created by XCode Developer on 7/19/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationModels.h"

@interface LoginViewController : UIViewController<NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITableView* listTableView;
@property NSMutableData * reponseData;
@property NSDictionary * results;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@property PassengerModel * currentUserPassengerModel;
@property bool validLogin;

-(void) retrieveLocationData;

@end

