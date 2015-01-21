//
//  MainSettingsView.h
//  scoreBoard
//
//  Created by Sylar on 1/9/14.
//  Copyright (c) 2014 Sylar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainSettingsView : UIView

@property (nonatomic, assign) id p_delegate;

+ (CGRect) GetBigFrame;


- (id)initWithDelegate:(id)_delegate;

@end
