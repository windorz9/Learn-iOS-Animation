//
//  ZXInteractiveCardView.h
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/16.
//  Copyright © 2019 Q. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXInteractiveCardView : UIImageView

/** 识别手势的视图 */
@property (nonatomic, strong) UIView *gestureView;
/** 外界进行渐变的视图 */
@property (nonatomic, strong) UIView *dismissView;

@end

NS_ASSUME_NONNULL_END
