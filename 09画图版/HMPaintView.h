//
//  HMPaintView.h
//  09画图版
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMPaintView : UIView
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;

// 用来保存要绘制的图片的属性
@property (nonatomic, strong) UIImage *image;


// 清屏
- (void)cleanScreen;

// 回退
- (void)undo;

// 擦除
- (void)erase;

// 保存到相册
- (void)save;

@end
