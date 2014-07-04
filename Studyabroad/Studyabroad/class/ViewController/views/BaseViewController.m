//
//  BaseViewController.m
//  TestAVOSPushDemo
//
//  Created by June on 14-4-4.
//  Copyright (c) 2014年 junewong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fixViewHeight];
    [self createBackButton];
}

#pragma mark - UI

- (void)fixViewHeight
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (window == nil) {
        return;
    }
    
    CGRect frame = window.frame;
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    frame.size.height -= statusBarHeight;
    frame.origin.y += statusBarHeight;
    
    UINavigationController *navContrlloer = (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if (navContrlloer != nil && [navContrlloer navigationBar] != nil && [navContrlloer navigationBar].hidden == NO) {
        CGFloat navigationBarHeight = navContrlloer.navigationBar.frame.size.height;
        frame.size.height -= navigationBarHeight;
        frame.origin.y += navigationBarHeight;
    }
    
    self.view.frame = frame;
}

- (void)createBackButton
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imgBtn = [UIImage imageNamed:@"返回.png"];
    CGRect rect;
    rect = leftButton.frame;
    rect.size  = imgBtn.size;
    leftButton.frame = rect;
    
    [leftButton setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [leftButton setShowsTouchWhenHighlighted:YES];
    [leftButton addTarget:self action:@selector(clickGoBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *temporaryLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    temporaryLeftBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem = temporaryLeftBarButtonItem;
}

/**
    增加滑动返回上一页面的手势
 */
- (void)addSwipeGestureForGoingBack
{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGesture:)];
    swipeGesture.delegate = self;
    [swipeGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
    swipeGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:swipeGesture];
}

#pragma mark - optional UI

- (void)createBackgroundImage
{
//    UIImage *image = [UIImage imageNamed:@"i4-背景图.png"];
//    if (IPhone5) {
//        image = [UIImage imageNamed:@"i5-背景图.png"];
//    }
//    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:image];
//    
//    [self.view addSubview:backgroundImage];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - gesture delegate

- (void) swipGesture:(id)sender
{
    [self goBack];
}

- (void)clickGoBackButton:(id)sender
{
    [self goBack];
}

- (void)goBack
{
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
