//
//  Movie.m
//  RAC_MovieDemo
//
//  Created by Yang on 15/01/2018.
//  Copyright © 2018 seamoontime. All rights reserved.
//

#import "Movie.h"

@implementation Movie

+(instancetype)movieWithDict:(NSDictionary *)dict{
    Movie *movie = [[Movie alloc]init];
    movie.year = dict[@"year"];
    movie.title = dict[@"title"];
    movie.casts = dict[@"casts"];
    movie.directors = dict[@"directors"];
    movie.images = dict[@"images"];
    movie.genres = dict[@"genres"];
    
    return movie;
}

-(NSString *)description{
    NSString *desc = [NSString stringWithFormat:@"title=%@,year=%@,casts=%@,directors=%@,images=%@,genres=%@",_title,_year,_casts.description,_directors,_images.description,_genres];
    return desc;
}

@end
