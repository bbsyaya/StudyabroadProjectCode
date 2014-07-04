//
//  HomeTabController.m
//  GameStrategys
//
//  Created by 姚东海 on 5/5/14.
//  Copyright (c) 2014年 junewong. All rights reserved.
//

#import "HomeTabController.h"
#import "Globle.h"
#import "HMSideMenu.h"
#import "Globle.h"
#import "AppConfig.h"
#import "CustomTabItem.h"
#import "CustomSelectionView.h"
#import "CustomBackgroundLayer.h"
#import "CustomNoiseBackgroundView.h"
#import "UIView+Positioning.h"
#import "Toast+UIView.h"
#import "NSDate-Utilities.h"
@interface HomeTabController (){
    ///ViewController标题
    NSArray  * tabitemTitles;
    
}


@end

@implementation HomeTabController
@synthesize tabView;
@synthesize videoViewController,productserviceViewController,queryviewController,questionViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //[self.navigationController.navigationBar setTranslucent:NO];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        //IOS5
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶部导航栏.png"] forBarMetrics:UIBarMetricsDefault];
        //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    }
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (BOOL) automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
    return YES;
}

- (BOOL) shouldAutomaticallyForwardRotationMethods {
    return YES;
}

- (BOOL) shouldAutomaticallyForwardAppearanceMethods {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

///初始化数据
-(void)initData{
    
}


- (void)viewDidLoad
{
  [super viewDidLoad];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(startloaddataend:) name:@"firstloadend" object:nil];
  [self  hideExistingTabBar];
  [self addviewControllers];
    [self initData];

  [self creatUI];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - creatUIView
///清除TabBar所有UI
- (void)hideExistingTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}



///添加viewController 到容器
-(void)addviewControllers{
    
    self.queryviewController=[[QueryViewController alloc]init];
    self.videoViewController=[[VideoViewController alloc]init];
    self.productserviceViewController=[[ProductServiceViewController alloc]init];
    self.questionViewController=[[QuestionViewController alloc]init];
    self.viewControllers=@[self.queryviewController,self.videoViewController,productserviceViewController,questionViewController];
    self.selectedIndex=0;
    self.view.backgroundColor=[UIColor redColor];
}


///自定义tabBar
-(void)creatUI{
    self.view.backgroundColor=[UIColor whiteColor];
  
     tabitemTitles=[[NSArray alloc]initWithObjects:@"查询",@"视频",@"产品服务", @"问答",nil];
      self.navigationItem.title=tabitemTitles[0];
    //添加自定义tabbar条
     tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44., [Globle shareInstance].globleWidth, 44.)];
    //[tabView setViewtoplineColor:[UIColor grayColor]];
    tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [tabView setDelegate:self];
    CGFloat tabItemWidth = tabView.frame.size.width / 4;
    CGSize tabItemPadding = CGSizeMake(tabView.frame.size.width/4/2, 0);
    
    
    for (int i=0; i<tabitemTitles.count; i++) {
        
        NSString * imagenamenormal=[NSString stringWithFormat:@"按钮-未按_0%d.png",(i+2)];
       NSString * imagenamehightlight=[NSString stringWithFormat:@"按钮-按下_0%d.png",(i+2)];
        CustomTabItem * tabItem = [CustomTabItem tabItemWithTitle:tabitemTitles[i] icon:[UIImage imageNamed:imagenamenormal] alternateIcon:[UIImage imageNamed:imagenamehightlight]];
        tabItem.customWidth = tabItemWidth;
        tabItem.padding = tabItemPadding;
        [tabView addTabItem:tabItem];
       
    }
    [tabView setSelectionView:[CustomSelectionView createSelectionView]];
    [tabView setItemSpacing:1.];
    [tabView setBackgroundLayer:[[CustomBackgroundLayer alloc] init]];
    [tabView setSelectedIndex:0];
    [self.view addSubview:tabView];
    
}

#pragma mark - SMPageControl action
- (void)spacePageControl:(SMPageControl *)sender
{
    
	NSLog(@"Current Page (SMPageControl): %i", sender.currentPage);
}


#pragma mark - classmethods
/**
 *  开始加载
 */
-(void)startloaddataend:(NSNotification *)notification{
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"WSCoachMarksShownHot"];
    if (coachMarksShown == NO) {//NO则只显示一次,更新后也不显示
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WSCoachMarksShownHot"];
        [[NSUserDefaults standardUserDefaults] synchronize];
       
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - FilterVie delegate

- (CGFloat )filterViewSelectionAnimationSpeed:(DMFilterView *)filterView
{
    //return the default value as example, you don't have to implement this delegate
    //if you don't want to modify the selection speed
    //Or you can return 0.0 to disable the animation totally
    return kAnimationSpeed;
}

-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex;
{
    NSLog(@"Selected Tab Index: %d", itemIndex);
    self.selectedIndex=itemIndex;
    self.navigationItem.title=tabitemTitles[itemIndex];
    
    if (itemIndex==3) {

    }

    
}

/**
 *  低部选中按扭
 *
 *  @param Index 当前选中
 */
-(void)tableViewdidSelectTabAtIndex:(int)Index{
    self.selectedIndex=Index;
    JMTabItem * item=[tabView.tabContainer.tabItems objectAtIndex:Index];
    [item itemTapped];

}


@end
