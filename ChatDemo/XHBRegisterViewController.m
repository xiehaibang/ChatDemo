//
//  XHBRegisterViewController.m
//  ChatDemo
//
//  Created by 云趣科技 on 2017/11/20.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBRegisterViewController.h"
#import "XHBXMPPTool.h"

@interface XHBRegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField * accountTextField;
@property (weak, nonatomic) IBOutlet UITextField * passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField * confirmTextField;

@end

@implementation XHBRegisterViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accountTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmTextField.delegate = self;
    
    //设置密码输入框
    [self.passwordTextField setSecureTextEntry:YES];
    [self.confirmTextField setSecureTextEntry:YES];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelButton.bounds = CGRectMake(0, 0, 50, 50);
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];

    //注册结果
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerResultWithNotification:)
                                                 name:kREGISTER_RESULT
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 通知事件
- (void)registerResultWithNotification:(NSNotification *)notification {
    
    NSNumber * resultNumber = (NSNumber *) notification.object;
    
    BOOL result = [resultNumber boolValue];
    
    if (result) {
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                          message:@"注册成功"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"我知道了"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                                 
                                                             }];
        
        [alertVC addAction:alertAction];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"注册失败"
                                                        delegate:nil
                                               cancelButtonTitle:@"我知道了"
                                               otherButtonTitles:nil];
        
        [alert show];
    }
}

#pragma mark - 按钮事件
/**
 取消
 */
- (void)cancelButtonClick {
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 注册

 @param sender 按钮对象
 */
- (IBAction)registerButtonClick:(id)sender {
    
    NSString * username = self.accountTextField.text;
    NSString * password = self.passwordTextField.text;
    NSString * confirmPassword = self.confirmTextField.text;
    
    NSString * message = nil;
    
    if (username.length <= 0) {
        
        message = @"请输入用户名";
    }
    else if (password.length <= 0) {
        
        message = @"请输入密码";
    }
    else if (confirmPassword.length <= 0) {
        
        message = @"请输入确认密码";
    }
    
    if (message.length > 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    else if (![password isEqualToString:confirmPassword]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"两次输入的密码不一致"
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    else {
        
        [[XHBXMPPTool sharedInstance] registerWithJID:[XMPPJID jidWithUser:username domain:kDOMAIN resource:kRESOURCE]
                                          andPassword:password];
    }
}


#pragma mark - UITextFieldDelegate
//是否允许输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //判断是否是空格
    if (![kAllowInputChar containsString:string]) {
        
        //如果输入的是删除键，允许输入
        if ([string isEqualToString:@""]) {
            
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kREGISTER_RESULT object:nil];
}

@end
