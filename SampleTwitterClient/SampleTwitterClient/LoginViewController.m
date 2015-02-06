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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(id)sender {
    // 2015-02-15 jcross: changed this prototype from using username / password to just hard-coding to single user authentication against Twitter using OAuth
    
    [STCServiceLayer loginDeveloperAccountUsingResponseBlock:^(BOOL success, NSError *error) {
        if (success) {
            [self performSegueWithIdentifier:kLoginToMasterSegueId sender:self];
        }
        else if (nil != error) {
            [UIAlertView showWithError:error];
        }
    }];
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
