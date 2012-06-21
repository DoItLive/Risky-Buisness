//
//  battleView.h
//  Risky Business
//
//  Created by Christian Weigandt on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "Venue.h"
#import "Connection.h"

@interface battleView : UIView{
    
    Player *user;
    Venue *venue;
    NSString *opponent;
    
    NSInteger tmpUserArmy;
    NSInteger tmpEnemyArmy;
    NSInteger initialUserArmy;
    
    UILabel *enemyUserNameLabel;
    UILabel *localUserNameLabel;
    
    UIProgressView *userProgress;
    UIProgressView *enemyProgress;
    
}

@property (nonatomic, retain) IBOutlet UILabel *enemyUserNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *localUserNameLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *userProgress;
@property (nonatomic, retain) IBOutlet UIProgressView *enemyProgress;


@property (nonatomic, retain) NSString *opponent;
@property (nonatomic, retain) Venue *venue;
@property (nonatomic, retain) Player *user;

-(id)initWithPlayer:(Player*)u;
-(void)setOpponent:(NSString *)opp andVenue:(Venue*)v andSubArmy:(NSInteger)army;
-(void)startFight;
-(void)afterBattle:(NSData*)receivedData;
-(void)skirmish:(NSTimer*)timer;
-(void)endBattle;

@end
