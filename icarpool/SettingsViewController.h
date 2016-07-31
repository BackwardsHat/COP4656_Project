//
//  SettingsViewController.h
//  icarpool
//
//  Created by XCode Developer on 7/21/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface SettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray *dataSourceArray;
@property (weak, nonatomic) NSMutableString *pickerCurrentChoice;

@property PassengerModel * currentUserPassengerModel;

@end
