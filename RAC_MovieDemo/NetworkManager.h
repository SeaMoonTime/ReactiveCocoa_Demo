//
//  NetworkManager.h
//  GNSSOrderTool
//
//  Created by Yang on 02/05/2017.
//  Copyright © 2017 leica-geosystems. All rights reserved.
//

//封装网络库读取json数据


#import <Foundation/Foundation.h>

@class NetworkManager;

//block回调传值
/**
 *   请求成功回调json数据
 *
 *  @param json json串
 */
typedef void(^Success)(id json);
/**
 *  请求失败回调错误信息
 *
 *  @param error error错误信息
 */
typedef void(^Failure)(NSError *error);



@interface NetworkManager : NSObject

+(NetworkManager *)manager;

/**
 *  GET请求
 *
 *  @param url       NSString 请求url
 *  @param paramters NSDictionary 参数
 *  @param success   void(^Success)(id json)回调
 *  @param failure   void(^Failure)(NSError *error)回调
 */
-(void)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;

/**
 *  POST请求
 *
 *  @param url       NSString 请求url
 *  @param paramters NSDictionary 参数
 *  @param success   void(^Success)(id json)回调
 *  @param failure   void(^Failure)(NSError *error)回调
 */
-(void)postDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;



@end
