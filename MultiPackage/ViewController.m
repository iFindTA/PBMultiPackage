//
//  ViewController.m
//  MultiPackage
//
//  Created by nanhujiaju on 2017/6/5.
//  Copyright © 2017年 nanhujiaju. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    CGRect bounds = CGRectMake(100, 100, 100, 50);
    UILabel *label = [[UILabel alloc] initWithFrame:bounds];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    
    bounds.origin.y += 100;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:bounds];
    imgv.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imgv];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
