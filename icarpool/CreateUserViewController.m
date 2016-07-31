//
//  CreateUserViewController.m
//  icarpool
//
//  Created by XCode Developer on 7/25/16.
//  Copyright (c) 2016 XCode Developer. All rights reserved.
//

#import "CreateUserViewController.h"

@interface CreateUserViewController ()

@end

@implementation CreateUserViewController 


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hasError = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitButton:(id)sender
{
    self.hasError = false;
    if(self.firstName.text == nil || [self.firstName.text isEqualToString:@""])
    {
        self.hasError = true;
    }
    
    if(self.lastName == nil || [self.lastName.text isEqualToString:@""])
    {
        self.hasError = true;
    }
    
    if(self.phoneNumber == nil || [self.phoneNumber.text isEqualToString:@""])
    {
        self.hasError = true;
    }
    if(self.email == nil || [self.email.text isEqualToString:@""])
    {
        self.hasError = true;
    }
    if(self.password == nil || [self.password.text isEqualToString:@""])
    {
        self.hasError = true;
    }

    NSString *emailRegEx = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.+-]+.edu$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    
    //Valid email address
    /*
    if ([emailTest evaluateWithObject:self.email.text] == YES)
    {
        //Do Something
    }
    else
    {
        self.hasError = true;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"email must have .edu format"
                                                        message: nil
                                                       delegate: nil
                                              cancelButtonTitle: nil
                                              otherButtonTitles: @"Ok", nil];
        [alert show];
        NSLog(@"email not in proper format");
    }
    */
    if(self.hasError) {
        [self showErrorAlert];
    }
    else if ([emailTest evaluateWithObject:self.email.text] != YES) {
        self.hasError = true;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"email must have .edu format"
                                                        message: nil
                                                       delegate: nil
                                              cancelButtonTitle: nil
                                              otherButtonTitles: @"Ok", nil];
        [alert show];
        NSLog(@"email not in proper format");
    }
    else {
        [self postUserInfo];
        [self performSegueWithIdentifier:@"createToLoginSegue" sender:sender];
    }
   
}

- (IBAction)cancelButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"createToLoginSegue" sender:sender];
}

// and show error alert as
-(void) showErrorAlert
{
    UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"All Fields are mandatory." delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    [ErrorAlert show];
   
}


-(void) postUserInfo {
    NSLog(@"info posted");
    
    NSString * requestStr = [NSString stringWithFormat:@"FirstName=%@&LastName=%@&Email=%@&PhoneNumber=%@&Password=%@",
                             self.firstName.text, self.lastName.text, self.email.text,
                             self.phoneNumber.text, self.password.text];
    NSURL * domainStr = [NSURL URLWithString:@"http://www.icarpoolforschool.com/user-post-service.php?"];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [[segue identifier] isEqualToString:@"createToLoginSegue"]) {
        LoginViewController * loginVC = [segue destinationViewController];
        
    }
}



@end
