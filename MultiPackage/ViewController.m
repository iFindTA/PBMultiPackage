//
//  ViewController.m
//  MultiPackage
//
//  Created by nanhujiaju on 2017/6/5.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import "ViewController.h"
#import <PBKits/PBKits.h>
#define MAS_SHORT
#define MAS_SHORT_HAND
#import <Masonry/Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSString *cnn = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Channel"];
    cnn = [NSBundle pb_mainBundle4key:@"Channel" atPlist:@"custom"];
    CGRect bounds = CGRectZero;
    CGFloat offset = 100;
    UILabel *label = [[UILabel alloc] initWithFrame:bounds];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    label.text = cnn;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(offset);
        make.right.equalTo(self.view).offset(-offset);
        make.height.equalTo(@(offset * 0.5));
    }];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:bounds];
    imgv.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(offset);
        make.left.right.equalTo(label);
        make.height.equalTo(@(offset*0.5));
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
