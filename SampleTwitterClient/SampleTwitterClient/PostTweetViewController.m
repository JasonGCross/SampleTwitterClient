//
//  PostTweetViewController.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "PostTweetViewController.h"
#import "STCServiceLayer.h"
#import "UIAlertView+MKNetworkKitAdditions.h"



@interface PostTweetViewController ()

@end

@implementation PostTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:self completion:^{
        
    }];
}

- (IBAction)postTweetButtonPressed:(id)sender {
    NSString * twitterText = self.twitterTextView.text;
    [STCServiceLayer postTweetText:twitterText responseBlock:^(BOOL success, NSError *error) {
        if (success) {
            [self dismissViewControllerAnimated:self completion:^{
                
            }];
        }
        else if (nil != error) {
            [UIAlertView showWithError:error];
        }
    }];
}
@end
