//
//  Judgement.m
//  scoreBoard
//
//  Created by Sylar on 1/9/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//
////////////////////////////////////////////////////////////
#import "Judgement.h"
#import "Player.h"
////////////////////////////////////////////////////////////
static Judgement* instance = nil;
////////////////////////////////////////////////////////////
@implementation Judgement
- (id) initWithNobody
{
    NSArray* arr = [[NSArray alloc] init];
    id rt = [self initWithPlayersName:arr];
    return rt;
}

- (id) initWithPlayersName:(NSArray*)_players
{
    self = [super init];
    if (self)
    {
        self.p_players = [[NSMutableArray alloc] init];
        for (NSString* each_name in _players)
        {
            Player* each_player = [[Player alloc] initWithName:each_name];
            [self.p_players addObject:each_player];
        }
//        [self SetFakeData];
    }
    instance = self;
    return self;
}

+ (id) GetCurrentJudgement
{
    return instance;
}

+ (int) GetCurrentPlayerNumber
{
    int rt = 0;
    if (instance)
    {
        rt = [instance GetTotalPlayerNumbers];
    }
    return rt;
}

+ (int) GetTotalGameRounds
{
    int rt = 0;
    if (instance)
    {
        rt = [instance GetTotalGameRounds];
    }
    return rt;
}

- (BOOL) AddOnePlayerWithName:(NSString*)_name
{
    if (_name.length < 1)
        return NO;
    
    BOOL rt = [self CheckPlayerExist:_name];
    if (!rt)
    {
        Player* one_player = [[Player alloc] initWithName:_name];
        [self.p_players addObject:one_player];
        [one_player AddZerosCount:[self GetTotalGameRounds]];
    }
    return !rt;
}

- (void) RemovePlayerAtIndex:(int)_index
{
    Player* the_player = [self GetPlayerAtIndex:_index];
    if (the_player)
    {
        [self.p_players removeObject:the_player];
    }
}

- (void) RemovePlayerWithName:(NSString*)_name
{
    for (Player* each_player in self.p_players)
    {
        if ([each_player.p_name isEqualToString:_name])
        {
            [self.p_players removeObject:each_player];
            return;
        }
    }
}

- (NSString*) GetPlayerNameAtIndex:(int)_index
{
    NSString* rt = @"error";
    Player* the_player = [self GetPlayerAtIndex:_index];
    if (the_player)
    {
        rt = [the_player p_name];
    }
    return rt;
}

- (NSString*) GetPlayerTotalScoreAtIndex:(int)_index
{
    NSString* rt = @"-1";
    Player* the_player = [self GetPlayerAtIndex:_index];
    if (the_player)
    {
        int total_score = [the_player GetTotalScore];
        rt = [NSString stringWithFormat:@"%d", total_score];
    }
    return rt;
}

- (int) GetPlayAtIndex:(int)_indexPlayer ScoreIndex:(int)_indexScore
{
    int rt = 0;
    Player* the_player = [self GetPlayerAtIndex:_indexPlayer];
    if (the_player)
    {
        rt = [the_player GetScoreAtIndex:_indexScore];
    }
    return rt;
}

- (void) AddOneLineScore:(NSArray*)_scores
{
    int player_count = [self GetTotalPlayerNumbers];
    int scores_count = [_scores count];
    if (player_count <= scores_count)
    {
        for (int i=0; i<player_count; i++)
        {
            Player* the_player = [self GetPlayerAtIndex:i];
            [the_player AddOneScore:[_scores objectAtIndex:i]];
        }
    }
}

- (void) RemoveOneLineScoreAtIndex:(int)_index
{
    for (Player* each_player in self.p_players)
    {
        [each_player RemoveOneScoreAtIndex:_index];
    }
}

- (NSArray*) GetAllPlayersName
{
    NSMutableArray* rt = [[NSMutableArray alloc] init];
    int player_count = [self GetTotalPlayerNumbers];
    for (int i=0; i<player_count; i++)
    {
        NSString* each_name = [self GetPlayerNameAtIndex:i];
        [rt addObject:each_name];
    }
    return rt;
}

- (void) AgGame
{
    for (Player* each_player in self.p_players)
    {
        [each_player AgGame];
    }
}

// private
- (Player*) GetPlayerAtIndex:(int)_index
{
    Player* rt = nil;
    int total_players = self.p_players.count;
    if (_index < total_players)
    {
        rt = [self.p_players objectAtIndex:_index];
    }
    return rt;
}

- (int) GetTotalPlayerNumbers
{
    int rt = [self.p_players count];
    return rt;
}

- (int) GetTotalGameRounds
{
    int rt = 0;
    if ([self GetTotalPlayerNumbers] > 0)
    {
        rt = [[self.p_players objectAtIndex:0] GetTotalGameRounds];
    }
    return rt;
}

- (BOOL) CheckPlayerExist:(NSString*)_name
{
    NSArray* all_players = [self GetAllPlayersName];
    BOOL rt = [all_players containsObject:_name];
    return rt;
}


// test

- (void) SetFakeData
{
    [self AddOnePlayerWithName:@"f1"];
    [self AddOnePlayerWithName:@"f2"];
    [self AddOnePlayerWithName:@"fake3"];
}


@end
