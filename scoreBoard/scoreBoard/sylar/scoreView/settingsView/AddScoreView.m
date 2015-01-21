//
//  AddScoreView.m
//  scoreBoard
//
//  Created by Sylar on 1/11/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//
////////////////////////////////////////////////////////////
#import "AddScoreView.h"
#import "MainSettingsView.h"
#import "ScoreBoardHeading.h"
#import "ScoreBoardViewController.h"
#import "CommonTool.h"
#import "ZenKeyboardView.h"
#import "Judgement.h"
////////////////////////////////////////////////////////////
# define kAutoCalculate       87
# define kAutoCalculateAll    88
////////////////////////////////////////////////////////////
@interface AddScoreView()
<UITextFieldDelegate, ZenKeyboardViewDelegate, UIActionSheetDelegate>
{
    NSMutableArray*   m_player_view;
    NSMutableArray*   m_text_view;
    ZenKeyboardView*  m_my_keyboard;
    UITextField*      m_current_text_field;
    UIButton*         m_auto_calculate_button;
}
@end
////////////////////////////////////////////////////////////
@implementation AddScoreView

- (id)initWithDelegate:(id)_delegate
{
    self = [super init];
    if (self) {
        self.p_delegate = _delegate;
        m_player_view = [[NSMutableArray alloc] init];
        m_text_view = [[NSMutableArray alloc] init];
        m_my_keyboard = nil;
        m_current_text_field = nil;
        m_auto_calculate_button = nil;
        [self setFrame:[MainSettingsView GetBigFrame]];
        [self SetInitialValue];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TouchBlank)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void) SetInitialValue
{
    UIView* bkg_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [bkg_view setBackgroundColor:[UIColor darkGrayColor]];
    [self addSubview:bkg_view];
    
    // button ok
    float delta = 10;
    float button_width = 100;
    float button_height = 50;
    float button_origin_y = self.frame.size.height-button_height-10;
    UIButton* btn_ok = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_ok setTitle:@"确定" forState:UIControlStateNormal];
    [btn_ok.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [btn_ok.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [btn_ok setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_ok setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_ok setBackgroundImage:[UIImage imageNamed:@"alertView_button_gray"] forState:UIControlStateNormal];
    [btn_ok setBackgroundImage:[UIImage imageNamed:@"alertView_button_gray_pressed"] forState:UIControlStateHighlighted];
    [btn_ok setFrame:CGRectMake(delta+self.frame.size.width/4-button_width/2, button_origin_y, button_width, button_height)];
    [btn_ok addTarget:self action:@selector(BtnOK) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_ok];
    
    // button cancel
    UIButton* btn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancel.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [btn_cancel.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [btn_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_cancel setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_cancel setBackgroundImage:[UIImage imageNamed:@"alertView_button_green"] forState:UIControlStateNormal];
    [btn_cancel setBackgroundImage:[UIImage imageNamed:@"alertView_button_green_pressed"] forState:UIControlStateHighlighted];
    [btn_cancel setFrame:CGRectMake(self.frame.size.width/4*3-button_width/2-delta, button_origin_y, button_width, button_height)];
    [btn_cancel addTarget:self action:@selector(BtnCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_cancel];
    
    // my keyboard
    m_my_keyboard = [[ZenKeyboardView alloc] init];
    [m_my_keyboard setDelegate:self];
    [m_my_keyboard setFrame:CGRectMake(0, 0, 320 , 216)];
    
    // scroll view
    int player_count = [Judgement GetCurrentPlayerNumber];
    for (int i=0; i<player_count; i++)
    {
        UIView* each_view = [[UIView alloc] init];
        [self addSubview:each_view];
        [m_player_view addObject:each_view];
    }
    float up_edge = MAX(delta, (6-player_count)*20);
    float bottom_edge = MAX(button_height, button_height+(6-player_count)*40);
    [CommonTool AutoLayoutView:self SubViews:m_player_view UpEdge:up_edge BottomEdge:bottom_edge SubviewWidth:self.frame.size.width-60 SubviewHeight:40];
    for (int i=0; i<player_count; i++)
    {
        UIView* each_view = [m_player_view objectAtIndex:i];
        NSString* each_player_name = [[Judgement GetCurrentJudgement] GetPlayerNameAtIndex:i];
        [self ModifyParentView:each_view AddPlayerName:each_player_name];
    }
    
    // modify ok and cancel button
    UIView* last_view = [m_player_view lastObject];
    float top = last_view.frame.size.height+last_view.frame.origin.y;
    CGRect frame_ok = btn_ok.frame;
    [btn_ok setFrame:CGRectMake(frame_ok.origin.x, (top+self.frame.size.height)/2-frame_ok.size.height/2, frame_ok.size.width, frame_ok.size.height)];
    CGRect frame_cancel = btn_cancel.frame;
    [btn_cancel setFrame:CGRectMake(frame_cancel.origin.x, btn_ok.frame.origin.y, frame_cancel.size.width, frame_cancel.size.height)];
    
    // auto calculat button
    m_auto_calculate_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_auto_calculate_button setImage:[UIImage imageNamed:@"autocalculate"] forState:UIControlStateNormal];
    [m_auto_calculate_button setHidden:YES];
    [m_auto_calculate_button addTarget:self action:@selector(BtnAutoCalculate) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_auto_calculate_button];
}

- (void) ModifyParentView:(UIView*)_parentView AddPlayerName:(NSString*)_name
{
    [_parentView setBackgroundColor:[UIColor clearColor]];
    CGRect parent_view_frame = _parentView.frame;
    
    // name
    UILabel* label_name = [[UILabel alloc] init];
    [label_name setFrame:CGRectMake(0, 0, parent_view_frame.size.width/3-10, parent_view_frame.size.height)];
    [label_name setText:_name];
    [label_name setTextColor:[UIColor whiteColor]];
    [label_name setTextAlignment:NSTextAlignmentRight];
    [_parentView addSubview:label_name];
    
    // textfield
    UITextField* text = [[UITextField alloc] init];
    [text setFrame:CGRectMake(parent_view_frame.size.width/3, 0, parent_view_frame.size.width/2, parent_view_frame.size.height)];
    [text setBorderStyle:UITextBorderStyleRoundedRect];
    [text setDelegate:self];
    [text setInputView:m_my_keyboard];
    [m_text_view addObject:text];
    [_parentView addSubview:text];
}

- (void) BtnOK
{
    if ([self SaveData])
    {
        [self RemoveSelf];
    }
    else
    {
        // show action sheet
        UIActionSheet* action_sheet = [[UIActionSheet alloc] initWithTitle:@"分数不为0" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
        [action_sheet showInView:self];
    }
}

- (void) BtnCancel
{
    [self RemoveSelf];
}

- (void) BtnAutoCalculate
{
    [self TouchBlank];
    int tag = [m_auto_calculate_button tag];
    if (tag == kAutoCalculate)
    {
        UITextField* empty_text_field = nil;
        int total_number = 0;
        for (int i=0; i<m_text_view.count; i++)
        {
            UITextField* each_text_field = [m_text_view objectAtIndex:i];
            int each_value = [each_text_field.text intValue];
            if (each_value == 0)
            {
                empty_text_field = each_text_field;
            }
            else
            {
                total_number += each_value;
            }
        }
        [empty_text_field setText:[NSString stringWithFormat:@"%d", -total_number]];
    }
    else if (tag == kAutoCalculateAll)
    {
        UITextField* the_text_field = nil;
        int score =0;
        for (int i=0; i<m_text_view.count; i++)
        {
            UITextField* each_text_field = [m_text_view objectAtIndex:i];
            int each_value = [each_text_field.text intValue];
            if (each_value != 0)
            {
                the_text_field = each_text_field;
                score = each_value;
                i=100;
            }
        }
        for (int i=0; i<m_text_view.count; i++)
        {
            UITextField* each_text_field = [m_text_view objectAtIndex:i];
            if (each_text_field == the_text_field)
            {
                [each_text_field setText:[NSString stringWithFormat:@"%d", score*(m_text_view.count-1)]];
            }
            else
            {
                [each_text_field setText:[NSString stringWithFormat:@"%d", -score]];
            }
        }
    }
}

- (void) RemoveSelf
{
    if ([self.p_delegate respondsToSelector:@selector(cbFromMainSettingView:Id:)])
    {
        NSString* ss = [NSString stringWithFormat:@"%d", kAddScoreViewClose];
        [self.p_delegate performSelector:@selector(cbFromMainSettingView:Id:) withObject:nil withObject:ss];
    }
}

- (void) TouchBlank
{
    if (m_current_text_field)
    {
        [m_current_text_field resignFirstResponder];
//        [self ShowAutoCalculateButton];
        m_current_text_field = nil;
    }
}

- (void) ShowAutoCalculateButton
{
    UITextField* the_empty_field = nil;
    UITextField* the_edited_field = nil;
    int text_count = m_text_view.count;
    int zero_count = 0;
    for (int i=0; i<text_count; i++)
    {
        UITextField* each_text_field = [m_text_view objectAtIndex:i];
        NSString* each_text = each_text_field.text;
        if (each_text.intValue == 0)
        {
            zero_count ++;
            the_empty_field = each_text_field;
        }
        else
        {
            the_edited_field = each_text_field;
        }
    }
    if (zero_count == 1)
    {
        UIView* the_view = [the_empty_field superview];
        CGRect frame = the_view.frame;
        [m_auto_calculate_button setHidden:NO];
        [m_auto_calculate_button setFrame:CGRectMake(frame.origin.x+frame.size.width-30, frame.origin.y, frame.size.height, frame.size.height)];
        [m_auto_calculate_button setImage:[UIImage imageNamed:@"autocalculate"] forState:UIControlStateNormal];
        [m_auto_calculate_button setTag:kAutoCalculate];
    }
    else if (zero_count == text_count-1)
    {
        UIView* the_view = [the_edited_field superview];
        CGRect frame = the_view.frame;
        [m_auto_calculate_button setHidden:NO];
        [m_auto_calculate_button setFrame:CGRectMake(frame.origin.x+frame.size.width-30, frame.origin.y, frame.size.height, frame.size.height)];
        [m_auto_calculate_button setImage:[UIImage imageNamed:@"autocalculate_all"] forState:UIControlStateNormal];
        [m_auto_calculate_button setTag:kAutoCalculateAll];
    }
    else
    {
        [m_auto_calculate_button setHidden:YES];
    }
}

- (BOOL) SaveData
{
    int total_score = 0;
    for (UITextField* each_text_field in m_text_view)
    {
        int each_score = [each_text_field.text intValue];
        total_score += each_score;
    }
    BOOL rt = YES;
    if (total_score != 0)
    {
        rt = NO;
    }
    else
    {
        [self SaveDataToJudgement];
    }
    return rt;
}

- (void) SaveDataToJudgement
{
    int player_count = [Judgement GetCurrentPlayerNumber];
    NSMutableArray* scores = [[NSMutableArray alloc] init];
    for (int i=0; i<player_count; i++)
    {
        UITextField* each_text_field = [m_text_view objectAtIndex:i];
        [scores addObject:each_text_field.text];
    }
    [[Judgement GetCurrentJudgement] AddOneLineScore:scores];
}

// delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_current_text_field = textField;
    UIView* parent_view = [textField superview];
    if (parent_view.frame.origin.y > 200)
    {
        float dis = parent_view.frame.origin.y - 200;
        CGRect frame = self.frame;
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y-dis, frame.size.width, frame.size.height)];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self setFrame:[MainSettingsView GetBigFrame]];
    [self ShowAutoCalculateButton];
}

- (void)didNumericKeyPressed:(UIButton *)button
{
    NSString* new_string = button.titleLabel.text;
    NSString* old_string = m_current_text_field.text;
    if ([new_string isEqualToString:@"-"])
    {
        if ([old_string isEqualToString:@""])
        {
            [m_current_text_field setText:@"-"];
        }
        else
        {
            int number = [old_string intValue];
            [m_current_text_field setText:[NSString stringWithFormat:@"%d", -number]];
        }
    }
    else
    {
        [m_current_text_field setText:[NSString stringWithFormat:@"%@%@", old_string, new_string]];
    }
}

- (void)didBackspaceKeyPressed
{
    NSInteger length = m_current_text_field.text.length;
    if (length == 0) {
        m_current_text_field.text = @"";
        return;
    }
    NSString *substring = [m_current_text_field.text substringWithRange:NSMakeRange(0, length - 1)];
    m_current_text_field.text = substring;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"action sheet");
    if (buttonIndex == 0)
    {
        // 确定
        [self SaveDataToJudgement];
        [self RemoveSelf];
    }
}



@end
