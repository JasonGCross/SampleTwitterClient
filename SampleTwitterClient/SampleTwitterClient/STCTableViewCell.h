//
//  STCTableViewCell.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet;

@interface STCTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel* tweetCreationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel* tweetFavoritesCountLabel;

- (void) bindToData:(Tweet*)tweetData;

@end
