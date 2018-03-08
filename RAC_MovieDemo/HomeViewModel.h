//
//  HomeViewModel.h
//  RAC_MovieDemo
//
//  Created by Yang on 15/01/2018.
//  Copyright © 2018 leica-geosystems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface HomeViewModel : NSObject
@property (nonatomic, copy) NSString *searchConditons;

@property (nonatomic, strong, readonly) RACSignal  *searchBtnEnableSignal;
@end
