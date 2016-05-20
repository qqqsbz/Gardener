//
//  CollectionViewCell.m
//  Gardener
//
//  Created by coder on 16/5/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "CollectionViewCell.h"
@interface CollectionViewCell()
@property (assign, nonatomic) CGFloat  radius;
@end
@implementation CollectionViewCell
- (void)awakeFromNib
{
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.layer.cornerRadius  = CGRectGetWidth(self.coverImageView.frame) / 2.f;
    self.radius = CGRectGetWidth(self.coverImageView.frame)  / 2 + 7.f;
    [self drawCycle];
}

- (void)drawCycle
{
    //124 200 81
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 2.5f;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.path = [UIBezierPath bezierPathWithArcCenter:self.coverImageView.center radius:self.radius startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
    [self.contentView.layer addSublayer:layer];
}

- (void)setPercent:(float)percent
{
    _percent = percent;
    if (_percent > 1.f) return;
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 2.5f;
    layer.strokeStart = 0;
    layer.strokeEnd = 1.f;
    layer.strokeColor = [UIColor colorWithRed:129.f/255.f green:203.f/255.f blue:93.f/255.f alpha:1].CGColor;
    layer.path = [UIBezierPath bezierPathWithArcCenter:self.coverImageView.center radius:self.radius startAngle:-(M_PI * 0.5) endAngle:M_PI * 1.5 clockwise:YES].CGPath;
    [self.contentView.layer addSublayer:layer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0.f;
    animation.toValue   = @(percent);
    animation.duration  = 0.25f;
    animation.fillMode  = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:animation forKey:@"strokeEnd"];
    
}

@end
