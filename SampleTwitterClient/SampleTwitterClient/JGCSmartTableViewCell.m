//
//  JGCSmartTableViewCell.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/8/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "JGCSmartTableViewCell.h"

@implementation JGCSmartTableViewCell

#pragma mark - Smart table view cell common initializers.

// this is intended to be overridden by sub classes
- (id)initWithCellIdentifier:(NSString *)cellIdentifier {
    return [self initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:cellIdentifier];
}

+ (NSString *)cellIdentifier {
    [NSException raise:NSInternalInconsistencyException format:@"WARNING: YOU MUST OVERRIDE THIS GETTER IN YOUR CUSTOM CELL .M FILE"];
    static NSString* _cellIdentifier = nil;
    _cellIdentifier = NSStringFromClass([self class]);
    return _cellIdentifier;
}

// subclasses may override this if they choose to use a non-conventional nib name
+ (NSString *)nibName {
    return [self cellIdentifier];
}

+(id)cellForTableView:(UITableView*)tableView fromNib:(UINib*)nib{
    
    NSString *cellIdentifier = [self cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // as of iOS 5, we should be registering the nib with the table view, using
    // registerNib:forCellReuseIdentifier:
    // If this is done, then the table view will look after creating a new cell when needed,
    // and the condition below will never be met.
    // However, as a safeguard (in case the caller forgets to register the nib),
    // we will look after creating new cells from the nib ourselves.
    // It is important not to just use the normal alloc..init.. or the nib will
    // not be used to create the new cell, and all the IBOutlets will be nil
    if (cell == nil) {
        // we should only have to register a cell with a table view once
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        
        // but continue getting a table cell after it's been registered anyway
        NSArray * nibObjects = [nib instantiateWithOwner:self options:nil];
        
        NSAssert2(([nibObjects count] > 0) &&
                  [[nibObjects objectAtIndex:0] isKindOfClass:[self class]],
                  @"Nib '%@' does not appear to contain a value %@",
                  [self nibName], NSStringFromClass([self class]));
        cell = nibObjects[0];
    }
    return cell;
}

+(id)cellForTableView:(UITableView*)tableView; {
    return [[self class] cellForTableView:tableView fromNib:[self nib]];
}

+(UINib*)nib; {
    NSBundle * classBundle = [NSBundle bundleForClass:[self class]];
    UINib * nib = [UINib nibWithNibName:[self nibName] bundle:classBundle];
    return nib;
}

-(CGRect)tableCellContentRect{
    // Override for custom filling logic.
    return CGRectMake(self.customTableCellContentSpacing,
                      0,
                      self.frame.size.width-(self.customTableCellContentSpacing*2),
                      self.frame.size.height-self.customTableCellContentSpacing);
}

-(UIColor*)customContentSpacerColor{
    if(_customContentSpacerColor == nil){
        _customContentSpacerColor = [UIColor lightGrayColor];
    }
    return  _customContentSpacerColor;
}

-(CGFloat)customTableCellContentSpacing{
    if(_customTableCellContentSpacing == 0){
        _customTableCellContentSpacing = 10.0f;
    }
    return  _customTableCellContentSpacing;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    /* Get the current graphics context */
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextSetShouldAntialias(currentContext, false);
    
    // Fill the background.
    UIColor *backgroundFillColor =  self.customContentSpacerColor;
    if ((nil != backgroundFillColor) && ([UIColor clearColor] != backgroundFillColor)) {
        
        CGPoint startPoint = CGPointMake(0.0f, rect.size.height);
        CGPoint finishPoint = CGPointMake(rect.size.width, rect.size.height);
        
        /* Set the width for the line */
        CGContextSetLineWidth(currentContext,
                              1.0f);
        
        /* Start the line at this point */
        CGContextMoveToPoint(currentContext,
                             startPoint.x,
                             startPoint.y);
        
        /* And end it at this point */
        CGContextAddLineToPoint(currentContext,
                                finishPoint.x,
                                finishPoint.y);
        
        /* Set the color that we want to use to draw the line */
        [backgroundFillColor set];
        
        /* Use the context's current color to draw the line */
        CGContextStrokePath(currentContext);
    }
    
    // Fill the content background.
    UIColor *contentFillColor =  self.customContentBackgroundColor;
    if ((nil != contentFillColor) && ([UIColor clearColor] != contentFillColor)) {
        [contentFillColor setFill];
        UIRectFill(CGRectInset([self tableCellContentRect], 0, 0));
    }
    
    CGContextRestoreGState(currentContext);
}

@end
