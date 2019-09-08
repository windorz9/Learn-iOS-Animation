//
//  ZXSectionModel.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/8.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXSectionModel.h"
#import "ZXRowModel.h"
#import "YYModel.h"

@implementation ZXSectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             @"title" : @"title",
             @"subTitles" : [ZXRowModel class]
             };
}

@end
