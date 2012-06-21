//
//  battleView.m
//  Risky Business
//
//  Created by Christian Weigandt on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//User has less of a chance of winning
#define USER_HIT_PER 40
#define VENUE_HIT_PER 45

#import "battleView.h"

@implementation battleView

@synthesize user, venue, opponent, enemyUserNameLabel, localUserNameLabel, userProgress, enemyProgress;

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
    
    localUserNameLabel.text = user.name;
    
    return self;
    
}

-(void) setOpponent:(NSString *)opp andVenue:(Venue *)v andSubArmy:(NSInteger)army{
    
    venue = v;
    opponent = [[NSString alloc] initWithString:opp];
    opponent = [opponent stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    enemyUserNameLabel.text = opponent;
    
    initialUserArmy = army;
    tmpUserArmy = army;
    user.armySize = [NSNumber numberWithInt:[user.armySize intValue] - tmpUserArmy];
        
}

-(void)startFight{
    
    tmpEnemyArmy = [venue.armySize intValue];
    NSLog(@"%d vs %d",tmpUserArmy, tmpEnemyArmy);
    [self skirmish:nil];
}

-(void)skirmish:(NSTimer*)timer{
    
    if(tmpUserArmy > 0 && tmpEnemyArmy > 0){
        
        NSInteger userHit = arc4random()%100;
        NSInteger enemyHit = arc4random()%100;
        while( userHit > USER_HIT_PER && enemyHit > VENUE_HIT_PER){
            userHit = arc4random()%100;
            enemyHit = arc4random()%100;
        }
        
        if( userHit <= USER_HIT_PER)
            tmpEnemyArmy--;
        if( enemyHit <= VENUE_HIT_PER)
            tmpUserArmy--;
        
        [userProgress setProgress:(float)([venue.armySize intValue]-tmpEnemyArmy)/[venue.armySize intValue] animated:YES];
        [enemyProgress setProgress:(float)(initialUserArmy-tmpUserArmy)/initialUserArmy animated:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(skirmish:) userInfo:nil repeats:NO];
    }
    else{
        if(tmpEnemyArmy == 0 && tmpUserArmy == 0) //On tie venue army wins
            tmpEnemyArmy = 1;
        
        [self endBattle];
    }

}

-(void)endBattle{
    
    user.armySize = [NSNumber numberWithInt:[user.armySize intValue]+tmpUserArmy];
    venue.armySize = [NSNumber numberWithInt:tmpEnemyArmy];
        
    NSString *postString = [[NSString alloc] initWithFormat:@"%@&%@",user,venue];
    [[Connection alloc] initWithSelector:@selector(afterBattle:) 
                                toTarget:self 
                                 withURL:@"http://linus.highpoint.edu/~cweigandt/riskyBusiness/postBattle.php" 
                              withString:postString];
    NSInteger newView = 3;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
    NSNumber *subArmy = [[NSNumber alloc] initWithInt:tmpUserArmy];
    NSArray* values = [[NSArray alloc] initWithObjects:newMode,subArmy,venue, nil];
    NSArray* keys = [[NSArray alloc] initWithObjects:@"switchView",@"subArmy",@"venue", nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(void)afterBattle:(NSData*)receivedData{
    
    
}

@end
