//
//  ScoreBoardViewController.h
//  scoreBoard
//
//  Created by Sylar on 1/8/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
@class Judgement;
@class ScoreBoardCell;

@interface ScoreBoardViewController : BasicViewController

@property (nonatomic, strong) Judgement* p_judger;


- (void) cbFromMainSettingView:(id)_data Id:(id)_tag;

- (void) cbFromCell:(ScoreBoardCell*)_cell;



@end
