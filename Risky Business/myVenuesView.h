//
//  myVenuesView.h
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "Venue.h"
#import "Player.h"
#import "TileScroller.h"
#import "Meter.h"

@interface myVenuesView : UIView{
        
    Player* user;
    NSMutableArray* venues;
    
    TileScroller* scroller;
    Meter* meter;
    
    UILabel* venueLabel;
    
    UIButton* fortifyButton;
    UIButton* menuButton;

    
}

@property (nonatomic, retain) TileScroller* scroller;
@property (nonatomic, retain) Meter* meter;
@property (nonatomic, retain) IBOutlet UIButton *fortifyButton;
@property (nonatomic, retain) IBOutlet UIButton *menuButton;
@property (nonatomic, retain) IBOutlet UILabel *venueLabel;
@property (nonatomic, retain) NSArray *venues;
@property (nonatomic, retain) Player *user;

-(id)initWithPlayer:(Player*)u;
-(void)update;
-(void)updateVenues:(NSData*) receivedData;
-(void)tileChosen:(Venue*)venue;
-(IBAction)fortifyPressed:(id)sender;
-(IBAction)menuPressed:(id)sender;

@end
