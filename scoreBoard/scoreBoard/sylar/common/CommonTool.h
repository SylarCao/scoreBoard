//
//  CommonTool.h
//  scoreBoard
//
//  Created by Sylar on 1/8/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

+ (float) GetScreenHeight;

+ (float) GetScreenWidth;

+ (void) AutoLayoutView:(UIView*)_mainView Subviews:(NSArray*)_subviews LeftEdge:(float)_leftEdge;

+ (void) AutoLayoutView:(UIView*)_parentView SubViews:(NSArray*)_subViews UpEdge:(float)_upEdge BottomEdge:(float)_bottomEdge SubviewWidth:(float)_subViewWidth SubviewHeight:(float)_subViewHeight;

+ (UIImage*) GetGreenImage;

+(void)lockAnimationForView:(UIView*)view;


@end
