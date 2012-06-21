//
//  storeView.m
//  Risky Business
//
//  Created by Christian Weigandt on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "storeView.h"

@implementation storeView

@synthesize tenButton, twentyButton, fiftyButton, menuButton, user;

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

-(IBAction)tenPressed:(id)sender{
    [self addToArmy:10];
}

-(IBAction)twentyPressed:(id)sender{
    [self addToArmy:20];
}

-(IBAction)fiftyPressed:(id)sender{
    [self addToArmy:50];
}

-(IBAction)menuPressed:(id)sender{
    
    NSInteger newView = 0;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(void)addToArmy:(NSInteger)addition{

    user.armySize = [NSNumber numberWithInt:[user.armySize intValue] + addition];
    NSInteger newArmy = [user.armySize intValue] + addition;
    NSString *postString = [[NSString alloc] initWithFormat:@"token=%@&army=%d",user.token,newArmy];
    [[Connection alloc] initWithSelector:@selector(afterUpdate:) 
                                toTarget:self 
                                 withURL:@"http://linus.highpoint.edu/~cweigandt/riskyBusiness/addToArmy.php" 
                              withString:postString];    
}

-(void)afterUpdate:(NSData*)receivedData{
    //Do nothing
    
}

@end
