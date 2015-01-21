//
//  CommonTool.m
//  scoreBoard
//
//  Created by Sylar on 1/8/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//

#import "CommonTool.h"

@implementation CommonTool

+ (float) GetScreenHeight
{
    float rt = [[UIScreen mainScreen] bounds].size.height;
    return rt;
}

+ (float) GetScreenWidth
{
    float rt = [[UIScreen mainScreen] bounds].size.width;
    return rt;
}

+ (void) AutoLayoutView:(UIView*)_mainView Subviews:(NSArray*)_subviews LeftEdge:(float)_leftEdge
{
    // 所有subviews都紧挨在一起
    int subview_count = _subviews.count;
    if (subview_count <= 0)
        return;
    CGRect main_view_frame = _mainView.frame;
    float total_width = main_view_frame.size.width-_leftEdge;
    if (total_width < 5)
        return;
    
    float each_subview_width = total_width/subview_count;
    for (int i=0; i<subview_count; i++)
    {
        UIView* each_subview = [_subviews objectAtIndex:i];
        [each_subview setFrame:CGRectMake(_leftEdge+i*each_subview_width, 0, each_subview_width, main_view_frame.size.height)];
    }
}

+ (void) AutoLayoutView:(UIView*)_parentView SubViews:(NSArray*)_subViews UpEdge:(float)_upEdge BottomEdge:(float)_bottomEdge SubviewWidth:(float)_subViewWidth SubviewHeight:(float)_subViewHeight
{
    // 自动layout  有分割
    int subview_count = _subViews.count;
    if (subview_count < 1)
        return;
    CGRect parent_view_frame = _parentView.frame;
    if (_upEdge+_bottomEdge >= parent_view_frame.size.height)
        return;
    
    float origin_x = parent_view_frame.size.width/2 - _subViewWidth/2;
    float gap = (parent_view_frame.size.height - _upEdge - _bottomEdge)/subview_count;
    for (int i=0; i<subview_count; i++)
    {
        UIView* each_subview = [_subViews objectAtIndex:i];
        [each_subview setFrame:CGRectMake(origin_x, _upEdge+i*gap, _subViewWidth, _subViewHeight)];
    }
}

+ (UIImage*) GetGreenImage
{
    UIImage* img = [UIImage imageNamed:@"btn_bkg"];
    UIImage* rt = [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height/2, img.size.width/2, img.size.height/2, img.size.width/2)];
    return rt;
}

+(void)lockAnimationForView:(UIView*)view
{
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}



@end
