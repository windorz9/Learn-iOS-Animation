//
//  ZXLoadingHudView.h
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/15.
//  Copyright © 2019 Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXLoadingHudView : UIVisualEffectView

+ (instancetype)sharedLoadingHud;

- (void)hudShow;

- (void)hudDismiss;

@end

