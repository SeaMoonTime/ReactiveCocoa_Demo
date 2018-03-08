//
//  NetworkManager.m
//  GNSSOrderTool
//
//  Created by Yang on 02/05/2017.
//  Copyright © 2017 leica-geosystems. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "AFNetworking.h"


static NetworkManager *networkManager = nil;
static AFHTTPSessionManager *httpmanager = nil;

@implementation NetworkManager

+(NetworkManager *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[NetworkManager alloc]init];
        httpmanager = [AFHTTPSessionManager manager];
        //发送接收都采用json数据格式，接收格式默认为json
        httpmanager.requestSerializer = [AFJSONRequestSerializer serializer];
        httpmanager.responseSerializer = [AFJSONResponseSerializer serializer];
        //采用https协议
        httpmanager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        httpmanager.securityPolicy.allowInvalidCertificates = YES;
        [httpmanager.securityPolicy setValidatesDomainName:NO];
    });
    
    return networkManager;
}

-(void)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure{
    
    [httpmanager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success(responseObject);
        } else {
            [self showAlertViewWithMessage:@"暂无数据"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            [self showAlertViewWithMessage:@"服务器解析出错"];
            failure(error);
        }
    }];
    
}

-(void)postDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure{
    [httpmanager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success(responseObject);
        } else {
            [self showAlertViewWithMessage:@"暂无数据"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            [self showAlertViewWithMessage:@"请连接网络"];
            failure(error);
        }
    }];
    
}

-(void)showAlertViewWithMessage:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}




@end
