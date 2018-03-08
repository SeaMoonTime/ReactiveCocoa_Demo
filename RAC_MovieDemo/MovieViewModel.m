//
//  MovieViewModel.m
//  RAC_MovieDemo
//
//  Created by Yang on 15/01/2018.
//  Copyright © 2018 leica-geosystems. All rights reserved.
//

#import "MovieViewModel.h"
#import "NetworkManager.h"
#import "Movie.h"


@implementation MovieViewModel

-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"%@", input);
        
        
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NetworkManager *manager = [NetworkManager manager];
            [manager getDataWithUrl:@"https://api.douban.com/v2/movie/search" parameters:input success:^(id json) {
                NSDictionary *dict = (NSDictionary *)json;
                NSLog(@"%@",dict);
                [subscriber sendNext:json];
                [subscriber sendCompleted];
            } failure:^(NSError *error) {
                
            }];
            
            return nil;
        }];
        return [requestSignal map:^id _Nullable(id  _Nullable value) {
            NSMutableArray *dictArray = value[@"subjects"];
            NSArray *modelArray = [dictArray.rac_sequence map:^id(id value) {
                return [Movie movieWithDict:value];
            }].array;
           NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO];
            _movies = [modelArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            NSLog(@"%@",_movies.description);
            
            return nil;
        }];
    }];
    
}

@end
