//
//  fortifyView.m
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "fortifyView.h"

@implementation fortifyView

@synthesize statArmySizeLabel, mobileArmySizeLabel,venueLabel, backButton, menuButton, commitButton, slider, venue, user, stepper;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithPlayer:(Player*)u{
    
    user = u;
    
    return self;
    
}

//Initializes variables and calls getMyInfo.php
-(void)setVenue:(Venue*)v{
    
    venue = v;

    if( [venue.armySize intValue] == 0){
        venue.armySize = [NSNumber numberWithInt:1];
        user.armySize = [NSNumber numberWithInt:[user.armySize intValue] - 1];
    }
    statArmySizeLabel.text = [NSString stringWithFormat:@"%d",[venue.armySize intValue]];
    mobileArmySizeLabel.text = [NSString stringWithFormat:@"%d",[user.armySize intValue]];
    venueLabel.text = venue.name;
    
    [slider setValue:[venue.armySize floatValue]/([venue.armySize floatValue] + [user.armySize floatValue])];
    
    [stepper setMaximumValue:[user.armySize intValue]+[venue.armySize intValue]];
    [stepper setMinimumValue:1];
    
    [stepper setValue:[venue.armySize intValue]];
}

//Updates slider values
-(IBAction)sliderMoved:(id)sender{
    
    NSInteger totalArmy = [venue.armySize intValue] + [user.armySize intValue];
    NSInteger statArmyTmp = slider.value * totalArmy;
    if (statArmyTmp == 0)
        statArmyTmp = 1;
    else if (statArmyTmp > totalArmy)
        statArmyTmp = totalArmy;
    statArmySizeLabel.text = [NSString stringWithFormat:@"%d", statArmyTmp];
    mobileArmySizeLabel.text = [NSString stringWithFormat:@"%d",totalArmy - statArmyTmp];
    
    [stepper setValue:statArmyTmp];
}

-(IBAction)stepperPushed:(id)sender{
    
    NSInteger totalArmy = [venue.armySize intValue] + [user.armySize intValue];
    NSInteger statArmyTmp = stepper.value;
    statArmySizeLabel.text = [NSString stringWithFormat:@"%d", statArmyTmp];
    mobileArmySizeLabel.text = [NSString stringWithFormat:@"%d",totalArmy - statArmyTmp];
    
    [slider setValue:(float)statArmyTmp/totalArmy];
    
}

//Go to myVenuesView
-(IBAction)backButtonPressed:(id)sender{
    
    NSInteger newView = 5;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

//Go to menuView
-(IBAction)menuButtonPressed:(id)sender{
    
    NSInteger newView = 0;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

//Calls fortifyVenue.php -> updates server values for a venue
-(IBAction)commitButtonPressed:(id)sender{
    
    venue.armySize = [NSNumber numberWithInt:[statArmySizeLabel.text intValue]]; 
    user.armySize = [NSNumber numberWithInt:[mobileArmySizeLabel.text intValue]];
    
    NSString *postString = [[NSString alloc] initWithFormat:@"%@&%@", user, venue];
    [[Connection alloc] initWithSelector:@selector(fortifyFinished:)
                                toTarget:self 
                                 withURL:@"http://linus.highpoint.edu/~cweigandt/riskyBusiness/fortifyVenue.php" 
                              withString:postString];
    
}

//Selector for fortifyVenue.php
-(void)fortifyFinished:(NSData*)responseData{
    
    NSInteger newView = 5;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(void)dealloc{
    
    [statArmySizeLabel release];
    [venueLabel release];
    [mobileArmySizeLabel release];
    [backButton release];
    [menuButton release];
    [commitButton release];
    [slider release];
    [super dealloc];
    
}
@end
