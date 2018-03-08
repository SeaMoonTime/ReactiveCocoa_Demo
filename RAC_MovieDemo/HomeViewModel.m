//
//  HomeViewModel.m
//  RAC_MovieDemo
//
//  Created by Yang on 15/01/2018.
//  Copyright © 2018 leica-geosystems. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

-(instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self setupSearchBtnEnableSignal];
}

- (void)setupSearchBtnEnableSignal {
    _searchBtnEnableSignal = [RACSignal combineLatest:@[RACObserve(self, searchConditons)] reduce:^id(NSString *searchConditions){
        return @(searchConditions.length);
    }];
}

@end
