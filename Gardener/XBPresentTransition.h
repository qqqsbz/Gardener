//
//  XBPresentTransition.h
//  Gardener
//
//  Created by coder on 16/5/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,XBPresentTransitionType) {
    XBPresentTransitionTypePresent = 0,
    XBPresentTransitionTypeDismiss
};
@interface XBPresentTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transtionWithTransitionType:(XBPresentTransitionType)type;

- (instancetype)initWithTransitionType:(XBPresentTransitionType)type;

@end
