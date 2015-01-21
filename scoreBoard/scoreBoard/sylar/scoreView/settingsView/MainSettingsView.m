//
//  MainSettingsView.m
//  scoreBoard
//
//  Created by Sylar on 1/9/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//
//////////////////////////////////////////////////////////////////
#import "MainSettingsView.h"
#import "CommonTool.h"
#import "ScoreBoardViewController.h"
#import "ScoreBoardHeading.h"
#import "Judgement.h"
#import "AddPlayerView.h"
#import "DeletePlayerView.h"
//////////////////////////////////////////////////////////////////
const float MainSettingsEdge = 10.f;
//////////////////////////////////////////////////////////////////
@implementation MainSettingsView

+ (CGRect) GetBigFrame
{
    float edge = MainSettingsEdge;
    CGRect rt = CGRectMake(edge, edge, [CommonTool GetScreenWidth]-2*edge, [CommonTool GetScreenHeight]-2*edge);
    return rt;
}

- (id)initWithDelegate:(id)_delegate
{
    self = [super init];
    if (self) {
        self.p_delegate = _delegate;
        [self setFrame:[MainSettingsView GetBigFrame]];
        [self SetSettings];
    }
    return self;
}

- (void) SetSettings
{
    [self setBackgroundColor:[UIColor darkGrayColor]];
    
    // continue
    UIButton* btn_continue = [self AddThisButtonWithTitle:@"继续"];
    [btn_continue addTarget:self action:@selector(BtnContinue) forControlEvents:UIControlEventTouchUpInside];
    
    // add one player
    UIButton* btn_add_player = [self AddThisButtonWithTitle:@"添加一个玩家"];
    [btn_add_player addTarget:self action:@selector(BtnAddPlayer:) forControlEvents:UIControlEventTouchUpInside];
    
    // add one line score
    UIButton* btn_add_score = [self AddThisButtonWithTitle:@"添加分数"];
    [btn_add_score addTarget:self action:@selector(BtnAddScore) forControlEvents:UIControlEventTouchUpInside];
    
    // remove one player
    UIButton* btn_remove_player = [self AddThisButtonWithTitle:@"删除玩家"];
    [btn_remove_player addTarget:self action:@selector(BtnRemovePlayer:) forControlEvents:UIControlEventTouchUpInside];
    
    // ag game
    UIButton* btn_ag = [self AddThisButtonWithTitle:@"重新开始"];
    [btn_ag addTarget:self action:@selector(BtnAgGame) forControlEvents:UIControlEventTouchUpInside];
    
    [CommonTool AutoLayoutView:self SubViews:[NSArray arrayWithObjects:btn_continue, btn_add_player, btn_add_score, btn_remove_player, btn_ag, nil] UpEdge:50 BottomEdge:100 SubviewWidth:150 SubviewHeight:50];
    
    // back button
    UIButton* btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    float size = 50;
    [btn_back setFrame:CGRectMake(self.frame.size.width-size, 0, size, size)];
    [btn_back setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [btn_back.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [btn_back addTarget:self action:@selector(BtnClose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_back];
}

- (UIButton*) AddThisButtonWithTitle:(NSString*)_title
{
    UIButton* rt = [UIButton buttonWithType:UIButtonTypeCustom];
    [rt setBackgroundImage:[CommonTool GetGreenImage] forState:UIControlStateNormal];
    [rt setTitle:_title forState:UIControlStateNormal];
    [self addSubview:rt];
    return rt;
}

- (void) BtnClose
{
    if ([self.p_delegate respondsToSelector:@selector(cbFromMainSettingView:Id:)])
    {
        NSString* ss = [NSString stringWithFormat:@"%d", kSettingsClose];
        [self.p_delegate performSelector:@selector(cbFromMainSettingView:Id:) withObject:nil withObject:ss];
    }
}

- (void) BtnContinue
{
    [self BtnClose];
}

- (void) BtnAddPlayer:(id) sender
{
    AddPlayerView* add_player = [[AddPlayerView alloc] init];
    [[[UIApplication sharedApplication] keyWindow] addSubview:add_player];
}

- (void) BtnRemovePlayer:(UIButton*)sender
{
    NSLog(@"remove player");
    UIView* del = [[DeletePlayerView alloc] init];
    [[[UIApplication sharedApplication] keyWindow] addSubview:del];
}

- (void) BtnAddScore
{
    NSLog(@"add score");
    NSMutableArray* scores = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++)
    {
        int a = arc4random()%20-10;
        NSString* s = [NSString stringWithFormat:@"%d", a];
        [scores addObject:s];
    }
    [[Judgement GetCurrentJudgement] AddOneLineScore:scores];
}

- (void) BtnAgGame
{
    [[Judgement GetCurrentJudgement] AgGame];
    if ([self.p_delegate respondsToSelector:@selector(cbFromMainSettingView:Id:)])
    {
        NSString* ss = [NSString stringWithFormat:@"%d", kRestart];
        [self.p_delegate performSelector:@selector(cbFromMainSettingView:Id:) withObject:nil withObject:ss];
    }
}

// remove player





@end
