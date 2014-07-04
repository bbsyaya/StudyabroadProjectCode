//
//  AppDelegate.h
//  Studyabroad
//
//  Created by 姚东海 on 3/7/14.
//  Copyright (c) 2014年 zebra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSlideNavigationViewController.h"
#import "HomeTabController.h"
#import "Globle.h"
#import "HomeTabController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/**
 *  主模块容器
 */
@property(nonatomic,strong)HomeTabController * hometabController;

@property(nonatomic,strong)AppDelegate * delegate;
+(AppDelegate*)shareAppDelegate;
@end
