//
//  AppConfig.m
//  ChainWar
//
//  Created by June on 14-4-9.
//  Copyright (c) 2014年 junewong. All rights reserved.
//

#import "AppConfig.h"
#import "config.h"
#import "OpenUDID.h"
@implementation AppConfig
@synthesize access_token=_access_token,user=_user,isLogin=_isLogin;
@synthesize accessTokenExpiration=_accessTokenExpiration,accessTokenType=_accessTokenType,flag=_flag;
@synthesize openId=_openId,pf=_pf,pfKey=_pfKey,platform=_platform,refreshTokenExpiration=_refreshTokenExpiration,refreshTokenType=_refreshTokenType,refreshTokenValue=_refreshTokenValue,updateTime=_updateTime;
@synthesize access_UserId=_access_UserId;
@synthesize describe=_describe;
@synthesize localAppId=_localAppId;
@synthesize redirectURI=_redirectURI;
@synthesize expirationDate=_expirationDate;
static AppConfig *_instance;

-(id)init{
    self=[super init];
    if (self) {
        [self initAppdata];
        _user=[UserData shareInstance];
        
    }
    return self;
}


+ (AppConfig *)shareInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}


/**
 *  初始化
 */
-(void)initAppdata{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString * token=[defaults objectForKey:TOKEN];
    NSString * openid=[defaults objectForKey:OPENID];
    if ([token isKindOfClass:[NSString class]]&&![token isEqualToString:@""]&&![openid isEqualToString:@""]&&[openid isKindOfClass:[NSString class]]) {
        _access_token=token;
        _openId=openid;
        _isLogin=[[defaults objectForKey:USER_STATE]boolValue];
        _expirationDate=[[defaults objectForKey:EXPIRATONDATE] doubleValue];
        _localAppId=[defaults objectForKey:LOCALAPPID];
        _redirectURI=[defaults objectForKey:REDIRECTURL];
  
    }
}

/**
 *  检测  登录
 *
 *  @return YES NO
 */
-(BOOL)isCheckLongin{
    if (_isLogin&&[_openId isKindOfClass:[NSString class]]&&![_openId isEqualToString:@""]&&![_access_token isEqualToString:@""]&&[_access_token isKindOfClass:[NSString class]]&&![self isTokenOverdue]) {
        return YES;
    }else{
        
        return NO;
    }
}

/**
 *  保存oauthinfo
 */
-(void)saveOauthInfo{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_access_token forKey:TOKEN];
    [defaults setObject:_openId forKey:OPENID];
    [defaults setBool:_isLogin forKey:USER_STATE];
    [defaults setDouble:_expirationDate forKey:EXPIRATONDATE];
    [defaults setObject:_localAppId forKey:LOCALAPPID];
    [defaults setObject:_redirectURI forKey:REDIRECTURL];
    
}







/**
 *  保存 access_token 到 NSUserDefaults 下次访问
 *
 *  @param access_token 访问用户信息
 */
-(void)setAccess_token:(NSString *)access_token{
    _access_token=access_token;
    _isLogin=OnlineState;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_access_token forKey:TOKEN];
    [defaults setBool:_isLogin forKey:USER_STATE];
}


/**
 *  注销用户信息
 */
-(void)cancellation{
    _access_token=nil;
    _isLogin=OfflineState;
    _openId=nil;
    _localAppId=nil;
    _expirationDate=0.0;
    [_user clearuserinfo];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_access_token forKey:TOKEN];
    [defaults setBool:_isLogin forKey:USER_STATE];
    [defaults setObject:_openId forKey:OPENID];
    [defaults setDouble:_expirationDate forKey:EXPIRATONDATE];
    [defaults setObject:_localAppId forKey:LOCALAPPID];
    [defaults setObject:_redirectURI forKey:REDIRECTURL];

}



+ (NSString*)appId
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    return [dict objectForKey:@"CFBundleIdentifier"];
    
}

+ (NSString*)deviceId
{
   // return @"0e04a9b6a10081dd6235d16de695769353d30660"; ///TEST
    return [OpenUDID value];
}

-(void)logoutattribute{
    LOG(@"openid---%@--token--%@---type----%d----accessTokenExpiration---%llu",_openId,_access_token,_accessTokenType,_accessTokenExpiration);

}

/**
 *  token 是否过期
 *
 *  @return YES or NO
 */
-(BOOL)isTokenOverdue{
    double curtdate=(double)[[NSDate date] timeIntervalSince1970];
    if (_expirationDate>curtdate) {
        return NO;
    }else{
        return YES;
    }

}
@end
