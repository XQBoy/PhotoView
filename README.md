# PhotoView


本文的category是根据VIPhotoView来做参考，在此基础上添加个加载网络图片。

感谢vitoziv ！

VIPhotoView的github地址:https://github.com/vitoziv/VIPhotoView

此category主要功能是与图片进行交互，双击放大图片，捏合等操作。

具体实现如下:

    NSString *urlString = @"http://ww4.sinaimg.cn/large/7a8aed7bgw1ev1yplngebj20hs0qogq0.jpg";
    
    /** 加载网络图片 */
    XQPhotoView *photoView = [XQPhotoView photoViewWithFrame:self.view.bounds atImageUrlString:urlString];
    
    /** 加载本地图片 */
    XQPhotoView *photoView = [XQPhotoView photoViewWithFrame:self.view.bounds atImageName:@"7a8aed7bgw1euqcfwjbkdj20hs0qo40w.jpg"];
    
    [self.view addSubview:photoView];
    

![Demo demo](https://github.com/XQBoy/PhotoView/blob/master/Demo/Demo/PhotoView.gif)
