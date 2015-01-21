//
//  ViewController.m
//  scoreBoard
//
//  Created by Sylar on 1/8/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//

#import "ViewController.h"
#import "CommonTool.h"
#import "ScoreBoardViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self WelomePage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) WelomePage
{
    // add image
    UIImageView* imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome"]];
    [self.view addSubview:imv];
    float wide = [CommonTool GetScreenWidth];
//    float height = [CommonTool GetScreenHeight];
    CGSize size = [imv frame].size;
    [imv setFrame:CGRectMake(wide/2-size.width/2, 100, size.width, size.height)];
    
    // add start button
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn setFrame:CGRectMake(wide/4, 300, wide/2, 60)];
}

- (void) Start
{
    ScoreBoardViewController* score = [[ScoreBoardViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:score animated:YES];
}




@end
