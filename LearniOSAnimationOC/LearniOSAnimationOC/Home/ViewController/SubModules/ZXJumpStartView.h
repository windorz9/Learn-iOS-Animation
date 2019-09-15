//
//  ZXJumpStartView.h
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/15.
//  Copyright © 2019 Q. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JumpStartViewState) {
    JumpStartViewStatePositive, // 正面
    JumpStartViewStateNegative, // 反面
};

@interface ZXJumpStartView : UIView

/** State */
@property (nonatomic, assign) JumpStartViewState state;
/** positive image */
@property (nonatomic, strong) UIImage *positiveImage;
/** negative image */
@property (nonatomic, strong) UIImage *negativeImage;

- (void)jumpViewAnimatedStart;

@end


