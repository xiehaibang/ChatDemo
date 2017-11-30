//
//  XHBUserTableViewCell.m
//  ChatDemo
//
//  Created by 云趣科技 on 2017/11/23.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBUserTableViewCell.h"

@interface XHBUserTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView * headImage; //头像
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;     //名字
@property (weak, nonatomic) IBOutlet UILabel * statusLabel;   //状态


@end

@implementation XHBUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCell {
    
    self.headImage.image = [UIImage imageNamed:@"头像"];
    
    self.nameLabel.text = self.myFriend.jid.user;
    
    if ([self.myFriend isOnline]) {
        
        self.statusLabel.text = @"[在线]";
        
        self.nameLabel.textColor = [UIColor blackColor];
        self.statusLabel.textColor = [UIColor blackColor];
    }
    else {
        
        self.statusLabel.text = @"[离线]";
        
        self.nameLabel.textColor = [UIColor grayColor];
        self.statusLabel.textColor = [UIColor grayColor];
    }
    
//    self.headImage.image = [UIImage imageNamed:@"Address_IconHl"];
//    self.nameLabel.text = @"谢海邦";
//    self.statusLabel.text = @"[在线]";
}

#pragma mark - setter
- (void)setMyFriend:(XMPPUserMemoryStorageObject *)myFriend {
    
    _myFriend = myFriend;
    
    [self setupCell];
}

@end
