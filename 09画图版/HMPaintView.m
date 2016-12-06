//
//  HMPaintView.m
//  09画图版
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMPaintView.h"
#import "HMBezierPath.h"

@interface HMPaintView ()
//@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) NSMutableArray *paths;


@end


@implementation HMPaintView

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    // 1. 创建一个HMBezierPath对象
    HMBezierPath *path = [[HMBezierPath alloc] init];
    // 2. 把这个HMBezierPath添加到self.paths集合中
    path.image = image;
    [self.paths addObject:path];
    
    // 3. 重绘
    [self setNeedsDisplay];
    
}

// 清屏
- (void)cleanScreen
{
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
}

// 回退
- (void)undo
{
    [self.paths removeLastObject];
    [self setNeedsDisplay];
}

// 擦除
- (void)erase
{
    // 设置当前画笔的颜色与view的背景色一样, 然后当用户绘制的时候其实就是擦除
    self.lineColor = self.backgroundColor;
}

// 保存到相册
- (void)save
{
    // 把当前view中的内容渲染到一个图片中
    // 1. 开启一个绘图上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    // 2. 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 3. 把当前的view渲染到上下文中
    [self.layer renderInContext:ctx];
    
    // 4. 从上下文中获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5. 关闭绘图上下文
    UIGraphicsEndImageContext();
    
    
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// 把图片保存到相册中后执行的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"操作提示" message:@"保存到成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

// 封装一个根据touches获取触摸点的方法
- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = touches.anyObject;
    return [touch locationInView:touch.view];
}


#pragma mark - 触摸事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1. 获取触摸点
    CGPoint point = [self pointWithTouches:touches];
    
    // 创建一个UIBezierPath 对象
    HMBezierPath *path = [[HMBezierPath alloc] init];
    // 每一个path都有自己的线宽
    path.lineWidth = self.lineWidth;
    
    // 设置颜色
    path.lineColor = self.lineColor;
    
    
    // 向path对象中添加一个起点
    [path moveToPoint:point];
    
    // 把刚刚创建好的BezierPath对象添加到数组中
    [self.paths addObject:path];
    
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1. 获取触摸点
    CGPoint point = [self pointWithTouches:touches];
    
    // 从数组中获取最后一个UIBezierPath对象(这个就是当前这次触摸创建的UIBezierPath对象)
    HMBezierPath *path = [self.paths lastObject];
    // 2. 把当前点添加到path对象中
    [path addLineToPoint:point];
    
    
    // 重绘
    [self setNeedsDisplay];
}




- (void)drawRect:(CGRect)rect {
    // 把paths数组中的每一个UIBezierPath对象都stroke一下
    for (HMBezierPath *path in self.paths) {
        
        if (path.image != nil) {
            // 画图片
            [path.image drawInRect:rect];
        } else {
            path.lineCapStyle = kCGLineCapSquare;
            path.lineJoinStyle = kCGLineJoinRound;
            
            // 每个path对象在渲染之前, 设置使用自己的颜色来渲染
            [path.lineColor set];
            
            [path stroke];
        }
    }
    
}


@end
