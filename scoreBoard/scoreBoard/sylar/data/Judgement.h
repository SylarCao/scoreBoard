//
//  Judgement.h
//  scoreBoard
//
//  Created by Sylar on 1/9/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Judgement : NSObject

@property (nonatomic, strong) NSMutableArray* p_players;
@property (nonatomic) int p_totalNumberOfGames;

+ (id) GetCurrentJudgement;
+ (int) GetCurrentPlayerNumber;
+ (int) GetTotalGameRounds;

- (id) initWithNobody;

- (id) initWithPlayersName:(NSArray*)_players;

- (BOOL) AddOnePlayerWithName:(NSString*)_name;

- (void) RemovePlayerAtIndex:(int)_index;

- (void) RemovePlayerWithName:(NSString*)_name;

- (NSString*) GetPlayerNameAtIndex:(int)_index;

- (NSString*) GetPlayerTotalScoreAtIndex:(int)_index;

- (int) GetPlayAtIndex:(int)_indexPlayer ScoreIndex:(int)_indexScore;

- (void) AddOneLineScore:(NSArray*)_scores;

- (void) RemoveOneLineScoreAtIndex:(int)_index;

- (NSArray*) GetAllPlayersName;

- (void) AgGame;

@end
