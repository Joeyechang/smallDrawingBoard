//
//  HMPhotoView.h
//  09画图版
//
//  Created by apple on 15/5/16.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMPhotoView;

@protocol HMPhotoViewDelegate <NSObject>

- (void)photoView:(HMPhotoView *)photoView withImage:(UIImage *)image;

@end

@interface HMPhotoView : UIView

@property (nonatomic, weak) id<HMPhotoViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame photo:(UIImage *)photo;

+ (instancetype)photoViewWithImage:(UIImage *)photo frame:(CGRect)frame;
@end
