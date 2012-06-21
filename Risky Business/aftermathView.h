//
//  aftermathView.h
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "Player.h"
#import "Connection.h"

@interface aftermathView : UIView{
    
    UILabel* resultLabel;
    UIButton* okayButton;
    
    NSNumber* subArmy;
    Venue* venue;
    Player* user;
}

@property (nonatomic, retain) IBOutlet UILabel *resultLabel;
@property (nonatomic, retain) IBOutlet UIButton *okayButton;


@property (nonatomic, retain) Venue *venue;
@property (nonatomic, retain) Player *user;
@property (nonatomic, retain) NSNumber *subArmy;

-(void)setArmy:(NSNumber*)b andVenue:(Venue*)v;
-(IBAction)okayPressed:(id)sender;
-(id)initWithPlayer:(Player*)u;
-(void)fortifyFinished:(NSData*)receivedData;

@end
