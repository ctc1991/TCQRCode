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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.backgroundColor = [UIColor whiteColor];
    _textField.leftView = view;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
    _imageView = [TCQRCode QRCodeImageViewWithContent:_textField.text colorWithRed:0 green:0 blue:0 centerImage:[UIImage imageNamed:imageString] frame:CGRectMake(0, 0, 320, 320)];
    _imageView.center = self.view.center;
    [self.view addSubview:_imageView];
    _imageView.layer.borderWidth = 1.0;
    _imageView.layer.borderColor = [UIColor redColor].CGColor;
    _imageView.backgroundColor = [UIColor greenColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate - Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
