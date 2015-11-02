//
//  ViewController.m
//  TCQRCodeDemo
//
//  Created by 程天聪 on 15/11/2.
//  Copyright © 2015年 CTC. All rights reserved.
//

#import "ViewController.h"
#import "TCQRCode.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)makeQRCode {
    [_textField resignFirstResponder];
    NSInteger num = arc4random() % 10;
    NSString *imageString;
    if (num<5) {
        imageString = @"head_009.jpg";
    } else {
        imageString = @"head_006.jpg";
    }
    [_imageView removeFromSuperview];
    _imageView = [TCQRCode QRCodeImageViewWithContent:_textField.text colorWithRed:123 green:123 blue:123 centerImage:[UIImage imageNamed:imageString] frame:CGRectMake(0, 0, 200, 200)];
    _imageView.center = self.view.center;
    [self.view addSubview:_imageView];
    _imageView.layer.borderWidth = 1.0;
    _imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - UITextFieldDelegate - Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
