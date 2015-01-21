//
//  Player.h
//  scoreBoard
//
//  Created by Sylar on 1/9/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic, strong) NSString* p_name;
@property (nonatomic, strong) NSMutableArray* p_score;


- (id) initWithName:(NSString*)_name;

- (void) AgGame;

- (void) AddOneScore:(NSString*)_score;

- (void) RemoveOneScoreAtIndex:(int)_index;

- (int) GetScoreAtIndex:(int)_index;

- (int) GetTotalScore;

- (int) GetTotalGameRounds;

- (void) AddZerosCount:(int)_count;



@end
