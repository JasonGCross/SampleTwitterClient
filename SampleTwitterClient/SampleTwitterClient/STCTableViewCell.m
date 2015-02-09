//
//  STCTableViewCell.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "STCTableViewCell.h"
#import "Tweet.h"
#import "User.h"



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

+ (NSString *)cellIdentifier {
    static NSString* _cellIdentifier = nil;
    _cellIdentifier = NSStringFromClass([self class]);
    return _cellIdentifier;
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;

    
    self.userFullNameLabel.text = nil;
    self.userScreentNameLabel.text = nil;
    self.tweetCreationDateLabel.text = nil;
    self.tweetTextLabel.text = nil;
    self.tweetRetweetCountLabel.text = nil;
    self.tweetFavoritesCountLabel.text = 0;
}

- (void) bindToData:(Tweet*)tweetData; {
    UIImage * image = tweetData.user.profile_image;
    if (nil != image) {
        self.imageView.image = image;
    }
    
    self.userFullNameLabel.text = tweetData.user.name;
    NSString * screenNameString = nil;
    if (nil != tweetData.user.screen_name) {
        screenNameString = [NSString stringWithFormat:@"@%@", tweetData.user.screen_name];
    }
    self.userScreentNameLabel.text = screenNameString;
    self.tweetTextLabel.text = tweetData.text;
    
    NSString * dateString = (nil == tweetData.created_at) ? @"" : [dateFormatter stringFromDate:tweetData.created_at];
    self.tweetCreationDateLabel.text = dateString;
    
    NSString * retweetString = [tweetData.retweet_count stringValue];
    self.tweetRetweetCountLabel.text = retweetString;
    
    NSString * favoriteString = [tweetData.favourite_count stringValue];
    self.tweetFavoritesCountLabel.text = favoriteString;
}



@end
