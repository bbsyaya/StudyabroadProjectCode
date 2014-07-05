//
//  ServerInterface.m
//  TamingMonster
//
//  Created by June on 14-4-16.
//  Copyright (c) 2014年 junewong. All rights reserved.
//

#import "ServerInterface.h"
#import "AppConfig.h"
@implementation ServerInterface

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.apiUrl  = SEVER_URL;
        self.apiKey  = SEVER_API_KEY;
        self.apiPath = @"";
        self.autoShowErrorMessage = YES;
    }
    return self;
}

+ (id)serverInterface
{
    return [[[self class] alloc] init];
}

#pragma mark - block methods

- (void)setFinishedBlock:(ServerInterfaceFinished)block
{
    finishedBlock = block;
}

- (void)setLoadingBlock:(ServerInterfaceLoading)block
{
    loadingBlock = block;
}

- (void)setErrorBlock:(ServerInterfaceError)block
{
    errorBlock = block;
}

- (void)setFailBlock:(ServerInterfaceFaild)block
{
    failBlock = block;
}

- (void)setSuccessBlock:(ServerInterfaceSuccess)block
{
    successBlock = block;
}

- (void)setPauseDataBlock:(ServerInterfacePauseData)block
{
    pauseDataBlock = block;
}


- (void)getWithParams:(NSDictionary*)params
              success:(ServerInterfaceSuccess)successCallback
                 fail:(ServerInterfaceFaild)failCallback
              loading:(ServerInterfaceLoading)loadingCallback
{
    [self getWithParams:params success:successCallback fail:failCallback loading:loadingCallback error:nil];
}

- (void)getWithParams:(NSDictionary*)params
              success:(ServerInterfaceSuccess)successCallback
              loading:(ServerInterfaceLoading)loadingCallback
{
    [self getWithParams:params success:successCallback fail:nil loading:loadingCallback error:nil];
}



/**
 *  get 请求网络数据
 *
 *  @param params          请求参数
 *  @param successCallback 成功
 *  @param failCallback   失败
 *  @param loadingCallback 加载
 *  @param errorCallback   网络错误
 */
- (void)getWithParams:(NSDictionary*)params
              success:(ServerInterfaceSuccess)successCallback
                 fail:(ServerInterfaceFaild)failCallback
              loading:(ServerInterfaceLoading)loadingCallback
                error:(ServerInterfaceError)errorCallback
{
    AFHTTPClient *jsonapiClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:self.apiUrl]];
 
    if (![params isKindOfClass:[NSDictionary class]]||params==nil) {
        params=[[NSDictionary alloc]init];
    }
    NSMutableDictionary *finalParams = [params mutableCopy];
    
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    
    [finalParams setObject:[self createSignStringWithTimpstamp:timestamp] forKey:@"sign"];
    [finalParams setObject:[NSString stringWithFormat:@"%.0f", timestamp] forKey:@"time"];
    [finalParams setObject:@"2" forKey:@"clienttype"];
    [finalParams setObject:[AppConfig deviceId] forKey:@"deviceid"];
    
    if ([AppConfig shareInstance].isLogin==OnlineState&&[[AppConfig shareInstance].openId isKindOfClass:[NSString class]]) {
        [finalParams setObject:[AppConfig shareInstance].openId forKey:@"userid"];

    }
    
    if (loadingCallback) {
        loadingCallback(YES);
    }
    
    [jsonapiClient getPath:self.apiPath
                parameters:finalParams
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       
                       __block NSString *jsonString = ((AFURLConnectionOperation*)operation).responseString;
                      LOG(@"get-respon---%@",jsonString);
                       jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                       NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                       NSNumber *code = [responseDictionary objectForKey:@"status"];
                       
                       if ( ([code isKindOfClass:[NSNumber class]] && [code intValue] == 1)
                           || ([code isKindOfClass:[NSString class]] && [(NSString*)code isEqualToString:@"ok"])) {
                           if (successCallback) {
                               //result posts
                               NSDictionary *resultData = [responseDictionary objectForKey:@"result"];
                               if ((![resultData isKindOfClass:[NSNull class]]&&resultData!=nil)){
                                   successCallback(operation, resultData, responseDictionary);
                               }else{
                                   successCallback(operation, nil, responseDictionary);

                               }
                           }
                           
                       }else {
                           if (failCallback) {
                               NSString * error_message=[responseDictionary objectForKey:@"msg"];
                               
                               if ([error_message isKindOfClass:[NSString class]]) {
                                   failCallback(operation, error_message, responseDictionary);

                               }else{
                                   failCallback(operation, [NSString stringWithFormat:@"%@",  code], responseDictionary);
                               }
                           }
                           
                       }
                       
                       if (loadingCallback) {
                           loadingCallback(NO);
                       }
                   }
     
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       
                       if ([error isKindOfClass:[NSError class]]) {
                           if (errorCallback) {
                               errorCallback(operation, error);
                           }
                           
                       } else if(self.autoShowErrorMessage) {
                           
                           [UIAlertViewUtil showAlertErrorTipLimitTimeWithMessage:@"请求发生错误，请重试！"];
                       }
                       if (loadingCallback) {
                           loadingCallback(NO);
                       }
                   }];

}


/**
 *  post 请求网络数据
 *
 *  @param params          请求参数
 *  @param successCallback 成功
 *  @param failCallback   失败
 *  @param loadingCallback 加载
 *  @param errorCallback   网络错误
 */
- (void)postWithParams:(NSDictionary*)params
              success:(ServerInterfaceSuccess)successCallback
                 fail:(ServerInterfaceFaild)failCallback
              loading:(ServerInterfaceLoading)loadingCallback
                error:(ServerInterfaceError)errorCallback
{
    AFHTTPClient *jsonapiClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:self.apiUrl]];
    if (![params isKindOfClass:[NSDictionary class]]||params==nil) {
        params=[[NSDictionary alloc]init];
    }
    NSMutableDictionary *finalParams = [params mutableCopy];
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    [finalParams setObject:[self createSignStringWithTimpstamp:timestamp] forKey:@"sign"];
    [finalParams setObject:[NSString stringWithFormat:@"%.0f", timestamp] forKey:@"time"];
    [finalParams setObject:@"2" forKey:@"clienttype"];
    [finalParams setObject:[AppConfig deviceId] forKey:@"deviceid"];

    if ([AppConfig shareInstance].isLogin==OnlineState&&[[AppConfig shareInstance].openId isKindOfClass:[NSString class]]) {
        [finalParams setObject:[AppConfig shareInstance].openId forKey:@"userid"];
        
    }
    if (loadingCallback) {
        loadingCallback(YES);
    }
    
    [jsonapiClient getPath:self.apiPath
                parameters:finalParams
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       
                       __block NSString *jsonString = ((AFURLConnectionOperation*)operation).responseString;
                       LOG(@"get-respon---%@",jsonString);
                       jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                       NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                       NSNumber *code = [responseDictionary objectForKey:@"status"];
                       
                       if ( ([code isKindOfClass:[NSNumber class]] && [code intValue] == 1)
                           || ([code isKindOfClass:[NSString class]] && [(NSString*)code isEqualToString:@"ok"])) {
                           if (successCallback) {
                               //result posts
                               NSDictionary *resultData = [responseDictionary objectForKey:@"result"];
                               if ((![resultData isKindOfClass:[NSNull class]]&&resultData!=nil)){
                                   successCallback(operation, resultData, responseDictionary);
                               }else{
                                   successCallback(operation, nil, responseDictionary);
                                   
                               }
                           }
                           
                       }else {
                           if (failCallback) {
                               NSString * error_message=[responseDictionary objectForKey:@"msg"];
                               
                               if ([error_message isKindOfClass:[NSString class]]) {
                                   failCallback(operation, error_message, responseDictionary);
                                   
                               }else{
                                   failCallback(operation, [NSString stringWithFormat:@"%@",  code], responseDictionary);
                               }
                           }
                           
                       }
                       
                       if (loadingCallback) {
                           loadingCallback(NO);
                       }
                   }
     
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       
                       if ([error isKindOfClass:[NSError class]]) {
                           if (errorCallback) {
                               errorCallback(operation, error);
                           }
                           
                       } else if(self.autoShowErrorMessage) {
                           
                           [UIAlertViewUtil showAlertErrorTipLimitTimeWithMessage:@"请求发生错误，请重试！"];
                       }
                       if (loadingCallback) {
                           loadingCallback(NO);
                       }
                   }];

}



- (NSString*)createSignStringWithTimpstamp:(NSTimeInterval)timestamp
{
    NSString *string = [NSString stringWithFormat:@"%@%.0f", self.apiKey, timestamp];
    
    NSString *sign = [string md5];
    return sign;
}

@end
