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
#import "STSNetworkEngine.h"
#import "MKNetworkOperation.h"


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
    [self.networkOperation cancel];
    self.networkOperation = nil;
    
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
    else {
        [self downloadImageForTweet:tweetData];
    }
    
    self.userFullNameLabel.text = tweetData.user.name;
    self.tweetTextLabel.text = tweetData.text;
    
    NSString * dateString = (nil == tweetData.created_at) ? @"" : [dateFormatter stringFromDate:tweetData.created_at];
    self.tweetCreationDateLabel.text = dateString;
    
    NSString * retweetString = [tweetData.retweet_count stringValue];
    self.tweetRetweetCountLabel.text = retweetString;
    
    NSString * favoriteString = [tweetData.favourite_count stringValue];
    self.tweetFavoritesCountLabel.text = favoriteString;
}

- (void) downloadImageForTweet:(Tweet*)tweetData; {
    NSString * imagePath = tweetData.user.profile_image_url;
    if (imagePath.length > 0) {
        STSNetworkEngine * sharedEngine = [STSNetworkEngine sharedInstance];
        NSURL * url = [NSURL URLWithString:imagePath];
        self.networkOperation = [sharedEngine imageAtURL:url completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
            tweetData.user.profile_image = fetchedImage;
            self.imageView.image = fetchedImage;
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            tweetData.user.profile_image = nil;
            self.imageView.image = nil;
        }];
    }
}


@end
