//
//  ViewController.m
//  ChatDemo
//
//  Created by 云趣科技 on 2017/11/16.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "ViewController.h"
#import "XHBBaseTabBarController.h"
#import "XHBRegisterViewController.h"
#import "XHBXMPPTool.h"


@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton * loginButton;

@property (weak, nonatomic) IBOutlet UITextField * accountTextField;
@property (weak, nonatomic) IBOutlet UITextField * passwordTextField;

@end

IB_DESIGNABLE

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.accountTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    [self.passwordTextField setSecureTextEntry:YES];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.accountTextField.text = @"xiehaibang";
    self.passwordTextField.text = @"123456";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccese) name:kLOGIN_SUCCESE object:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 通知响应
//登录成功
- (void)loginSuccese {
    
    XHBBaseTabBarController * tabBarVC = [[XHBBaseTabBarController alloc] init];
    
    [self.navigationController pushViewController:tabBarVC animated:YES];
    
}


#pragma mark - 按钮事件
//登录
- (IBAction)loginButtonClick:(id)sender {
    
    NSString * username = self.accountTextField.text;
    NSString * password = self.passwordTextField.text;
    
    NSString * message = nil;
    
    if (username.length <= 0) {
        message = @"请输入用户名";
    }
    else if (password.length <= 0) {
        
        message = @"请输入密码";
    }
    
    if (message.length > 0) {
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        
        [alertView show];
    }
    else {
        
        [[XHBXMPPTool sharedInstance] loginWithJID:[XMPPJID jidWithUser:username domain:kDOMAIN resource:kRESOURCE]
                                       andPassword:password];
        
    }
}

//注册
- (IBAction)registerButtonClick:(id)sender {
    
    XHBRegisterViewController * registerVC = [[XHBRegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}

//忘记密码
- (IBAction)forgetPasswordClick:(id)sender {
    
}


#pragma mark - UITextFieldDelegate
//是否允许输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //禁止输入空格
    if (![kAllowInputChar containsString:string]) {
        
        //如果是删除键，也允许输入
        if ([string isEqualToString:@""]) {
            return YES;
        }
        
        return NO;
    }
    
    
    return YES;
}


#pragma mark - setter
- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    _cornerRadius = cornerRadius;
    
    self.loginButton.layer.cornerRadius = _cornerRadius;
    self.loginButton.layer.masksToBounds = YES;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLOGIN_SUCCESE object:nil];
}

@end
