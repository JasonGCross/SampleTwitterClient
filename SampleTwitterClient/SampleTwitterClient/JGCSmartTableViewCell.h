//
//  JGCSmartTableViewCell.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/8/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGCSmartTableViewCell : UITableViewCell
@property (strong, nonatomic) UIColor *customContentBackgroundColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *customContentSpacerColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,assign) CGFloat customTableCellContentSpacing UI_APPEARANCE_SELECTOR;

+(NSString*)cellIdentifier;
+(id)cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib;
+(id)cellForTableView:(UITableView*)tableView;
+(UINib*)nib;
-(CGRect)tableCellContentRect;
@end
