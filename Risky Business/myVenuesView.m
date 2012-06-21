//
//  myVenuesView.m
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "myVenuesView.h"

@implementation myVenuesView

@synthesize scroller, meter, user, venues, fortifyButton, menuButton, venueLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id)initWithPlayer:(Player*)u{
    
    user = u;
    meter = [[Meter alloc] init];
    [self addSubview:meter];
    
    return self;
    
}

//Calls getMyVenues.php
-(void)update{
    
    scroller = [[TileScroller alloc] initWithTarget:self andSelector:@selector(tileChosen:)];
    [self addSubview:scroller];
    NSString *postString = [[NSString alloc] initWithFormat:@"token=%@",user.token];
    [[Connection alloc] initWithSelector:@selector(updateVenues:) 
                                                      toTarget:self 
                                                       withURL:@"http://linus.highpoint.edu/~cweigandt/riskyBusiness/getMyVenues.php" 
                                                    withString:postString];    
}

//Selector for getMyVenues.php -> Sets up the uipickerview
-(void)updateVenues:(NSData*) receivedData{
    
    NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSArray* chunks = [[NSArray alloc] initWithArray:[responseString componentsSeparatedByString: @","]];

    venues = [[NSMutableArray alloc] initWithCapacity:(chunks.count/5)];
    for(int i=0;i<chunks.count-1;i+=5){
        
        NSString* name = [[NSString alloc] initWithFormat:@"%@",[chunks objectAtIndex:i]];
        NSNumber* army = [[NSNumber alloc] initWithInt:[[chunks objectAtIndex:i+1] intValue]];
        NSDecimalNumber *lat = [[NSDecimalNumber alloc] initWithString:[chunks objectAtIndex:i+2]];
        NSDecimalNumber *lon = [[NSDecimalNumber alloc] initWithString:[chunks objectAtIndex:i+3]];
        NSString* ID = [[NSString alloc] initWithFormat:@"%@",[chunks objectAtIndex:i+4]];
        Venue* venue = [[Venue alloc] initWithName:name andLat:lat andLong:lon andArmy:army andID:ID];
        [venues addObject:venue];
        [scroller addTileWithVenue:venue];
        
        NSLog(@"%@",venue);
    }
    
    NSInteger totalSize = [user.armySize intValue] + [((Venue*)[venues objectAtIndex:0]).armySize intValue];
    [meter setMaxValue:totalSize andValue:[((Venue*)[venues objectAtIndex:0]).armySize intValue]];
    venueLabel.text = ((Venue*)[venues objectAtIndex:0]).name;

    [chunks release];
    [responseString release];
}

//Called when uipickerview gets a row chosen -> updates labels
-(void)tileChosen:(Venue *)venue{
        
    NSInteger totalSize = [user.armySize intValue] + [venue.armySize intValue];
    [meter setMaxValue:totalSize andValue:[venue.armySize intValue]];
    venueLabel.text = venue.name;
}

//Switches view to fortifyView -> sends venue information
-(IBAction)fortifyPressed:(id)sender{

    NSInteger newView = 2;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
    
    NSArray *values = [[NSArray alloc] initWithObjects:newMode,[scroller getCurTile],nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"switchView",@"venue",nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    [scroller release];

}

-(IBAction)menuPressed:(id)sender{
    
    NSInteger newView = 0;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    [scroller release];
}

-(void)dealloc{
        
    [scroller release];
    [venueLabel release];
    [fortifyButton release];
    //[venues release];
    [super dealloc];
    
}

@end
