//
//  MovieViewModel.h
//  RAC_MovieDemo
//
//  Created by Yang on 15/01/2018.
//  Copyright © 2018 seamoontime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface MovieViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *requestCommand;

@property (nonatomic, copy, readonly) NSArray *movies;


@end
