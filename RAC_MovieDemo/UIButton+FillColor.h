//
//  UIButton+FillColor.h
//  RAC_MovieDemo
//
//  Created by Yang on 15/01/2018.
//  Copyright © 2018 seamoontime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FillColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
+ (UIImage *)imageWithColor:(UIColor *)color ;

@end
