//
//  Movie.h
//  RAC_MovieDemo
//
//  Created by Yang on 15/01/2018.
//  Copyright © 2018 leica-geosystems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSString * year;
@property(nonatomic, strong) NSArray *casts;
@property(nonatomic, strong) NSArray *directors;
@property(nonatomic, strong) NSDictionary *images;
@property(nonatomic, strong) NSArray *genres;

+ (instancetype)movieWithDict:(NSDictionary *)dict;


@end
