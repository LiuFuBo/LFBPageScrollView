//
//  LFBPagingView.m
//  分页滚动
//
//  Created by postop_iosdev on 17/5/31.
//  Copyright © 2017年 postop_iosdev. All rights reserved.
//

#import "LFBPagingView.h"
#import "Masonry.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ArcRandom arc4random()%255


@interface LFBPagingView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *titleView;


@end
@implementation LFBPagingView{
    UIView *_selectView;
    CGFloat _contentOffsetX;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

- (void)initSubviews{

    [self addSubview:self.titleView];
    [self addSubview:self.scrollView];
    
}

- (void)initLayout{

   [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.left.right.equalTo(self);
       make.height.equalTo(@44);
   }];
    
  [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.mas_top).with.offset(44);
      make.left.right.bottom.equalTo(self);
  }];
}

#pragma mark - p setter
- (void)setTitleArray:(NSMutableArray *)titleArray{
    _titleArray = titleArray;
    if (_titleArray.count == 0) return;
    _scrollView.contentSize = CGSizeMake(ScreenWidth * _titleArray.count, self.bounds.size.height-44);
    //设置按钮的宽度和高度
    CGFloat buttonWidth = ScreenWidth/_titleArray.count;
    CGFloat buttonHeight = 42;
    for (int index = 0; index <_titleArray.count; ++index) {
        //遍历设置标题按钮的位置标题等信息
        UIButton *selectButton = [[UIButton alloc]init];
        selectButton.bounds = CGRectMake(0, 0,buttonWidth, buttonHeight);
        selectButton.center = CGPointMake((index + 0.5)*buttonWidth, 21);
        selectButton.tag = index + 100;
        [selectButton setTitle:_titleArray[index] forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [selectButton addTarget:self action:@selector(respondsToSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleView addSubview:selectButton];
      
        //遍历添加tableView
        CGFloat offsetX = index * ScreenWidth;
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(offsetX, 0, ScreenWidth, self.bounds.size.height-44) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource= self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.bounces = NO;
        tableView.tag = index + 200;
        [_scrollView addSubview:tableView];
        [_tableArray addObject:tableView];
    }
    //设置选中下划线的位置
    _selectView = [UIView new];
    _selectView.backgroundColor = [UIColor redColor];
    _selectView.bounds = CGRectMake(0, 0, buttonWidth, 2);
    _selectView.center = CGPointMake(buttonWidth/2, 43);
    _selectView.layer.cornerRadius = 1;
    _selectView.layer.masksToBounds = YES;
    [_titleView addSubview:_selectView];
}

#pragma mark - p button click methods
- (void)respondsToSelectButton:(UIButton *)sender{

    //返回当前选中的标题下标
    if (self.lfb_delegate && [self.lfb_delegate respondsToSelector:@selector(lfb_selectTableViewIndex:)]) {
        [self.lfb_delegate lfb_selectTableViewIndex:sender.tag - 100];
    }
    CGFloat buttonWidth = ScreenWidth/_titleArray.count;
    //再次遍历判断是哪个按钮被选中
    for (int index = 0; index<_titleArray.count; ++index) {
        //设置选中的按钮标题颜色以及下划线位置
        if (sender.tag == index + 100) {
            [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                 _selectView.center = CGPointMake((index + 0.5) * buttonWidth, 43);
                _scrollView.contentOffset = CGPointMake(index *ScreenWidth, 0);
            }];
        }else{
            //设置没有被选中的按钮标题颜色
            UIButton *button = [self viewWithTag:index + 100];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [self.lfb_delegate lfb_numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.lfb_delegate lfb_tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [self.lfb_delegate lfb_tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [self.lfb_delegate lfb_tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    return [self.lfb_delegate lfb_tableView:tableView didSelectRowAtIndexPath:indexPath];
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    _contentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    int index = (scrollView.contentOffset.x/(ScreenWidth/2))/2;
    CGFloat buttonWidth = ScreenWidth/_titleArray.count;
    if (_contentOffsetX < scrollView.contentOffset.x && (((int)scrollView.contentOffset.x)/((int)ScreenWidth/2))>= 2*index - 1 && (((int)scrollView.contentOffset.x)/((int)ScreenWidth/2))<= 2*index) {

        if ((int)scrollView.contentOffset.x % (int)ScreenWidth == 0){
            index  = index - 1;
        }
        for (int i = 0; i< _titleArray.count; ++i) {
            if (index + 1 == i) {
                UIButton *button = [self viewWithTag:index + 101];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.5 animations:^{
                    _selectView.center = CGPointMake((index + 0.5 + 1) * buttonWidth, 43);
                }];
            }else{
                //设置没有被选中的按钮标题颜色
                UIButton *button = [self viewWithTag:i + 100];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }else if (_contentOffsetX > scrollView.contentOffset.x && (((int)scrollView.contentOffset.x)/((int)ScreenWidth/2))>= 2*index && (((int)scrollView.contentOffset.x)/((int)ScreenWidth/2))<= 2*index + 1){
        for (int i = 0; i< _titleArray.count; ++i) {
            if (index == i) {
                UIButton *button = [self viewWithTag:index + 100];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.5 animations:^{
                    _selectView.center = CGPointMake((index + 0.5) * buttonWidth, 43);
                }];
            }else{
                //设置没有被选中的按钮标题颜色
                UIButton *button = [self viewWithTag:i + 100];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
           int index = (scrollView.contentOffset.x/(ScreenWidth/2))/2;
           CGFloat buttonWidth = ScreenWidth/_titleArray.count;
        if (_contentOffsetX < scrollView.contentOffset.x && (((int)scrollView.contentOffset.x)/((int)ScreenWidth/2))>= 2*(index+1)-1 && (((int)scrollView.contentOffset.x)/((int)ScreenWidth/2))<= 2*(index + 1)) {
            
            for (int i = 0; i< _titleArray.count; ++i) {
                if (index + 1 == i) {
                    if (self.lfb_delegate && [self.lfb_delegate respondsToSelector:@selector(lfb_selectTableViewIndex:)]) {
                        [self.lfb_delegate lfb_selectTableViewIndex:index+1];
                    }
                    UIButton *button = [self viewWithTag:index + 101];
                    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [UIView animateWithDuration:0.5 animations:^{
                        _selectView.center = CGPointMake((index + 0.5 + 1) * buttonWidth, 43);
                    }];
                }else{
                    //设置没有被选中的按钮标题颜色
                    UIButton *button = [self viewWithTag:i + 100];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
        }else if (_contentOffsetX > scrollView.contentOffset.x && (((int)scrollView.contentOffset.x)/((int)ScreenWidth/2))>= 2*index && (((int)scrollView.contentOffset.x)/((int)ScreenWidth/2))<= 2*index + 1){
         
            for (int i = 0; i< _titleArray.count; ++i) {
                if (index == i) {
                    if (self.lfb_delegate && [self.lfb_delegate respondsToSelector:@selector(lfb_selectTableViewIndex:)]) {
                        [self.lfb_delegate lfb_selectTableViewIndex:index];
                    }
                    UIButton *button = [self viewWithTag:index + 100];
                    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [UIView animateWithDuration:0.5 animations:^{
                        _selectView.center = CGPointMake((index + 0.5) * buttonWidth, 43);
                    }];
                }else{
                    //设置没有被选中的按钮标题颜色
                    UIButton *button = [self viewWithTag:i + 100];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
        }
}

#pragma mark - p getter
- (UIScrollView *)scrollView{

    return _scrollView?:({
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.contentOffset = CGPointZero;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView;
    });
}

- (UIView *)titleView{

    return _titleView?:({
        _titleView = [[UIView alloc]init];
        _titleView;
    });
}


- (NSMutableArray *)tableArray{

    return _tableArray?:({
        _tableArray = [NSMutableArray array];
        _tableArray;
    });
}












@end
