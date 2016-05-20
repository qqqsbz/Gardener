//
//  ViewController.m
//  Gardener
//
//  Created by coder on 16/5/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = [UIImage imageNamed:self.imageURL];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius  = CGRectGetWidth(self.imageView.frame) / 2.f;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHandler)]];
}

- (void)dismissHandler
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
