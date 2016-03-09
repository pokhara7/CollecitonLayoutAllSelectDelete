//
//  HomeShelfCollectionViewCell.m
//  MyItem
//
//  Created by pokhara on 15/11/17.
//  Copyright © 2015年 mt. All rights reserved.
//

#import "HomeShelfCollectionViewCell.h"

@implementation HomeShelfCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
//编辑状态下
- (void)setChecked:(BOOL)checked{
    if (checked)
    {
       _m_checkImageView.image = [UIImage imageNamed:@"选中"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        _m_checkImageView.image = [UIImage imageNamed:@"未选中"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    m_checked = checked;
}


@end
