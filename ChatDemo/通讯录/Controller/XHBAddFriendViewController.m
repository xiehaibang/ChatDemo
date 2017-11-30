//
//  XHBAddFriendViewController.m
//  ChatDemo
//
//  Created by 云趣科技 on 2017/11/30.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBAddFriendViewController.h"
#import "XHBXMPPTool.h"

@interface XHBAddFriendViewController ()

@property (weak, nonatomic) IBOutlet UITextField * usernameTF; //用户名输入框

@end

@implementation XHBAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏标题
    self.navigationItem.title = @"添加好友";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 按钮事件
- (IBAction)addFriendButtonClicked:(id)sender {
    
    WeakSelf(weakSelf);
    
    NSString * message = nil;
    
    UIAlertAction * action;
    
    if ([self.usernameTF.text isEqualToString:@""]) {
        
        message = @"请输入用户名";
        
        action = [UIAlertAction actionWithTitle:@"知道了"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    }
    else {
        
        message = @"已发送好友请求";
        
        NSString * username = self.usernameTF.text;
        
        [[XHBXMPPTool sharedInstance] addFriendWithJID:[XMPPJID jidWithUser:username domain:kDOMAIN resource:kRESOURCE]];
        
        action = [UIAlertAction actionWithTitle:@"好的"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                            [weakSelf.navigationController popViewControllerAnimated:YES];
                                                        }];
    }
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                      message:message
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:action];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}



@end
