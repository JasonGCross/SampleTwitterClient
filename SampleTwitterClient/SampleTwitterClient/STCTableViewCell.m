//
//  STCTableViewCell.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "STCTableViewCell.h"
#import "Tweet.h"



static NSDateFormatter * dateFormatter;

@implementation STCTableViewCell

+(void) initialize {
    [super initialize];
    
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.tweetTextLabel.text = nil;
    self.tweetCreationDateLabel.text = nil;
    self.tweetFavoritesCountLabel.text = 0;
}

- (void) bindToData:(Tweet*)tweetData; {
    self.tweetTextLabel.text = tweetData.text;
    
    NSString * dateString = (nil == tweetData.created_at) ? @"" : [dateFormatter stringFromDate:tweetData.created_at];
    self.tweetCreationDateLabel.text = dateString;
    
    NSString * favoriteString = [tweetData.favourites_count stringValue];
    self.tweetFavoritesCountLabel.text = favoriteString;
}

@end
