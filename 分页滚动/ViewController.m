//
//  ViewController.m
//  分页滚动
//
//  Created by postop_iosdev on 17/5/31.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import "ViewController.h"
#import "LFBPagingView.h"

static NSString *const TableViewCellIdentifier = @"TableViewCellIdentifier";
@interface ViewController ()<LFBPageingViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAppearances];
    [self initWithData];
}

- (void)initWithData{

    [_dataSources addObjectsFromArray:@[@"张三",@"李四",@"王麻子",@"张瘸子",@"小包子"]];

}

- (void)initAppearances{
    
    self.title = @"分页滚动";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    LFBPagingView *pageView = [[LFBPagingView alloc]init];
    pageView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
    pageView.titleArray = [NSMutableArray arrayWithArray:@[@"按次",@"按日"]];
    pageView.lfb_delegate = self;
    [self.view addSubview:pageView];
    
}

- (NSInteger)lfb_numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)lfb_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (tableView.tag == 200) {
        return 5;
    }else{
      return 8;
    }
}

- (CGFloat)lfb_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

-(UITableViewCell *)lfb_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableViewCellIdentifier];
    }
    cell.textLabel.text = @"哈哈";
    return cell;

}

- (NSMutableArray *)dataSources{

    return _dataSources?:({
        _dataSources = [NSMutableArray array];
        _dataSources;
    });
}








@end
