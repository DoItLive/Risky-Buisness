//
//  preBattleView.h
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "Venue.h"
#import "Player.h"
#import "popupView.h"

@interface preBattleView : UIView{
    
    UILabel *enemyArmySizeLabel;
    UILabel *enemyUserNameLabel;
    UILabel *localUserNameLabel;
    UILabel *localArmySizeLabel;
    UILabel *venueLabel;
    UIButton *fightButton;
    UISlider *slider;
    UILabel *armyLabel;
        
    NSString *opponent;
    Venue* venue;
    Player* user;

}
@property (nonatomic, retain) IBOutlet UILabel *enemyArmySizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *enemyUserNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *localUserNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *localArmySizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *venueLabel;
@property (nonatomic, retain) IBOutlet UIButton *fightButton;
@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UILabel *armyLabel;

@property (nonatomic, retain) NSString *opponent;
@property (nonatomic, retain) Venue *venue;
@property (nonatomic, retain) Player *user;

-(void)firstPopUpYes;
-(void)firstPopUpNo;
-(void)secondPopUpYes;
-(void)secondPopUpNo;
-(void)setOpponent:(NSString *)opp andVenue:(Venue*)v;
-(id)initWithPlayer:(Player*)u;
-(void)toBattle;
-(IBAction)fightPushed:(id)sender;
-(IBAction)sliderMoved:(id)sender;

@end
