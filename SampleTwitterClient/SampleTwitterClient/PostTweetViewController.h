//
//  PostTweetViewController.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTweetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *twitterTextView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)postTweetButtonPressed:(id)sender;

@end
