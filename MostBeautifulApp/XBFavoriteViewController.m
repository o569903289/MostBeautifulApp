//
//  XBFavoriteViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBFavoriteViewController.h"
#import "DBUtil.h"
#import "AppDelegate.h"
#import "AppFavorite.h"
@interface XBFavoriteViewController ()
@property (strong, nonatomic) UILabel  *noDataLabel;
@end

@implementation XBFavoriteViewController

- (void)viewDidLoad {
    
    self.homeRightType = XBHomeRightTypeFavorite;
    
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.datas.count > 0) {
        [super resetBackgroundColorIsScrollToItem:NO];
    }
    
    [self reloadData];
    
}

- (void)reloadData
{
    
    [self showLoadinng];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d AND %K == %d", @"isFavorite", YES, @"type",XBAppTypeFavorite];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchLimit = 100;
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"updateAt" ascending:NO];
    
    [[DBUtil shareDBUtil] queryListWithEntityName:[AppFavorite managedObjectEntityName] fetchRequest:fetchRequest sortDescriptors:@[sortDesc] complete:^(NSArray *datas) {
        
        if (datas.count > 0) {
            
            NSError *error;
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:datas.count];
            for (id model in datas) {
                AppFavorite *local = [MTLManagedObjectAdapter modelOfClass:[AppFavorite class] fromManagedObject:model error:&error];
                [array addObject:local];
            }
            
            if (self.datas.count != datas.count) {
                
                self.datas = array;
                [super.cardView slideCardReloadData];
                [super resetBackgroundColorIsScrollToItem:YES];
                
            }
            
            self.noDataLabel.hidden = YES;
            
        } else {
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            self.noDataLabel.backgroundColor = tempAppDelegate.leftSlideVC.leftVC.view.backgroundColor;
            self.noDataLabel.hidden = NO;
        }
        
        [self hideLoading];
    }];
}

//覆盖父类的关闭 开启左菜单栏
- (void)menuAction
{
    [super menuAction];
}

#pragma mark -- lazy loading
- (UILabel *)noDataLabel
{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        _noDataLabel.textColor = [UIColor whiteColor];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.text = @"暂无收藏的文章哦^_^";
        _noDataLabel.hidden = YES;
        _noDataLabel.font = [UIFont systemFontOfSize:14.f];
        [self.view addSubview:_noDataLabel];
    }
    return _noDataLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
