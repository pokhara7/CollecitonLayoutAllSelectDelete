//
//  HomeShelfCollectionViewCell.h
//  MyItem
//
//  Created by pokhara on 15/11/17.
//  Copyright © 2015年 mt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeShelfCollectionViewCell : UICollectionViewCell
{
    BOOL			m_checked;
}
@property(nonatomic,strong)IBOutlet UIImageView *ShelfimgView;
@property(nonatomic,strong)IBOutlet UILabel *Shelflabel;
@property(nonatomic,strong)IBOutlet UIImageView *m_checkImageView;

- (void)setChecked:(BOOL)checked;

@end
