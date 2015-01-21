//
//  ScoreBoardViewController.m
//  scoreBoard
//
//  Created by Sylar on 1/8/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////
#import "ScoreBoardViewController.h"
#import "Judgement.h"
#import "CommonTool.h"
#import "MainSettingsView.h"
#import "UIView+Genie.h"
#import "ScoreBoardCell.h"
#import "ScoreBoardLastCell.h"
#import "AddScoreView.h"
/////////////////////////////////////////////////////////////////////////////////////
#import "ScoreBoardHeading.h"
const float c_mainsettingAnimationTime = 0.3f;
NSString* c_score_board_cell_id = @"scoreBoardCellIdentifier";
NSString* c_score_board_last_cell_id = @"scoreBoardLastCellIdentifier";
# define kUpviewNameviewTag 45  // 人的名字的view的tag
/////////////////////////////////////////////////////////////////////////////////////
@interface ScoreBoardViewController ()
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
UIActionSheetDelegate>
{
    CGRect            m_settings_small_frame;
    UIView*           m_up_view;
    MainSettingsView* m_settings_view;
    AddScoreView*     m_addscore_view;
    UIButton*         m_settings_button;
    UICollectionView* m_collection_view;
    NSIndexPath*      m_to_delete_indexpath;
}
@end
/////////////////////////////////////////////////////////////////////////////////////
@implementation ScoreBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_settings_small_frame = CGRectMake(5, 5, 5, 5);
        m_up_view = nil;
        m_settings_button = nil;
        m_addscore_view = nil;
        m_settings_view = nil;
        m_collection_view = nil;
        self.p_judger = [[Judgement alloc] initWithNobody];
        [self AddCollectionView];
        [self AddUpView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) AddUpView
{
    m_up_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [CommonTool GetScreenWidth], kUpViewHeight)];
    [self.view addSubview:m_up_view];
    [m_up_view setUserInteractionEnabled:YES];
    [m_up_view setBackgroundColor:[UIColor whiteColor]];
    
    // settings view
    m_settings_view = [[MainSettingsView alloc] initWithDelegate:self];
    [self.view addSubview:m_settings_view];
    [m_settings_view setHidden:YES];
    [self MainSettingsHide];
    
    // add score view
    m_addscore_view = [[AddScoreView alloc] initWithDelegate:self];
    [self.view addSubview:m_addscore_view];
    [m_addscore_view setHidden:YES];
    [self AddScoreViewHide];
    
    
    // setting button
    m_settings_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_settings_button setFrame:CGRectMake(0, 0, kLineNumberWidth, kUpViewHeight)];
    [self.view addSubview:m_settings_button];
    [m_settings_button addTarget:self action:@selector(BtnSetting) forControlEvents:UIControlEventTouchUpInside];
    [m_settings_button setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    
    UILongPressGestureRecognizer* longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(BtnSettingLong:)];
    longpress.minimumPressDuration = 1.0;
    [m_settings_button addGestureRecognizer:longpress];
    
    // player names
    [self RefreshPlayerNames];
}

- (void) RefreshPlayerNames
{
    while ([m_up_view viewWithTag:kUpviewNameviewTag])
    {
        UIView* some_view = [m_up_view viewWithTag:kUpviewNameviewTag];
        [some_view removeFromSuperview];
    }
    int total_players = [Judgement GetCurrentPlayerNumber];
    NSMutableArray* arr_views = [[NSMutableArray alloc] init];
    for (int i=0; i<total_players; i++)
    {
        NSString* ss = [self.p_judger GetPlayerNameAtIndex:i];
        UILabel* name = [[UILabel alloc] init];
        [name setBackgroundColor:[UIColor clearColor]];
        [name setTextAlignment:NSTextAlignmentCenter];
        [name setText:ss];
        [name setTag:kUpviewNameviewTag];
        [m_up_view addSubview:name];
        [arr_views addObject:name];
    }
    [CommonTool AutoLayoutView:m_up_view Subviews:arr_views LeftEdge:kLineNumberWidth];
}

- (void) BtnSetting
{
    int player_count = [Judgement GetCurrentPlayerNumber];
    if (player_count == 0)
    {
        [self MainSettingsShow];
    }
    else
    {
        [self AddScoreViewShow];
    }
}

- (void) BtnSettingLong:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self MainSettingsShow];
    }
}

- (void) MainSettingsShow
{
    [m_settings_view setHidden:NO];
    [m_settings_view genieOutTransitionWithDuration:c_mainsettingAnimationTime startRect:m_settings_small_frame startEdge:BCRectEdgeRight completion:^{
        [m_settings_button setEnabled:NO];
    }];
}

- (void) MainSettingsHide
{
    [m_settings_view genieInTransitionWithDuration:c_mainsettingAnimationTime destinationRect:m_settings_small_frame destinationEdge:BCRectEdgeRight completion:^{
        [m_settings_button setEnabled:YES];
        [m_settings_view setHidden:YES];
    }];
}

- (void) AddScoreViewShow
{
    m_addscore_view = [[AddScoreView alloc] initWithDelegate:self];
    [self.view addSubview:m_addscore_view];
    [m_addscore_view setHidden:NO];
    [m_addscore_view genieOutTransitionWithDuration:c_mainsettingAnimationTime startRect:m_settings_small_frame startEdge:BCRectEdgeRight completion:^{
        [m_settings_button setEnabled:NO];
    }];
}

- (void) AddScoreViewHide
{
    [m_addscore_view genieInTransitionWithDuration:c_mainsettingAnimationTime destinationRect:m_settings_small_frame destinationEdge:BCRectEdgeRight completion:^{
        [m_settings_button setEnabled:YES];
        [m_addscore_view setHidden:YES];
    }];
}

- (void) AddCollectionView
{
    UICollectionViewFlowLayout* flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = CGSizeMake([CommonTool GetScreenWidth], kCellHeight);
    flowlayout.minimumLineSpacing = 1;
    
    m_collection_view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kUpViewHeight, [CommonTool GetScreenWidth], [CommonTool GetScreenHeight]-kUpViewHeight) collectionViewLayout:flowlayout];
    m_collection_view.dataSource = self;
    m_collection_view.delegate = self;
    [m_collection_view setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:m_collection_view];
    [m_collection_view registerClass:[ScoreBoardCell class] forCellWithReuseIdentifier:c_score_board_cell_id];
    [m_collection_view registerClass:[ScoreBoardLastCell class] forCellWithReuseIdentifier:c_score_board_last_cell_id];
}

// call back
- (void) cbFromMainSettingView:(id)_data Id:(id)_tag
{
    int id_tag = [_tag intValue];
    if (id_tag == kSettingsClose)
    {
        [self RefreshPlayerNames];
        [m_collection_view reloadData];
        [self MainSettingsHide];
    }
    else if (id_tag == kAddScoreViewClose)
    {
        [self RefreshPlayerNames];
        [m_collection_view reloadData];
        [self AddScoreViewHide];
    }
    else if (id_tag == kRestart)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) cbFromCell:(ScoreBoardCell*)_cell
{
    // show uiaction sheet
    m_to_delete_indexpath = [m_collection_view indexPathForCell:_cell];
    NSString* title = [NSString stringWithFormat:@"你想要做什么----%d", m_to_delete_indexpath.row +1];
    UIActionSheet* action_sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [action_sheet showInView:self.view];
}

// delegate
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    int rt = [Judgement GetTotalGameRounds];
    return rt+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionViewCell* cell = nil;
    if (indexPath.row >= [Judgement GetTotalGameRounds])
    {
        cell = [cv dequeueReusableCellWithReuseIdentifier:c_score_board_last_cell_id forIndexPath:indexPath];
        [(ScoreBoardLastCell*)cell SetWithDefaultData];
    }
    else
    {
        cell = [cv dequeueReusableCellWithReuseIdentifier:c_score_board_cell_id forIndexPath:indexPath];
        [(ScoreBoardCell*)cell SetWithDataAtIndex:indexPath.row Delegate:self];
    }
    return cell;
}

// uiaction sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // 删除 这个 cell
        [[Judgement GetCurrentJudgement] RemoveOneLineScoreAtIndex:m_to_delete_indexpath.row];
        [m_collection_view reloadData];
    }
}


// test
- (void) test:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
        NSLog(@"test");
//        [self MainSettingsShow];
}

@end
