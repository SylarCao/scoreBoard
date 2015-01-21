//
//  AddPlayerView.m
//  scoreBoard
//
//  Created by Sylar on 1/11/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//
//////////////////////////////////////////////////////////////////
#import "AddPlayerView.h"
#import "Judgement.h"
#import "CommonTool.h"
//////////////////////////////////////////////////////////////////
#define AlertViewWidth 280.0f
#define AlertViewHeight 175.0f
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
CGRect XYScreenBounds()
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationUnknown == orient)
        orient = UIInterfaceOrientationPortrait;
    
    if (UIInterfaceOrientationIsLandscape(orient))
    {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    return bounds;
}
//////////////////////////////////////////////////////////////////
@interface AddPlayerView()
<UITextFieldDelegate>
{
    UITextField* m_text_field;
    UIImageView* m_bkg_view;
    UIView*      m_black_view;  //灰色的全屏的背景
}
@end
//////////////////////////////////////////////////////////////////
@implementation AddPlayerView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        m_text_field = nil;
        m_bkg_view = nil;
        m_black_view = nil;
        [self SetInitialValue];
        [self Show];
    }
    return self;
}

- (void) SetInitialValue
{
    CGRect screenBounds = XYScreenBounds();
    [self setFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
    // gray bkg
    m_black_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
    m_black_view.backgroundColor = [UIColor grayColor];
    m_black_view.opaque = YES;
    m_black_view.alpha = 0.5f;
    m_black_view.userInteractionEnabled = YES;
    [self addSubview:m_black_view];
    
    // background
    m_bkg_view = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"alertView_bg.png"] stretchableImageWithLeftCapWidth:34 topCapHeight:44]];
    m_bkg_view.userInteractionEnabled = YES;
    m_bkg_view.frame = CGRectMake(0, 0, AlertViewWidth, AlertViewHeight);
    m_bkg_view.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);
    [self addSubview:m_bkg_view];
    
    // label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 240, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = @"请输入玩家名字";
    [m_bkg_view addSubview:titleLabel];
    
    // text field
    float text_field_width = 180;
    float text_filed_height = 30;
    m_text_field = [[UITextField alloc] initWithFrame:CGRectMake((AlertViewWidth-text_field_width)/2, 50, text_field_width, text_filed_height)];
    [m_bkg_view addSubview:m_text_field];
    [m_text_field setBorderStyle:UITextBorderStyleRoundedRect];
    [m_text_field setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // ok button
    float buttonWidth = (AlertViewWidth - 100.0f) / 2;
    float buttonPadding = 100.0f / (2 - 1 + 2 * 2);
    UIButton* btn_ok = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_ok setTitle:@"确定" forState:UIControlStateNormal];
    [btn_ok.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [btn_ok.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [btn_ok setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_ok setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_ok setBackgroundImage:[UIImage imageNamed:@"alertView_button_gray"] forState:UIControlStateNormal];
    [btn_ok setBackgroundImage:[UIImage imageNamed:@"alertView_button_gray_pressed"] forState:UIControlStateHighlighted];
    btn_ok.frame = CGRectMake(buttonPadding * 2, 107, buttonWidth, 44);
    [btn_ok addTarget:self action:@selector(BtnOk) forControlEvents:UIControlEventTouchUpInside];
    [m_bkg_view addSubview:btn_ok];
    
    // cancel button
    UIButton* btn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancel.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [btn_cancel.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [btn_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_cancel setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_cancel setBackgroundImage:[UIImage imageNamed:@"alertView_button_green"] forState:UIControlStateNormal];
    [btn_cancel setBackgroundImage:[UIImage imageNamed:@"alertView_button_green_pressed"] forState:UIControlStateHighlighted];
    btn_cancel.frame = CGRectMake(buttonPadding * 2 + buttonPadding + buttonWidth, 107, buttonWidth, 44);
    [btn_cancel addTarget:self action:@selector(BtnCancel) forControlEvents:UIControlEventTouchUpInside];
    [m_bkg_view addSubview:btn_cancel];
}

- (void) BtnOk
{
    NSString* name = [m_text_field text];
    if ([[Judgement GetCurrentJudgement] AddOnePlayerWithName:name])
    {
        [self Hide];
    }
    else
    {
        [CommonTool lockAnimationForView:m_text_field];
    }
}

- (void) BtnCancel
{
    [self Hide];
}

- (void) Show
{
    CGRect frame = m_bkg_view.frame;
    frame.origin.y = -AlertViewHeight;
    [m_bkg_view setFrame:frame];
    [UIView animateWithDuration:0.2f animations:^{
        m_bkg_view.center = CGPointMake(XYScreenBounds().size.width / 2, XYScreenBounds().size.height / 2);
    }completion:^(BOOL finished) {
                         
    }];
}

- (void) Hide
{
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = m_bkg_view.frame;
        frame.origin.y = -AlertViewHeight;
        [m_bkg_view setFrame:frame];
    }completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
    }];
}

-(void)keyboardWillShow:(NSNotification*)aNotification
{
    CGRect screenBounds = XYScreenBounds();
    m_bkg_view.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height/4);
}


@end
