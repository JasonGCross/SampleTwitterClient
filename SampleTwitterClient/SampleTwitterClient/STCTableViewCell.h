//
//  STCTableViewCell.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGCSmartTableViewCell.h"

@class Tweet;
@class MKNetworkOperation;

@interface STCTableViewCell : JGCSmartTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView * userImageView;
@property (weak, nonatomic) IBOutlet UILabel* userFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* userScreentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* tweetCreationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel* tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel* tweetRetweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel* tweetFavoritesCountLabel;
@property (strong, nonatomic) MKNetworkOperation * networkOperation;

- (void) bindToData:(Tweet*)tweetData;

@end
