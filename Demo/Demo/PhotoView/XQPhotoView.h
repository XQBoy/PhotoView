//
//  XQPotoView.h
//  测试
//
//  Created by 格式化油条 on 15/8/15.
//  Copyright (c) 2015年 XQBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQPhotoView : UIScrollView

/** 显示的图片，提供给外界调用，用于保存图片 */
@property (strong, nonatomic) UIImageView *imageView;

/** 加载网络图片 */
+ (instancetype)photoViewWithFrame:(CGRect)frame atImageUrlString:(NSString *)urlString;
- (instancetype)initWithFrame:(CGRect) frame atImageUrlString:(NSString *)urlString;

/** 加载本地图片 */
+ (instancetype)photoViewWithFrame:(CGRect)frame atImageName:(NSString *)imageName;
- (instancetype)initWithFrame:(CGRect)frame atImageName:(NSString *)imageName;
@end
