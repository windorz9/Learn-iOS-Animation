//
//  ZXSectionModel.h
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/8.
//  Copyright © 2019 Q. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSectionModel : NSObject

/** section title */
@property (nonatomic, copy) NSString *title;

/** subTitles */
@property (nonatomic, strong) NSArray *subTitles;

@end

NS_ASSUME_NONNULL_END
