//
//  BaseViewController.m
//  HelloSunny
//  controller 基类
//  Created by garin on 14-4-16.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

-(void) fitIos7
{
    self.navigationController.navigationBarHidden = YES;
    if (IOS_VERSION >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;  //UIScrowView 上下不留白，Ios7以上默认留白
        CGFloat topBarOffset = self.topLayoutGuide.length;
        self.view.frame = CGRectMake(self.view.bounds.origin.x, topBarOffset, self.view.bounds.size.width, self.view.bounds.size.height-topBarOffset);
        
        UIView *gView = [[UIView alloc] initWithFrame:CGRectMake(0, -topBarOffset, self.view.bounds.size.width, topBarOffset)];
        gView.backgroundColor = RGBA(40, 80, 113, 1);
        [self.view addSubview:gView];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor=[UIColor whiteColor];
    [self fitIos7];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
