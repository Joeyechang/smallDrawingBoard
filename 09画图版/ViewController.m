//
//  ViewController.m
//  09画图版
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "ViewController.h"
#import "HMPaintView.h"
#import "HMPhotoView.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, HMPhotoViewDelegate>
@property (weak, nonatomic) IBOutlet HMPaintView *paintView;
@property (weak, nonatomic) IBOutlet UISlider *sliderWidth;
@property (weak, nonatomic) IBOutlet UIButton *btnRed;

@end

@implementation ViewController

// 清屏
- (IBAction)cleanScreen:(id)sender {
    [self.paintView cleanScreen];
}

// 回退
- (IBAction)undo:(id)sender {
    [self.paintView undo];
}

// 擦除
- (IBAction)erase:(id)sender {
    [self.paintView erase];
}

// 保存
- (IBAction)save:(id)sender {
    [self.paintView save];
}

// 插入一张"照片"
- (IBAction)selectPhoto:(id)sender {
    
    // 1. 创建一个用来打开"照片库"的控制器
    UIImagePickerController *pkVc = [[UIImagePickerController alloc] init];
    
    // 2. 设置这个控制器的类型
    // UIImagePickerControllerSourceTypePhotoLibrary 照片库(按照专辑分的)
    // UIImagePickerControllerSourceTypeSavedPhotosAlbum （按照拍照时刻，按照保存到Album里面的时间）
    pkVc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // 3. 代理(设置这个代理的目的就是为了编写当用户选择完毕照片以后的代码)
    pkVc.delegate = self;
    
    
    // 4. 把这个控制器显示出来
    [self presentViewController:pkVc animated:YES completion:nil];
}


// HMPhotoViewDelegate的代理方法
- (void)photoView:(HMPhotoView *)photoView withImage:(UIImage *)image
{
   // NSLog(@"%@", image);
    
    self.paintView.image = image;
    
    
    // 把空白的透明view移除
    [photoView removeFromSuperview];
}


// UIImagePickerController的代理方法
// 这个方法, 当用户选择完毕照片以后就会调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)infoimagePickerController
{
    //NSLog(@"%@", infoimagePickerController);
    // 1. 获取用户选择的照片, 把照片添加到"绘图view"上
    UIImage *img = infoimagePickerController[UIImagePickerControllerOriginalImage];
    // 创建一个用来显示图片的View
    HMPhotoView *photoView = [HMPhotoView photoViewWithImage:img frame:self.paintView.frame];
    
    
    // 设置photoView的代理
    photoView.delegate = self;
    
    // 不要！！！
    //[self.paintView addSubview:photoView];
    
    [self.view addSubview:photoView];
    
    // 2. 关闭"照片选择控制器"
    // 调用当前控制器的dismiss方法, 也能将被modal出的控制器关闭
    [self dismissViewControllerAnimated:YES completion:nil];
}






// 设置颜色按钮的单击事件
- (IBAction)buttonColorClick:(UIButton *)sender {
    self.paintView.lineColor = sender.backgroundColor;
}




// slider 的value changed事件
// 通过slider改变线宽
- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.paintView.lineWidth = sender.value;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 设置默认的线宽
    self.paintView.lineWidth = self.sliderWidth.value;
    
    
    // 设置默认的paintView中的线的颜色等于第一个按钮的背景色
    self.paintView.lineColor = self.btnRed.backgroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
