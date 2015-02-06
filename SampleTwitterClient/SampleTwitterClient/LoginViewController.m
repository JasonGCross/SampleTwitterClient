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
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.passwordTextField.text = nil;
    [self loginToTwitter];
}

#pragma mark - Twitter

- (void) loginToTwitter {
    ACAccountStore * accountStore = [[ACAccountStore alloc]init];
    ACAccountType * twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
        if (NO == granted) {
            NSLog(@"permission denied to twitter account store");
            if (nil != error) {
                [UIAlertView showWithError:error];
            }
        }
        else {
            // log in to a single user's account, for development and testing only
            // https://dev.twitter.com/oauth/overview/application-owner-access-tokens
            ACAccountCredential * accountCredential = [[ACAccountCredential alloc]initWithOAuthToken:@"1499396000-y8GRiXrI9N2xX4hhLkc8wy7nynyh0FK2CjkKyN7"
                                                                                         tokenSecret:@"ZniBNmt7ZY4lT83SGBeDVIrsoSquz00k821DMBfjxEsVO"];
            
            ACAccount * twitterAccount = [[ACAccount alloc]initWithAccountType:twitterAccountType];
            twitterAccount.credential = accountCredential;
            [accountStore saveAccount:twitterAccount withCompletionHandler:^(BOOL success, NSError *error) {
                if (NO == success) {
                    NSLog(@"Save of twitter account failed");
                    if (nil != error) {
                        [UIAlertView showWithError:error];
                    }
                }
                else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameTwitterLoginSuccess object:nil];
                }
            }];
        }
    }];
    
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
