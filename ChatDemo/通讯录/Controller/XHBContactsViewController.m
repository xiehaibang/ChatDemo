//
//  XHBContactsViewController.m
//  ChatDemo
//
//  Created by 云趣科技 on 2017/11/22.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBContactsViewController.h"
#import "XHBUserTableViewCell.h"
#import "XHBXMPPTool.h"
#import "XHBAddFriendViewController.h"

@interface XHBContactsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * friendsTableView;

@property (nonatomic, strong) NSMutableArray * contactsArray;

@end

static NSString * cellIdentify = @"XHBUserTableViewCell";

@implementation XHBContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    
    [self addTableView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendListUpdate)
                                                 name:kXMPP_ROSTER_CHANGE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendRequest:)
                                                 name:kXMPP_FRIEND_REQUEST
                                               object:nil];
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    [addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
}

- (void)addTableView {
    
    [self.view addSubview:self.friendsTableView];
    
    [self.friendsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(64);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(- self.tabBarController.tabBar.height);
    }];
    
}


#pragma mark - 按钮事件
/**
 添加好友按钮
 */
- (void)addButtonClicked {
    
    XHBAddFriendViewController * addFriendVC = [[XHBAddFriendViewController alloc] init];
    
    [self.navigationController pushViewController:addFriendVC animated:YES];
    
}


#pragma mark - 通知事件
/**
 好友列表更新
 */
- (void)friendListUpdate {
    
    //获取没有排序的好友列表
    NSArray * array = [XHBXMPPTool sharedInstance].xmppRosterMemoryStorage.unsortedUsers;
    
    self.contactsArray = [NSMutableArray arrayWithArray:array];
    
    [self.friendsTableView reloadData];
}

/**
 好友请求

 @param friendJID 请求者的JID
 */
- (void)friendRequest:(NSNotification *)friendJID {

    XMPPJID * requesterJID = (XMPPJID *)[friendJID object];
    
    XMPPRoster * xmppRoster = [XHBXMPPTool sharedInstance].xmppRoster;
    
    NSString * message = [NSString stringWithFormat:@"【%@】想加你为好友", requesterJID.bare];
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                      message:message
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * acceptAction = [UIAlertAction actionWithTitle:@"同意"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              [xmppRoster acceptPresenceSubscriptionRequestFrom:requesterJID
                                                                                                 andAddToRoster:YES];
                                                          }];
    
    UIAlertAction * rejectAction = [UIAlertAction actionWithTitle:@"拒绝"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              [xmppRoster rejectPresenceSubscriptionRequestFrom:requesterJID];
                                                          }];
    
    [alertVC addAction:acceptAction];
    [alertVC addAction:rejectAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}

#pragma mark - UITableViewDelegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
//    if (self.contactsArray.count == 0) {
//        return 0;
//    }
    
    return self.contactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XHBUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify
                                                             forIndexPath:indexPath];

    cell.myFriend = self.contactsArray[indexPath.row];
    
    return cell;
}


#pragma mark - getter
- (UITableView *)friendsTableView {
    
    if (!_friendsTableView) {
        
        _friendsTableView = [[UITableView alloc] init];
        
        _friendsTableView.delegate = self;
        _friendsTableView.dataSource = self;
        
        //去掉 tableView 自带的分割线
        _friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _friendsTableView.rowHeight = 70;
        
        [_friendsTableView setBackgroundColor:[UIColor whiteColor]];
        
        
        //注册复用的 cell
        NSString * className = NSStringFromClass([XHBUserTableViewCell class]);
        UINib * nib = [UINib nibWithNibName:className bundle:nil];
        [_friendsTableView registerNib:nib forCellReuseIdentifier:cellIdentify];

    }
    
    return _friendsTableView;
}

- (NSMutableArray *)contactsArray {
    
    if (!_contactsArray) {
        
        _contactsArray = [NSMutableArray array];
    }
    
    return _contactsArray;
}


#pragma 控制器销毁
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kXMPP_ROSTER_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kXMPP_FRIEND_REQUEST object:nil];
}

@end
