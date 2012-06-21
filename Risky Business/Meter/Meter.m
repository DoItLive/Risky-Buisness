//
//  Meter.m
//  Tester
//
//  Created by Christian Weigandt on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Meter.h"

@implementation Meter

@synthesize thumb, upperImage, lowerImage, userArmyLabel, venueArmyLabel, upperIcon, lowerIcon;

- (id)init
{
    
    self = [super initWithFrame:CGRectMake(200, 45, 100, 280)];
    
    thumb = [UIButton buttonWithType:UIButtonTypeCustom];
    [thumb setFrame:CGRectMake(0, 265, 15, 15)];
    [thumb setBackgroundImage:[UIImage imageNamed:@"thumb.png"] forState:UIControlStateNormal];
    [thumb setAdjustsImageWhenHighlighted:NO];
    [thumb addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self setMaxValue:250 andValue:0];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(-50, 80, 240, 80)];
    [label setFont:[UIFont fontWithName:@"Helvetica" size:80]];
    [label setText:@"ARMY"];
    label.transform = CGAffineTransformMakeRotation(M_PI * 1.5);
    [label setAlpha:0.4];
    [label setBackgroundColor:[UIColor clearColor]];
    
    lowerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maxBar.png"]];
    [lowerImage setFrame:CGRectMake(20, thumb.center.y, 80, 0)];
    [lowerImage setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [lowerImage setAlpha:0.92];
    
    upperImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minBar.png"]];
    [upperImage setFrame:CGRectMake(20, 0, 80, 280)];
    [upperImage setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [upperImage setAlpha:0.92];
    
    upperIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [upperIcon setBackgroundImage:[UIImage imageNamed:@"Bust.png"] forState:UIControlStateNormal];
    [upperIcon setFrame:CGRectMake(0, 0, 15, 15)];
    [upperIcon addTarget:self action:@selector(upPushed) forControlEvents:UIControlEventTouchUpInside];
    
    lowerIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [lowerIcon setBackgroundImage:[UIImage imageNamed:@"Bust.png"] forState:UIControlStateNormal];
    [lowerIcon setFrame:CGRectMake(0, 265, 15, 15)];
    [lowerIcon addTarget:self action:@selector(downPushed) forControlEvents:UIControlEventTouchUpInside];
    
    venueArmyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, thumb.center.y, 80, 18)];
    [venueArmyLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [venueArmyLabel setTextAlignment:UITextAlignmentCenter];
    [venueArmyLabel setBackgroundColor:[UIColor blackColor]];
    [venueArmyLabel setTextColor:[UIColor whiteColor]];
    
    userArmyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, thumb.center.y-13, 80, 18)];
    [userArmyLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [userArmyLabel setTextAlignment:UITextAlignmentCenter];
    [userArmyLabel setBackgroundColor:[UIColor blackColor]];
    [userArmyLabel setTextColor:[UIColor whiteColor]];
                   
    [self addSubview:label];
    [self addSubview:thumb];
    [self addSubview:lowerImage];
    [self addSubview:upperImage];
    [self addSubview:venueArmyLabel];
    [self addSubview:userArmyLabel];
    [self addSubview:upperIcon];
    [self addSubview:lowerIcon];
    
    //self.backgroundColor = [UIColor blueColor];
    return self;
}

-(void)upPushed{
    
    [self setMaxValue:maxValue andValue:(value+1)];
    
}

-(void)downPushed{
    
    [self setMaxValue:maxValue andValue:(value-1)];
    
}

-(void)setMaxValue:(NSInteger)newMax andValue:(NSInteger)newValue{
    
    maxValue = newMax;
    value = newValue;
    [venueArmyLabel setText:[NSString stringWithFormat:@"%d",value]];
    [userArmyLabel setText:[NSString stringWithFormat:@"%d",maxValue - value]];
    [thumb setFrame:CGRectMake(0, 265-265*(float)value/maxValue, 15, 15)];
    [lowerImage setFrame:CGRectMake(20, thumb.center.y, 80, 280 - thumb.frame.origin.y-thumb.frame.size.height)];
    [upperImage setFrame:CGRectMake(20, 0, 80, thumb.center.y)];
    [venueArmyLabel setFrame:CGRectMake(20, thumb.center.y, 80, 12)];
    [userArmyLabel setFrame:CGRectMake(20, thumb.center.y-13, 80, 12)];


}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
	UITouch *touch = [[event touchesForView:button] anyObject];
    
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_y = location.y - previousLocation.y;
    
    if(button.frame.origin.y + delta_y <= 0)delta_y = 0;
    if(button.frame.origin.y + button.frame.size.height + delta_y >= 280)delta_y = 0;

    value = maxValue*((float)(265 - button.frame.origin.y))/265;
    
	button.center = CGPointMake(button.center.x, button.center.y + delta_y);
    [lowerImage setFrame:CGRectMake(20, button.center.y, 80, 280 - button.frame.origin.y-button.frame.size.height)];
    [upperImage setFrame:CGRectMake(20, 0, 80, button.center.y)];
    [venueArmyLabel setText:[NSString stringWithFormat:@"%d",value]];
    [userArmyLabel setText:[NSString stringWithFormat:@"%d",maxValue - value]];
    [venueArmyLabel setFrame:CGRectMake(20, thumb.center.y, 80, 12)];
    [userArmyLabel setFrame:CGRectMake(20, thumb.center.y-13, 80, 12)];
    
}


@end
