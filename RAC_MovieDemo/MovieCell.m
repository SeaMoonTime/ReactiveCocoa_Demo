//
//  MovieCell.m
//  RAC_MovieDemo
//
//  Created by Yang on 16/01/2018.
//  Copyright © 2018 leica-geosystems. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.title sizeThatFits:size].height;
    totalHeight += [self.year sizeThatFits:size].height;
    totalHeight += [self.directors sizeThatFits:size].height;
    totalHeight += [self.casts sizeThatFits:size].height;
    totalHeight += 50; // margins,line space
    CGFloat imageHeight = [self.imageView sizeThatFits:size].height + 16;
    totalHeight = (totalHeight>imageHeight) ? totalHeight : imageHeight;
    
    totalHeight += 20;
    
   
    
    return CGSizeMake(size.width, totalHeight);
}

@end
