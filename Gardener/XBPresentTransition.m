//
//  XBPresentTransition.m
//  Gardener
//
//  Created by coder on 16/5/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBPresentTransition.h"
#import "CollectionViewCell.h"
#import "ViewController.h"
#import "CollectionViewController.h"
@interface XBPresentTransition()
@property (assign, nonatomic) XBPresentTransitionType  type;
@end
@implementation XBPresentTransition

+ (instancetype)transtionWithTransitionType:(XBPresentTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XBPresentTransitionType)type
{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return .7f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case XBPresentTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case XBPresentTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}


- (void)presentAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //设置位移动画
    CollectionViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CollectionViewCell *cell = (CollectionViewCell *)[fromVC.collectionView cellForItemAtIndexPath:fromVC.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    //获取cell图片的截图 并且设置该图片在containerView上的位置
    UIView *tempView = [cell.coverImageView snapshotViewAfterScreenUpdates:NO];
    tempView.frame = [cell.coverImageView convertRect:cell.coverImageView.bounds toView:containerView];

    toVC.separatorView.hidden = YES;
    toVC.imageView.hidden = YES;
    cell.coverImageView.hidden = YES;
    toVC.view.alpha = 0.f;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
        //将截图的位置移动到toVC imageView 的位置
        tempView.frame = [toVC.imageView convertRect:toVC.imageView.bounds toView:containerView];
        toVC.view.alpha = 1.f;
    } completion:^(BOOL finished) {
        tempView.hidden = YES;
        toVC.imageView.hidden = NO;
        toVC.separatorView.hidden = NO;
    }];
    
    //设置缩放动画
    //计算小圆半径
    CGFloat startRadius = CGRectGetWidth(cell.coverImageView.frame) / 2.f;
    CGRect frame = [cell.coverImageView convertRect:cell.coverImageView.bounds toView:containerView];
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    //设置小圆路径
    UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:center radius:startRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    //计算获取在x和y方向按钮距离边缘的最大值，然后利用勾股定理即可算出最大半径
    CGFloat x = MAX(tempView.center.x, CGRectGetWidth(containerView.frame) - tempView.center.x + startRadius);
    CGFloat y = MAX(tempView.center.y, CGRectGetHeight(containerView.frame) - tempView.center.y + startRadius);
    CGFloat endRadius = sqrtf(pow(x, 2.f) + pow(y, 2.f));
    //设置大圆路径
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:center radius:endRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endPath.CGPath;
    toVC.view.layer.mask = maskLayer;
    toVC.view.backgroundColor = [UIColor colorWithRed:129.f/255.f green:203.f/255.f blue:93.f/255.f alpha:1];
    
    //设置动画
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    startAnimation.fromValue = (__bridge id)startPath.CGPath;
    startAnimation.toValue   = (__bridge id)endPath.CGPath;
    startAnimation.duration  = [self transitionDuration:transitionContext];
    startAnimation.delegate  = self;
    startAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [startAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:startAnimation forKey:@"path"];
    
}

- (void)dismissAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    ViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CollectionViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CollectionViewCell *cell = (CollectionViewCell *)[toVC.collectionView cellForItemAtIndexPath:toVC.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    UIView *tempView = containerView.subviews.lastObject;
    
    tempView.hidden = NO;
    fromVC.imageView.hidden = YES;
    fromVC.separatorView.hidden = YES;
    [containerView insertSubview:toVC.view atIndex:0];
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
        tempView.frame = [cell.coverImageView convertRect:cell.coverImageView.bounds toView:containerView];
        toVC.view.alpha = 1.f;
    } completion:^(BOOL finished) {
        cell.coverImageView.hidden = NO;
    }];
    
    
    CGRect frame = [cell.coverImageView convertRect:cell.coverImageView.bounds toView:containerView];
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    
    
    CGFloat endRadius = CGRectGetWidth(cell.coverImageView.frame) / 2.f;
    
    CGFloat x = MAX(tempView.center.x, CGRectGetWidth(containerView.frame) - tempView.center.x + endRadius);
    CGFloat y = MAX(tempView.center.y, CGRectGetHeight(containerView.frame) - tempView.center.y + endRadius);
    CGFloat startRaduis = sqrtf(pow(x, 2.f) + pow(y, 2.f));
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:center radius:startRaduis startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:center radius:endRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    fromVC.view.backgroundColor = [UIColor colorWithRed:129.f/255.f green:203.f/255.f blue:93.f/255.f alpha:1];
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    endAnimation.fromValue = (__bridge id)startPath.CGPath;
    endAnimation.toValue   = (__bridge id)endPath.CGPath;
    endAnimation.duration  = [self transitionDuration:transitionContext] * 1.12;
    endAnimation.delegate  = self;
    endAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [endAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:endAnimation forKey:@"path"];

}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    id <UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    switch (_type) {
        case XBPresentTransitionTypePresent:
        {
            ViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toVC.view.backgroundColor = [UIColor colorWithRed:241.f/255.f green:246.f/255.f blue:255.f/255.f alpha:1.f];
            toVC.separatorView.hidden = NO;
            [transitionContext completeTransition:YES];
        }
            break;
        case XBPresentTransitionTypeDismiss:
        {
            CollectionViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toVC.view.backgroundColor = [UIColor colorWithRed:241.f/255.f green:246.f/255.f blue:255.f/255.f alpha:1.f];
            ViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            fromVC.separatorView.hidden = NO;
            [[transitionContext containerView].subviews.lastObject removeFromSuperview];
            [transitionContext completeTransition:YES];
        }
            break;
    }
}

@end
