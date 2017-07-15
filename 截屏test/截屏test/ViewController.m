//
//  ViewController.m
//  截屏test
//
//  Created by 腾庆阳 on 2017/7/15.
//  Copyright © 2017年 腾庆阳. All rights reserved.


#import "ViewController.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@interface ViewController ()
@property (nonatomic ,strong) UIImageView * imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*    记得获取相册权限哦  要不会崩溃的    */
    
    ///// 在 info.plist 里面添加  NSPhotoLibraryUsageDescription 字段 后面的value 自己随便写 例子中写的是 “我就看看相册”
    
    
    // 1、 buttonAction (点击按钮) 方法里面有3种  1、截屏全屏 2、截屏图片 3、截屏指定区域
    // 2、 longPressAction (长按) 方法里有1种  1、截屏图片的
    
    
    UIImageView *imge = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, ScreenW - 100, ScreenH - 200)];
    imge.userInteractionEnabled = YES;
    imge.image = [UIImage imageNamed:@"new"];
    self.imageView = imge;
    [self.view addSubview:imge];
    
    // 1. 图片添加长按手势 截图
    UILongPressGestureRecognizer *gestur = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [imge addGestureRecognizer:gestur];
    
    
    // 2. 点击按钮截图
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenH - 70, ScreenW, 70)];
    [btn setTitle:@"我要截图" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.adjustsImageWhenHighlighted = NO;//去除按钮的按下效果（阴影）
    [self.view addSubview:btn];
    
}
-(void)buttonAction:(UIButton *)btn
{
    
    // 1. 截取屏幕 直接用window
    //     UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 2. 此处我截取的是的图片 所以直接用 self.imageView
    UIImage *image = [self snapshot:self.imageView];
    
    // 3. 截取指定区域 (例子 截取了 照片的一半)
    //    UIImage *image = [self imageFromImage:self.imageView.image inRect:CGRectMake(0, 0, self.imageView.width, self.imageView.height * 0.5)];
    
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)longPressAction:(UIGestureRecognizer *)gestrue
{
    if (gestrue.state != UIGestureRecognizerStateBegan)
    {
        //这个if一定要加，因为长按会有好几种状态，按住command键，点击UIGestureRecognizerStateBegan就能看到所有状态的枚举了，因为如果不加这句的话，此方法可能会被执行多次
        return;//什么操作都不做，直接跳出此方法
    }
    
    /*当然此处需要拿到你需要保存的图片*/
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存失败";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}




/**
 *  从图片中按指定的位置大小截取图片的一部分
 *
 *  @param image UIImage image 原始的图片
 *  @param rect  CGRect rect 要截取的区域
 *
 *  @return UIImage
 */
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}


@end


@end
