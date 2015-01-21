//
//  DeletePlayerView.m
//  scoreBoard
//
//  Created by Sylar on 1/10/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//
///////////////////////////////////////////////////////////////
#import "DeletePlayerView.h"
#import "CommonTool.h"
#import "AFPickerView.h"
#import "Judgement.h"
///////////////////////////////////////////////////////////////
const float c_picker_view_height = 200;
///////////////////////////////////////////////////////////////
@interface DeletePlayerView()
<AFPickerViewDelegate, AFPickerViewDataSource>
{
    AFPickerView* m_picker_view;
}
@end
///////////////////////////////////////////////////////////////
@implementation DeletePlayerView

- (id) init
{
    self = [super init];
    if (self)
    {
        m_picker_view = nil;
        [self SetInitialValue];
    }
    return self;
}

- (void) SetInitialValue
{
    [self setFrame:CGRectMake(0, 0, [CommonTool GetScreenWidth], [CommonTool GetScreenHeight])];
    
    // whole background
    UIView* bkg_view = [[UIView alloc] init];
    [bkg_view setFrame:self.frame];
    bkg_view.backgroundColor = [UIColor grayColor];
    bkg_view.opaque = YES;
    bkg_view.alpha = 0.5f;
    bkg_view.userInteractionEnabled = YES;
    [self addSubview:bkg_view];
    
    // picker
    CGRect picker_frame = CGRectMake(0, [CommonTool GetScreenHeight]-c_picker_view_height, [CommonTool GetScreenWidth], c_picker_view_height);
    m_picker_view = [[AFPickerView alloc] initWithFrame:picker_frame backgroundImage:@"PickerBG" shadowImage:@"PickerShadow" glassImage:@"PickerGlass" title:@"no_use"];
    [m_picker_view setDelegate:self];
    [m_picker_view setDataSource:self];
    [self addSubview:m_picker_view];
    [m_picker_view showPicker];
    [m_picker_view reloadData];
}



// delegate
- (NSInteger) numberOfRowsInPickerView:(AFPickerView *)pickerView
{
    int rt = [Judgement GetCurrentPlayerNumber];
    return rt;
}

- (NSString*) pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row
{
    NSString* rt = [[Judgement GetCurrentJudgement] GetPlayerNameAtIndex:row];
    return rt;
}

- (void) pickerView:(AFPickerView *)pickerView PressOk:(int)_index
{
    NSLog(@"ok index = %d", _index);
    [[Judgement GetCurrentJudgement] RemovePlayerAtIndex:_index];
    [self RemoveSelf];
}

- (void) pickerView:(AFPickerView *)pickerView PressCancel:(id)_nil
{
    [self RemoveSelf];
}

- (void) RemoveSelf
{
    NSLog(@"removeself");
    [m_picker_view removeFromSuperview];
    [self removeFromSuperview];
}


@end
