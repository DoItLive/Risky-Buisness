//
//  popupView.m
//  Risky Business
//
//  Created by Christian Weigandt on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "popupView.h"

@implementation popupView

@synthesize yesButton, noButton, textLabel, yesFunction, noFunction, bg;

- (id)initWithText:(NSString*)text andDelegate:(id)delegate andYesFunc:(SEL)yesFunc andNoFunc:(SEL)noFunc{
    
    yesFunction = yesFunc;
    noFunction = noFunc;
    target = delegate;
    
    self = [super initWithFrame:CGRectMake(0,0,320,480)];
    self.backgroundColor = [UIColor clearColor];

    bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popUp.png"]];
    bg.frame = CGRectMake(160,230,9,6);
    [self addSubview:bg];
    
    yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yesButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    yesButton.frame = CGRectMake(162, 235, 2, 1);
    [yesButton addTarget:self action:@selector(yesPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:yesButton];
    
    noButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    noButton.frame = CGRectMake(167, 235, 2, 1);
    [noButton addTarget:self action:@selector(noPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:noButton];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(161, 231, 2, 1)];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setLineBreakMode:UILineBreakModeWordWrap];
    [textLabel setNumberOfLines:3];
    [textLabel setTextAlignment:UITextAlignmentCenter];
    textLabel.text = text;
    [self addSubview:textLabel];
    
    //Animation
    [UIView beginAnimations: @"popUp" context: nil];
    [UIView setAnimationDelegate: self];   
    [UIView setAnimationDuration: 0.2];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];  
    bg.frame = CGRectMake(10, 130,300,200);
    yesButton.frame = CGRectMake(40, 270, 110, 50);
    noButton.frame = CGRectMake(150, 270, 110, 50);
    textLabel.frame = CGRectMake(25, 150, 250, 120);
    [UIView commitAnimations];
        
    return self;
    
}

-(IBAction)yesPushed:(id)sender{
    
    [self disappear];
    if([target respondsToSelector:yesFunction])
        [target performSelector:yesFunction];
    else
        NSLog(@"Bad coding somewhere");
    
}

-(IBAction)noPushed:(id)sender{

    [self disappear];
    if([target respondsToSelector:noFunction])
        [target performSelector:noFunction];
    else
        NSLog(@"Bad coding somewhere");
    
}

-(void)disappear{
    
    [UIView beginAnimations: @"popDown" context: nil];
    [UIView setAnimationDelegate: self];   
    [UIView setAnimationDuration: 0.16];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];  
    bg.frame = CGRectMake(160,230,9,6);
    yesButton.frame = CGRectMake(162, 235, 2, 1);
    noButton.frame = CGRectMake(167, 235, 2, 1);
    textLabel.frame = CGRectMake(161,231, 2, 1);
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(SEL)aSelector{
    
    if([animationID isEqualToString:@"popDown"]){
        [self removeFromSuperview];
        //[self release];
    }
    
}

-(void)dealloc{
    
    [bg release];
    [textLabel release];
    [yesButton release];
    [noButton release];
    [super dealloc];
}
     
     
@end
