//
//  Player.m
//  scoreBoard
//
//  Created by Sylar on 1/9/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//
//////////////////////////////////////////////////////
#import "Player.h"
//////////////////////////////////////////////////////
@implementation Player

- (id) initWithName:(NSString*)_name
{
    self = [super init];
    if (self)
    {
        self.p_name = _name;
        self.p_score = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) AgGame
{
    [self.p_score removeAllObjects];
}

- (void) AddOneScore:(NSString*)_score
{
    [self.p_score addObject:_score];
}

- (void) RemoveOneScoreAtIndex:(int)_index
{
    if (_index < self.p_score.count)
    {
        [self.p_score removeObjectAtIndex:_index];
    }
}

- (int) GetScoreAtIndex:(int)_index
{
    int rt = 0;
    if (_index < self.p_score.count)
    {
        rt = [[self.p_score objectAtIndex:_index] intValue];
    }
    return rt;
}

- (int) GetTotalScore
{
    int rt = 0;
    for (NSString* each_score in self.p_score)
    {
        int score_intValue = [each_score intValue];
        rt = rt + score_intValue;
    }
    return rt;
}

- (int) GetTotalGameRounds
{
    int rt = self.p_score.count;
    return rt;
}

- (void) AddZerosCount:(int)_count
{
    [self AgGame];
    for (int i=0; i<_count; i++)
    {
        [self.p_score addObject:@"0"];
    }
}

//  test
- (void) AddFakeScore
{
    int fscore = [self StaticNumber];
    [self AddOneScore:[NSString stringWithFormat:@"%d", fscore]];
}

- (int) StaticNumber
{
    static int rt = 0;
    rt++;
    return rt;
}


@end
