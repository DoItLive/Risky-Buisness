//
//  preBattleView.m
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define LOST_SOLDIERS 4

#import "preBattleView.h"

@implementation preBattleView

@synthesize opponent, enemyArmySizeLabel, enemyUserNameLabel, localArmySizeLabel, localUserNameLabel, venue, venueLabel, user, fightButton, slider, armyLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            }
    return self;
}

//Sets up the view
-(id)initWithPlayer:(Player*)u{
    
    user = u;
    NSLog(@"%@",user);

    localUserNameLabel.text = user.name;
    localArmySizeLabel.text = [[NSString alloc] initWithFormat:@"%d Soldiers",[user.armySize intValue]];
    
    armyLabel.text = [[NSString alloc] initWithFormat:@"%d",[user.armySize intValue]/2];
    
    return self;
}

-(IBAction)sliderMoved:(id)sender{
    
    NSInteger ans = [user.armySize intValue]*slider.value;
    if (ans < LOST_SOLDIERS + 1)
        ans = LOST_SOLDIERS + 1;
    armyLabel.text = [NSString stringWithFormat:@"%d",ans];
}

//Called to initialize opponent variables and token
-(void) setOpponent:(NSString *)opp andVenue:(Venue *)v{
    
    venue = v;
    opponent = [[NSString alloc] initWithString:[opp stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
    enemyUserNameLabel.text = opponent;
    enemyArmySizeLabel.text = [NSString stringWithFormat:@"%d Soldiers",[venue.armySize integerValue]];
    
    venueLabel.text = [[NSString alloc] initWithFormat:@"Battle for %@",venue.name];
    
    popupView* firstUp;
    NSString* firstText = [[NSString alloc] initWithFormat:@"Do you want to fight?"];
    firstUp = [[popupView alloc] initWithText:firstText andDelegate:self andYesFunc:@selector(firstPopUpYes) andNoFunc:@selector(firstPopUpNo)];
    [self addSubview:firstUp];
    
    [fightButton setHidden:YES];
    [venueLabel setHidden:YES];
    [slider setHidden:YES];
    [armyLabel setHidden:YES];
    
}

-(void)firstPopUpYes{
    
    [fightButton setHidden:NO];
    [venueLabel setHidden:NO];
    [slider setHidden:NO];
    [armyLabel setHidden:NO];
    
}

-(void)firstPopUpNo{
    
    popupView* secondUp;
    NSString* text;
    if( LOST_SOLDIERS != 1)
        text = [[NSString alloc] initWithFormat:@"Are you sure? You will forfeit %d soldiers.",LOST_SOLDIERS];
    else
        text = [[NSString alloc] initWithFormat:@"Are you sure? You will forfeit %d soldier.",LOST_SOLDIERS];
    secondUp = [[popupView alloc] initWithText:text andDelegate:self andYesFunc:@selector(secondPopUpYes) andNoFunc:@selector(secondPopUpNo)];
    [self addSubview:secondUp];
    
}

-(void)secondPopUpYes{
    
    user.armySize = [NSNumber numberWithInt:[user.armySize intValue] - LOST_SOLDIERS];
    NSString *postString = [[NSString alloc] initWithFormat:@"%@&%@",user,venue];
    [[Connection alloc] initWithSelector:@selector(afterBattle:) 
                                toTarget:self 
                                 withURL:@"http://linus.highpoint.edu/~cweigandt/riskyBusiness/postBattle.php" 
                              withString:postString];
    
    NSNumber *newMode = [[NSNumber alloc] initWithInt:0];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(void)secondPopUpNo{
    
    popupView* firstUp;
    NSString* firstText = [[NSString alloc] initWithFormat:@"Do you want to fight?"];
    firstUp = [[popupView alloc] initWithText:firstText andDelegate:self andYesFunc:@selector(firstPopUpYes) andNoFunc:@selector(firstPopUpNo)];
    [self addSubview:firstUp];
    
}

-(void)toBattle{
    
    NSInteger newView = 6;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
    NSLog(@"Preparing to fight %@",opponent);
    NSNumber *numAttacking = [[NSNumber alloc] initWithInt:[armyLabel.text intValue]];
    NSArray *values = [[NSArray alloc] initWithObjects:newMode,opponent,venue,numAttacking,nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"switchView",@"enemyName",@"venue",@"subArmy",nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(IBAction)fightPushed:(id)sender{
    
    [self toBattle];
    
}

-(void)dealloc{
    
    [enemyArmySizeLabel release];
    [enemyUserNameLabel release];
    [localArmySizeLabel release];
    [localUserNameLabel release];
    [venueLabel release];
    [opponent release];
    
    [super dealloc];
    
}

@end
