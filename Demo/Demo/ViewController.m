//
//  ViewController.m
//  Demo
//
//  Created by 格式化油条 on 15/8/17.
//  Copyright (c) 2015年 XQBoy. All rights reserved.
//

#import "ViewController.h"
#import "XQPhotoView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *urlString = @"http://ww4.sinaimg.cn/large/7a8aed7bgw1ev1yplngebj20hs0qogq0.jpg";
    
    /** 加载网络图片 */
    XQPhotoView *photoView = [XQPhotoView photoViewWithFrame:self.view.bounds atImageUrlString:urlString];
    
    /** 加载本地图片 */
//    XQPhotoView *photoView = [XQPhotoView photoViewWithFrame:self.view.bounds atImageName:@"7a8aed7bgw1euqcfwjbkdj20hs0qo40w.jpg"];
    
    [self.view addSubview:photoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
