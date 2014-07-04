//
//  BaseViewController.h
//  TestAVOSPushDemo
//
//  Created by June on 14-4-4.
//  Copyright (c) 2014年 junewong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GlobalConfigure.h"

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate>

- (void)createBackgroundImage;
- (void)addSwipeGestureForGoingBack;

@end
