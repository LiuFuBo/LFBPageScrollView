//
//  LFBPagingView.h
//  分页滚动
//
//  Created by postop_iosdev on 17/5/31.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LFBPageingViewDelegate <NSObject>

@required
//设置tableView的section
- (NSInteger)lfb_numberOfSectionsInTableView:(UITableView *)tableView;
//设置tableview的行数
- (NSInteger)lfb_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//设置行高
- (CGFloat)lfb_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//设置cell
- (UITableViewCell *)lfb_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface LFBPagingView : UIView

//设置按钮的标题
@property (nonatomic, strong) NSMutableArray *titleArray;
//设置代理方法
@property (nonatomic,weak) id <LFBPageingViewDelegate> lfb_delegate;
//获取tableView
@property (nonatomic,strong) NSMutableArray *tableArray;



@end
