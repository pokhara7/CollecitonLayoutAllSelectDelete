//
//  SelctedCollectionViewController.m
//  CollectionViewSelected
//
//  Created by pokhara on 16/3/7.
//  Copyright © 2016年 Pokhara. All rights reserved.
//

#import "SelctedCollectionViewController.h"
#import "HomeShelfCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#define STRIDENT @"CollecIdent"
#define UIScreenHeight   [UIScreen mainScreen].bounds.size.height
#define UIScreenWidth    [UIScreen mainScreen].bounds.size.width
@interface SelctedCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *CollectVShelf;
    BOOL CLickMode;//编辑状态，初始化为YES，代表正常状态，NO代表编辑状态
    NSMutableArray *contacts;
    UIView *viewForEidit;
    UIButton *btnDelete;
    CALayer *layer;
    CALayer *layer3;
    NSMutableArray *mutaArrForDelete;//记录要删除Item的数组
    NSMutableArray *arrItem;
    
    UIButton *btnDetail;//完成按钮
}
@end

@implementation SelctedCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreatColletionViewAsShelf];
}
- (void)CreatColletionViewAsShelf
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 10;
    CollectVShelf = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, UIScreenWidth, UIScreenHeight-108) collectionViewLayout:flowLayout];
    
    [CollectVShelf registerNib:[UINib nibWithNibName:@"HomeShelfCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:STRIDENT];
    //允许多选
    //    CollectVShelf.allowsMultipleSelection = YES;
    
    CollectVShelf.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:CollectVShelf];
    NSArray *arr =@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    arrItem = [[NSMutableArray alloc]initWithArray:arr];
    CollectVShelf.delegate = self;
    CollectVShelf.dataSource = self;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{

    CLickMode = YES;
   
    
    
    //存储要删除的多选数组
    mutaArrForDelete = [[NSMutableArray alloc]init];
    contacts = [NSMutableArray array];
    for (int i = 0; i <arrItem.count; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked"];
        [contacts addObject:dic];
        
    }
    
    
    
    
    [CollectVShelf reloadData];
}

//共有多少个单元格
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrItem.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    return CGSizeMake((UIScreenWidth-80)/3, 150);
    
    
}
//边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);//collection整个离self.view的上左下右
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeShelfCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:STRIDENT forIndexPath:indexPath];
//        [cell.ShelfimgView setImageWithURL:[NSURL URLWithString:@"http://tp2.sinaimg.cn/1959445101/180/5692811275/1"]] placeholderImage:[UIImage imageNamed:@""]];
    
    NSURL* imagePath1 = [NSURL URLWithString:@"http://tp2.sinaimg.cn/1959445101/180/5692811275/1"];
    [cell.ShelfimgView sd_setImageWithURL:imagePath1];
    cell.Shelflabel.text = arrItem[indexPath.row];
    cell.ShelfimgView.userInteractionEnabled = YES;
    cell.tag = indexPath.row;
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(tapGes:)];
    [cell addGestureRecognizer:tap];
    
    
    
    if (CLickMode == YES)
    {
        NSUInteger row = indexPath.row;
        NSMutableDictionary *dic = [contacts objectAtIndex:row];
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"])
        {
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
            
        }
        else
        {
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
        }
        cell.m_checkImageView.image = [UIImage imageNamed:@""];
    }
    else
    {
        NSUInteger row = indexPath.row;
        NSMutableDictionary *dic = [contacts objectAtIndex:row];
        if ([[dic objectForKey: @"checked"] isEqualToString:@"NO"])
        {
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
            
        }
        else
        {
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
        }
    }
    
    
    
    
    
    return cell;
}
-(void)tapGes:(UITapGestureRecognizer*)now
{
    

    CLickMode = NO;

    
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[CollectVShelf indexPathsForVisibleItems]];
    
    NSUInteger row = now.view.tag;

    //每次长按初始化contacts，将所有VALUE设为NO
    contacts = [NSMutableArray array];
    for (int i = 0; i <arrItem.count; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked"];
        [contacts addObject:dic];
    }
    
    NSMutableDictionary *dic = [contacts objectAtIndex:row];
    
    //加底部选择角标
    for (int i = 0; i < [anArrayOfIndexPath count]; i++)
    {
        NSIndexPath *indexPath= [anArrayOfIndexPath objectAtIndex:i];
        HomeShelfCollectionViewCell *cell = (HomeShelfCollectionViewCell*)[CollectVShelf cellForItemAtIndexPath:indexPath];
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"])
        {
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
        }
        else
        {
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:YES];
        }
        [CollectVShelf deselectItemAtIndexPath:indexPath animated:YES];
    }
    
    
    
    

    
    
    
    
    
    viewForEidit = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenHeight-100, UIScreenWidth, 60)];
    [self.view bringSubviewToFront:viewForEidit];
    viewForEidit.tag = 1001;
    viewForEidit.userInteractionEnabled = YES;
    viewForEidit.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewForEidit];
    
    
    
    UIView *viewLineForEditView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.5)];
    viewLineForEditView.backgroundColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
    viewLineForEditView.alpha = 0.5;
    [viewForEidit addSubview:viewLineForEditView];
    
    
    btnDelete = [[UIButton alloc]initWithFrame:CGRectMake(20,10, (UIScreenWidth-60)/3, 40)];
    [btnDelete setTitle:@"删除" forState:UIControlStateNormal];
    btnDelete.userInteractionEnabled = NO;
    [btnDelete setTitleColor:[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1] forState:UIControlStateNormal];
    [viewForEidit addSubview:btnDelete];
    btnDelete.tag = 701;
    [btnDelete addTarget:self action:@selector(clicktoEdit:) forControlEvents:
     UIControlEventTouchUpInside];
    layer = [btnDelete layer];
    layer.borderWidth = 1;
    layer.borderColor = [[UIColor grayColor] CGColor];
    layer.borderColor = [[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1]CGColor];
    btnDelete.layer.cornerRadius = 4;
    [btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //下载按钮
    
    
    
    //详情按钮
    btnDetail = [[UIButton alloc]initWithFrame:CGRectMake(2*(UIScreenWidth-60)/3+40,10, (UIScreenWidth-60)/3, 40)];
    btnDetail.tag = 703;
    [btnDetail setTitle:@"完成" forState:UIControlStateNormal];
    [btnDetail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [viewForEidit addSubview:btnDetail];
    [btnDetail addTarget:self action:@selector(clicktofinish:) forControlEvents:
     UIControlEventTouchUpInside];
    layer3 = [btnDetail layer];
    layer3.borderWidth = 1;
    layer3.borderColor = [[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1]CGColor];
    btnDetail.layer.cornerRadius = 4;


    
}

- (void)clicktoEdit:(UIButton*)sender
{
    
    NSLog(@"delete");
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
    
    //添加自定义按钮
    
    
    UIAlertAction *a3 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                         {
                             
                             // 指定元素的比较方法：compare:
                             NSArray *array2 = [mutaArrForDelete sortedArrayUsingSelector:@selector(compare:)];
                             NSLog(@"array2:%@", array2);
                            NSArray * arrayReverse = (NSMutableArray *)[[array2 reverseObjectEnumerator] allObjects];
                         
                
                             for (NSString *str in arrayReverse)
                             {
                                 NSInteger a = [str integerValue];
                                 [arrItem removeObjectAtIndex:a];
                             }
//                             NSIndexSet *set = [[NSIndexSet alloc]initWithIndexSet:mut_set];
//                             
//                             NSMutableArray *IDarrSelected = [[NSMutableArray alloc]init];
//                             for (NSString*str in mutaArrForDelete)
//                             {
//                                 
//                                 NSInteger t = [str integerValue];
////                                 [IDarrSelected addObject:arrBookID[t]];
//                             }
////                             [articleVC deleteSelected:IDarrSelected];
////                             
//
//                             
//                             [arrBookName removeObjectsAtIndexes:set];
//                             [arrIMG removeObjectsAtIndexes:set];
//                             [arrBookID removeObjectsAtIndexes:set];
//                             [downLoadBookAuthor removeObjectsAtIndexes:set];
//                             [downLoadBookNewSection removeObjectsAtIndexes:set];
//                             [downLoadBookContent removeObjectsAtIndexes:set];
                             
                             //每次删除，将所有VALUE设为NO，防止角标错乱
                             contacts = [NSMutableArray array];
                             for (int i = 0; i <arrItem.count; i++)
                             {
                                 NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                 [dic setValue:@"NO" forKey:@"checked"];
                                 [contacts addObject:dic];
                             }
                             
                             [CollectVShelf reloadData];
                             //这里初始化是为了删除一次之后用户继续再删除，删除的书的序号数组初始化，防止数组崩
                             mutaArrForDelete = [[NSMutableArray alloc]init];
     
                         }];
    [ac addAction:a3];
    
    //添加取消
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [ac addAction:a1];
}

//点击选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (CLickMode == YES)
    {
        NSLog(@"选中");
        
    }
    if (CLickMode == NO)
    {
        
        
        
        [CollectVShelf deselectItemAtIndexPath:indexPath animated:YES];
        
        HomeShelfCollectionViewCell *cell = (HomeShelfCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        NSMutableDictionary *dic = [contacts objectAtIndex:indexPath.row];
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"])
        {
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
            
            NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];

            if (mutaArrForDelete)//剔除重复的
            {
                if ([mutaArrForDelete containsObject:str])
                {
                    return;
                }
                else
                    [mutaArrForDelete addObject:str];
                NSLog(@"%@",mutaArrForDelete);
            }
        }
        else
        {
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
            NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            if (mutaArrForDelete)//剔除重复的
            {
                if ([mutaArrForDelete containsObject:str])
                {
                    [mutaArrForDelete removeObject:str];
                }
                else
                    return;
            }
            
        }
    
//        //不选择的时候
        if (mutaArrForDelete.count==0)
        {
            layer.borderColor = [[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1]CGColor];
            btnDelete.userInteractionEnabled = NO;
            [btnDelete setTitleColor:[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1] forState:UIControlStateNormal];
        }
        else
        {
            btnDelete.userInteractionEnabled = YES;
            [btnDelete setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
   
    }
}
-(void)clicktofinish:(id)sender
{
    CLickMode = YES;
     mutaArrForDelete = [[NSMutableArray alloc]init];
    [CollectVShelf reloadData];//去除编辑图片的角标
    
    
    for (UIView *view in [self.view subviews])
    {
        if([view isKindOfClass:[UIView class]]  &&1001 == view.tag)//如果有多个同类型的View可以通过tag来区分
        {
            view.hidden = YES;
            [view removeFromSuperview];//删除此控件
        }
    }
}

@end
