//
//  ScoreBoardCell.m
//  scoreBoard
//
//  Created by Sylar on 1/9/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//
/////////////////////////////////////////////////////////////////////
#import "ScoreBoardCell.h"
#import "ScoreBoardHeading.h"
#import "Judgement.h"
#import "CommonTool.h"
#import "ScoreBoardViewController.h"
/////////////////////////////////////////////////////////////////////
@interface ScoreBoardCell()
{
    UILabel*        m_label_number;
    NSMutableArray* m_scores;
    __weak id              m_parent_view_delegate;
}
@end
/////////////////////////////////////////////////////////////////////
@implementation ScoreBoardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_label_number = nil;
        m_scores = nil;
        m_parent_view_delegate = nil;
        [self SetInitialValue];
    }
    return self;
}

- (void) SetInitialValue
{
    // gesture
//    UILongPressGestureRecognizer* longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(GuesterLongPress:)];
//    longpress.minimumPressDuration = 2;
//    [self addGestureRecognizer:longpress];
    
    UITapGestureRecognizer* triple_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GuestureTripleTap:)];
    [triple_tap setNumberOfTapsRequired:3];
    [self addGestureRecognizer:triple_tap];
    
    // number
    m_label_number = [self AddLabelWithFrame:CGRectMake(0, 0, kLineNumberWidth, kCellHeight)];
    [m_label_number setBackgroundColor:[UIColor clearColor]];
    
    // scores
    m_scores = [[NSMutableArray alloc] init];
    int player_count = [Judgement GetCurrentPlayerNumber];
    for (int i=0; i<player_count; i++)
    {
        UILabel* each_score = [self AddLabelWithFrame:CGRectZero];
        [each_score setBackgroundColor:[self GetColor:i]];
        [m_scores addObject:each_score];
    }
    
    [CommonTool AutoLayoutView:self Subviews:m_scores LeftEdge:kLineNumberWidth];
}

- (UILabel*) AddLabelWithFrame:(CGRect)_frame
{
    UILabel* rt = [[UILabel alloc] init];
    [rt setFrame:_frame];
    [rt setText:@"aa"];
    [rt setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:rt];
    return rt;
}

- (UIColor*) GetColor:(int)_i
{
    UIColor* rt = kGreenColor2;
    if (_i%2 == 0)
    {
        rt = kGreenColor1;
    }
    return rt;
}

- (void) SetWithDataAtIndex:(int)_index Delegate:(id)_del
{
    // delegate
    m_parent_view_delegate = _del;
    
    // scores
    int total_score = 0;
    Judgement* judge = [Judgement GetCurrentJudgement];
    int player_count = [Judgement GetCurrentPlayerNumber];
    int m_score_count = m_scores.count;
    if (m_score_count < player_count)
    {
        for (int i=m_score_count; i<player_count; i++)
        {
            UILabel* each_score = [self AddLabelWithFrame:CGRectZero];
            [each_score setBackgroundColor:[self GetColor:i]];
            [m_scores addObject:each_score];
        }
    }
    else if (m_score_count > player_count)
    {
        for (int i=player_count; i<m_score_count; i++)
        {
            UILabel* the_label = [m_scores objectAtIndex:i];
            [the_label setFrame:CGRectZero];
        }
    }
    [CommonTool AutoLayoutView:self Subviews:[m_scores objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, player_count)]] LeftEdge:kLineNumberWidth];
    for (int i=0; i<player_count; i++)
    {
        int the_score = [judge GetPlayAtIndex:i ScoreIndex:_index];
        total_score += the_score;
        UILabel* the_label = [m_scores objectAtIndex:i];
        [the_label setText:[NSString stringWithFormat:@"%d", the_score]];
    }
    
    // line number
    [m_label_number setText:[NSString stringWithFormat:@"%d", _index+1]];
    if (total_score)
    {
        [m_label_number setTextColor:[UIColor redColor]];
    }
    else
    {
        [m_label_number setTextColor:[UIColor blackColor]];
    }
}

- (void) GuestureTripleTap:(UILongPressGestureRecognizer*)sender
{
    if ([m_parent_view_delegate respondsToSelector:@selector(cbFromCell:)])
    {
        [m_parent_view_delegate performSelector:@selector(cbFromCell:) withObject:self];
    }
}




@end
