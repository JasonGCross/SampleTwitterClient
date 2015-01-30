//
//  LoginViewController.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "LoginViewController.h"
#import "STCServiceLayer.h"
#import "STCGlobals.h"
#import "UIAlertView+MKNetworkKitAdditions.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(id)sender {
    NSString * username = self.usernameTextField.text;
    NSString * password = self.passwordTextField.text;
    
    if ((username.length < 1) || (password.length < 1)) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Missing Information"
                                                            message:@"Please make sure you complete the username and password information."
                                                           delegate:nil
                                                  cancelButtonTitle:@"O.K."
                                                  otherButtonTitles: nil];
        [alertView show];
    }
    else {
        [STCServiceLayer loginWithUsername:username password:password responseBlock:^(BOOL success, NSError *error) {
            if (success) {
                [self performSegueWithIdentifier:kLoginToMasterSegueId sender:self];
            }
            else if (nil != error) {
                [UIAlertView showWithError:error];
            }
        }];
    }
}

- (IBAction)twitterDotComButtonPressed:(id)sender {
    NSURL * url = [NSURL URLWithString:@"https://twitter.com/"];
    [[UIApplication sharedApplication] openURL:url];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
