//
//  WelcomeViewController.m
//  scoreBoard
//
//  Created by Sylar on 1/8/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////
#import "WelcomeViewController.h"
#import "CommonTool.h"
#import "ScoreBoardViewController.h"
#import "JHTickerView.h"
/////////////////////////////////////////////////////////////////////////////////////
@interface WelcomeViewController ()
<UITextFieldDelegate>
{
    IBOutlet JHTickerView* m_ib_jh_view;
    IBOutlet UITextField*  m_ib_text_field;
    IBOutlet UIButton*     m_ib_btn_img;
    IBOutlet UIButton*     m_ib_btn_start;
    int                    m_imgbtn_touch_count;
}
@end
/////////////////////////////////////////////////////////////////////////////////////
@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self WelcomePage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    m_imgbtn_touch_count = 0;
    [m_ib_text_field setText:@""];
    [self SetStartButtonDisable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) WelcomePage
{
    // jhticker
    NSString* str_jh_ticket = @"<font face='HelveticaNeue-CondensedBold' size=30 color='#FFFFFF'>输入</font><font face='HelveticaNeue-CondensedBold' size=30 color='#FF0000'>曹继冶是大天才</font><font face='HelveticaNeue-CondensedBold' size=30 color='#FFFFFF'>才能开始</font>";
    [m_ib_jh_view setDirection:JHTickerDirectionLTR];
    [m_ib_jh_view setBackgroundColor:[UIColor clearColor]];
    [m_ib_jh_view setTickerSpeed:55];
    [m_ib_jh_view setTickerStrings:[NSArray arrayWithObjects:str_jh_ticket, str_jh_ticket, nil]];
    [m_ib_jh_view start];
    
    // start button
    [m_ib_btn_start setBackgroundImage:[CommonTool GetGreenImage] forState:UIControlStateNormal];
    [m_ib_btn_start setTitle:@"开始" forState:UIControlStateNormal];
    [m_ib_btn_start.titleLabel setFont:[UIFont boldSystemFontOfSize:26]];
    [m_ib_btn_start.layer setShadowOffset:CGSizeMake(1, 1)];
    [m_ib_btn_start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [m_ib_btn_start setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [m_ib_btn_start setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_ib_btn_start setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [m_ib_btn_start setEnabled:NO];

}

- (IBAction)IBStart:(id)sender
{
    ScoreBoardViewController* score = [[ScoreBoardViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:score animated:YES];
}

- (IBAction)IBBtnImgTouch:(id)sender
{
    m_imgbtn_touch_count++;
    [self HideKeyBoard];
    if (m_imgbtn_touch_count>13)
    {
        [self SetStartButtonEnable];
    }
}

- (IBAction)IBViewTap:(id)sender
{
    [self HideKeyBoard];
}

- (void) SetStartButtonEnable
{
    [m_ib_btn_start setEnabled:YES];
}

- (void) SetStartButtonDisable
{
    [m_ib_btn_start setEnabled:NO];
}

// delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self SetStartButtonDisable];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self SetStartButtonDisable];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString* ss = textField.text;
    if ([ss isEqualToString:@"曹继冶是大天才"])
    {
        [self SetStartButtonEnable];
    }
}

- (void) HideKeyBoard
{
    [m_ib_text_field resignFirstResponder];
}

@end
