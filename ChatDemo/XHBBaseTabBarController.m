//
//  XHBBaseTabBarController.m
//  ChatDemo
//
//  Created by 云趣科技 on 2017/11/22.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBBaseTabBarController.h"
#import "XHBBaseNavigationController.h"
#import "XHBContactsViewController.h"
#import "XHBGroupViewController.h"
#import "XHBSettingViewController.h"

@interface XHBBaseTabBarController ()

@end

@implementation XHBBaseTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //当子视图 push 的时候隐藏 底部tabBar
    self.hidesBottomBarWhenPushed = YES;
    
    //添加通讯录
    [self addChildViewControllerWithClassName:[XHBContactsViewController description]
                                    imageName:@"tabbar_mates"
                                        title:@"通讯录"];
    
    //添加群组
    [self addChildViewControllerWithClassName:[XHBGroupViewController description]
                                    imageName:@"tabbar_disc"
                                        title:@"群组"];
    
    //添加设置
    [self addChildViewControllerWithClassName:[XHBSettingViewController description]
                                    imageName:@"tabbar_more"
                                        title:@"设置"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加子视图
- (void)addChildViewControllerWithClassName:(NSString *)className
                                  imageName:(NSString *)imageName
                                      title:(NSString *)title {
    
    UIViewController * vc = [[NSClassFromString(className) alloc] init];
    XHBBaseNavigationController * nav = [[XHBBaseNavigationController alloc] initWithRootViewController:vc];
    
    vc.navigationItem.title = title;
    nav.tabBarItem.title = title;
    
    UIImage * normalImage = [UIImage imageNamed:imageName];
    UIImage * selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", imageName]];
    
    nav.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self addChildViewController:nav];
}

@end
