//
//  ScoreBoardLastCell.m
//  scoreBoard
//
//  Created by Sylar on 1/10/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//
//////////////////////////////////////////////////////
#import "ScoreBoardLastCell.h"
#import "Judgement.h"
#import "ScoreBoardHeading.h"
#import "CommonTool.h"
//////////////////////////////////////////////////////
@interface ScoreBoardLastCell()
{
    NSMutableArray* m_scores;
}
@end
//////////////////////////////////////////////////////
@implementation ScoreBoardLastCell
//////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_scores = nil;
        [self SetInitialValue];
    }
    return self;
}

- (void) SetInitialValue
{
    // number
    UILabel* label_total = [self AddLabelWithFrame:CGRectMake(0, 0, kLineNumberWidth, kCellHeight)];
    [label_total setBackgroundColor:[UIColor clearColor]];
    
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
    [rt setText:@"总"];
    [rt setTextAlignment:NSTextAlignmentCenter];
    [rt setTextColor:[UIColor redColor]];
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

- (void) SetWithDefaultData
{
    // scores
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
        NSString* total_score = [judge GetPlayerTotalScoreAtIndex:i];
        UILabel* the_label = [m_scores objectAtIndex:i];
        [the_label setText:total_score];
    }
}
@end
