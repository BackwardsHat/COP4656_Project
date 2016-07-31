//
//  PassengerDetailViewController.h
//  icarpool
//
//  Created by XCode Developer on 7/26/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationModels.h"
#import "MapViewController.h"

@interface PassengerDetailViewController : UIViewController
@property PassengerModel * passenger;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;

@end
