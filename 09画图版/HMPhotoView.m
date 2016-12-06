//
//  HMPhotoView.m
//  09画图版
//
//  Created by apple on 15/5/16.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMPhotoView.h"


@interface HMPhotoView () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIImageView *imgPhoto;
@end

@implementation HMPhotoView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame photo:(UIImage *)photo
{
    if (self = [super initWithFrame:frame]) {
        // 创建一个图片框, 并且把图片框添加到当前view中
        UIImageView *imgPhoto = [[UIImageView alloc] initWithImage:photo];
        // 设置允许与用户交互
        imgPhoto.userInteractionEnabled = YES;
        // 允许多点触摸
        imgPhoto.multipleTouchEnabled = YES;
        [self addSubview:imgPhoto];
        self.imgPhoto = imgPhoto;
        
        
        // 为图片框, 添加手势识别
        
        // 1. 旋转
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)];
        rotation.delegate = self;
        [imgPhoto addGestureRecognizer:rotation];
        
        // 2. 捏合手势, 缩放
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        pinch.delegate = self;
        [imgPhoto addGestureRecognizer:pinch];
        
        
        // 3. 拖拽手势, 平移
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [imgPhoto addGestureRecognizer:pan];
        
        
        
        
        // 4. 长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        [imgPhoto addGestureRecognizer:longPress];
        
        
        
    }
    return self;
        
}

// 长按手势
- (void)longPressGesture:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.5 animations:^{
            recognizer.view.alpha = 0.5;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                recognizer.view.alpha = 1;
                // 当图片闪烁完毕后, 把图片绘制到"绘图View"上
                
                
                
                
                
                
                
                // 把截取出来的图像, 通过代理传递给控制器
                if ([self.delegate respondsToSelector:@selector(photoView:withImage:)]) {
                    // ------------ 截图（把当前view的图像截取到一个UIImage中） --------------------
                    // 1. 创建一个图片的上下文
                    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
                    
                    // 2. 获取当前上下文对象
                    CGContextRef ctx = UIGraphicsGetCurrentContext();
                    // 3. 把当前view的图像绘制到ctx这个上下文中
                    [self.layer renderInContext:ctx];
                    // 4. 从ctx上下文中获取图片
                    UIImage *photoViewImage = UIGraphicsGetImageFromCurrentImageContext();
                    // 5. 结束绘图上下文
                    UIGraphicsEndImageContext();
                    // ------------ 截图（把当前view的图像截取到一个UIImage中） --------------------
                    
                    
                    // 调用代理把截取好的图片传递给控制器
                    [self.delegate photoView:self withImage:photoViewImage];
                    
                    
                }
                
            }];
        }];
    }
    
}


// 捏合手势
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    
    recognizer.scale = 1;
}

// 拖拽
- (void)panGesture:(UIPanGestureRecognizer *)recognizer
{
    // 1. 先获取手势中平移的值
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    // 2.执行平移
    recognizer.view.transform = CGAffineTransformTranslate(recognizer.view.transform, translation.x, translation.y);
    
    // 3. 清零
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

// 旋转
- (void)rotationGesture:(UIRotationGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

+ (instancetype)photoViewWithImage:(UIImage *)photo frame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame photo:photo];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
