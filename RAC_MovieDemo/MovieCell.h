//
//  MovieCell.h
//  RAC_MovieDemo
//
//  Created by Yang on 16/01/2018.
//  Copyright © 2018 leica-geosystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYImage/YYImage.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *directors;
@property (weak, nonatomic) IBOutlet UILabel *casts;

@end
