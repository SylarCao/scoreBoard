//
//  JHTickerView.h
//  Ticker
//
//  Created by Jeff Hodnett on 03/05/2011.
//  Copyright 2011 Applausible. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  RTLabel;

typedef enum
{
    JHTickerDirectionLTR,
    JHTickerDirectionRTL,
} JHTickerDirection;

@interface JHTickerView : UIView {
    
	// The ticker strings
	NSArray *tickerStrings;
	
	// The current index for the string
	int currentIndex;
	
	// The ticker speed
	float tickerSpeed;
	
	// Should the ticker loop
	BOOL loops;
	
	// The current state of the ticker
	BOOL running;
	
	// The ticker label
	RTLabel *tickerLabel;
	
	// The ticker font
	UIFont *tickerFont;
}

@property(nonatomic, retain) NSArray *tickerStrings;
@property(nonatomic) float tickerSpeed;
@property(nonatomic) BOOL loops;
@property(nonatomic) JHTickerDirection direction;

- (id)initWithFrame:(CGRect)frame Font:(UIFont*)_labelFont;

-(void)start;
//-(void)stop;
-(void)pause;
-(void)resume;

+ (NSString *)removeHTML:(NSString *)html;

@end
