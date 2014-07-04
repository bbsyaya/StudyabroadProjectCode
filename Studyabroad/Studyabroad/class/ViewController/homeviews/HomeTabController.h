//
//  HomeTabController.h
//  GameStrategys
//
//  Created by 姚东海 on 5/5/14.
//  Copyright (c) 2014年 junewong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMFilterView.h"
#import "JMTabView.h"
#import "AppConfig.h"
#import "MDSlideNavigationViewController.h"
#import "HMSideMenu.h"
#import "XYAlertView.h"
#import "WSCoachMarksView.h"
#import "QueryViewController.h"
#import "QuestionViewController.h"
#import "ProductServiceViewController.h"
#import "VideoViewController.h"
#import "SMPageControl.h"

/**
 最外层的容器
 */
@interface HomeTabController : UITabBarController<JMTabViewDelegate,UIScrollViewDelegate>{

    /**
     *  低部导航
     */
    JMTabView * tabView;
    
    /**
     *  查询
     */
    QueryViewController * queryviewController;
    
    /**
     *  视频
     */
    VideoViewController * videoViewController;
    /**
     *  问答
     */
    QuestionViewController * questionViewController;
    /**
     *  产品服务
     */
    ProductServiceViewController * productserviceViewController;

}

@property (nonatomic, strong) DMFilterView *filterView;


/**
 *  低部导航
 */
@property(nonatomic,strong)JMTabView * tabView;
/**
 *  查询
 */
@property(nonatomic,strong)QueryViewController * queryviewController;
/**
 *  视频
 */
@property(nonatomic,strong)VideoViewController * videoViewController;
/**
 *  问答
 */
@property(nonatomic,strong)QuestionViewController * questionViewController;
/**
 *  产品服务
 */
@property(nonatomic,strong)ProductServiceViewController * productserviceViewController;
@end
