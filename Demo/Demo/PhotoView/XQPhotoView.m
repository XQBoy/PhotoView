//
//  XQPotoView.m
//  测试
//
//  Created by 格式化油条 on 15/8/15.
//  Copyright (c) 2015年 XQBoy. All rights reserved.
//

#import "XQPhotoView.h"

/** UIImage分类 */
@interface UIImage (extension)

- (CGSize)sizeThatFits:(CGSize)size;
/**
 *  将图片保存到沙盒中
 *
 *  @param image         需要保存的图片
 *  @param fileName      保存的图片文件名
 *  @param extension     图片的扩展名
 *  @param directoryPath 图片保存路径
 */
- (void)saveImage:(UIImage *)image atFileName:(NSString *)fileName atImageType:(NSString *)extension atDirectory:(NSString *)directoryPath;

/**
 *  从沙盒中加载图片
 *
 *  @param fileName      图片文件名
 *  @param extension     图片扩展名
 *  @param directoryPath 图片读取路径
 *
 *  @return 返回读取到的图片
 */
+ (UIImage *)loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
@end

@implementation UIImage (extension)

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize imageSize = CGSizeMake(self.size.width / self.scale, self.size.height / self.scale);
    
    CGFloat widthRatio = imageSize.width / size.width;
    CGFloat heightRatio = imageSize.height / size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    
    return imageSize;
}

#pragma mark - 将图片保存到沙盒中
- (void)saveImage:(UIImage *)image atFileName:(NSString *)imageName atImageType:(NSString *)extension atDirectory:(NSString *)directoryPath {
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]]
                                             options:NSAtomicWrite
                                               error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]]
                                                   options:NSAtomicWrite
                                                     error:nil];
        
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

#pragma mark - 从沙盒中加载图片
+ (UIImage *)loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    
    UIImage * image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return image;
}
@end

/** UIImageView分类 */
@interface UIImageView (extension)

- (CGSize)contentSize;

@end

@implementation UIImageView (extension)

- (CGSize)contentSize
{
    return [self.image sizeThatFits:self.bounds.size];
}

@end

@interface XQPhotoView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic) CGSize minSize;
@end

@implementation XQPhotoView

#pragma mark - 加载网络图片

+ (instancetype)photoViewWithFrame:(CGRect)frame atImageUrlString:(NSString *)urlString {
    return [[self alloc] initWithFrame:frame atImageUrlString:urlString];
}

- (instancetype)initWithFrame:(CGRect) frame atImageUrlString:(NSString *)urlString {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.delegate = self;
        
        [self setupImageOfURLString:urlString];
        
        [self setup];
        
    }
    return self;
}

#pragma mark - 根据传入的urlString 设置UIImageView的image
- (void)setupImageOfURLString:(NSString *)urlString {
    
    /** 取得沙盒路径 */
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    /** 取得图片名 */
    NSString *imageName = [[urlString lastPathComponent] stringByDeletingPathExtension];
    
    /** 取得图片扩展名 */
    NSString *imageExtension = [urlString pathExtension];
    
    /** 先从沙盒中取出图片 */
    UIImage *image = [UIImage loadImage:imageName ofType:imageExtension inDirectory:cachesDirectory];
    
    /** 当图片不存在 */
    if (!image) {
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        image = [UIImage imageWithData:data];
        
        /** 下载图片后存储到沙盒中 */
        [image saveImage:image atFileName:imageName atImageType:imageExtension atDirectory:cachesDirectory];
    }
    
    self.imageView.image = image;
    
}

#pragma mark - 加载本地图片

+ (instancetype)photoViewWithFrame:(CGRect)frame atImageName:(NSString *)imageName {
    return [[self alloc] initWithFrame:frame atImageName:imageName];
}

- (instancetype)initWithFrame:(CGRect)frame atImageName:(NSString *)imageName {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.delegate = self;
        
        self.imageView.image = [UIImage imageNamed:imageName];
        
        [self setup];
        
    }
    return self;
}

#pragma mark - 懒加载

- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_containerView];
    }
    return _containerView;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.frame = self.containerView.bounds;
        [self.containerView addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - setup

- (void)setup {
    
    [self setupSubViewsAttribute];
    [self setMaxMinZoomScale];
    [self centerContent];
    [self setupGestureRecognizer];
}

/** 设置子控件的属性 */
- (void)setupSubViewsAttribute {
    
    // Fit container view's size to image size
    CGSize imageSize = self.imageView.contentSize;
    self.containerView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.imageView.center = CGPointMake(imageSize.width / 2, imageSize.height / 2);
    
    self.contentSize = imageSize;
    self.minSize = imageSize;
    
}

- (void)setMaxMinZoomScale {
    CGSize imageSize = self.imageView.image.size;
    CGSize imagePresentationSize = self.imageView.contentSize;
    CGFloat maxScale = MAX(imageSize.height / imagePresentationSize.height, imageSize.width / imagePresentationSize.width);
    self.maximumZoomScale = MAX(1, maxScale); // Should not less than 1
    self.minimumZoomScale = 1.0;
}

- (void)centerContent {
    CGRect frame = self.containerView.frame;
    
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width - self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height - self.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

/** 添加手势 */
- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [_containerView addGestureRecognizer:tapGestureRecognizer];
}

/** 手势监听方法 */
- (void)tapHandler:(UITapGestureRecognizer *)recognizer {
    if (self.zoomScale > self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else if (self.zoomScale < self.maximumZoomScale) {
        CGPoint location = [recognizer locationInView:recognizer.view];
        CGRect zoomToRect = CGRectMake(0, 0, 50, 50);
        zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect)/2, location.y - CGRectGetHeight(zoomToRect)/2);
        [self zoomToRect:zoomToRect animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerContent];
}


@end
