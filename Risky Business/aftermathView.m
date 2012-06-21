//
//  aftermathView.m
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "aftermathView.h"

@implementation aftermathView

@synthesize venue, subArmy, resultLabel, okayButton, user;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithPlayer:(Player *)u{
    
    user = u;
    return self;
    
}

-(void)setArmy:(NSNumber*)b andVenue:(Venue*)v{
    
    subArmy = b;
    venue = v;
        
    if( [subArmy intValue] > 0){ //YOU WON
        
        resultLabel.text = [[NSString alloc] initWithFormat:@"Congratulations! You have conquered %@",venue.name];
        NSString *postString = [[NSString alloc] initWithFormat:@"%@&venue=%@&statArmy=%d&lat=%@&lon=%@&ID=%@",
                                user,venue.name, [subArmy intValue],venue.latitude,venue.longitude, venue.ID];
        [[Connection alloc] initWithSelector:@selector(fortifyFinished:)
                                    toTarget:self 
                                     withURL:@"http://linus.highpoint.edu/~cweigandt/riskyBusiness/fortifyVenue.php" 
                                  withString:postString];
        
    }else{ //YOU LOST
        
        resultLabel.text = [[NSString alloc] initWithFormat:@"You have failed to conquer %@",venue.name];
        
    }
    
}

-(void)fortifyFinished:(NSData*)receivedData{
    //Do Nothing
    
    
}

-(IBAction)okayPressed:(id)sender{
    
    if( [subArmy intValue] > 1){ //YOU WON -> to fortify
        
        NSInteger newView = 2;
        NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
        
        NSArray *values = [[NSArray alloc] initWithObjects:newMode,venue,nil];
        NSArray *keys = [[NSArray alloc] initWithObjects:@"switchView",@"venue",nil];
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    }else{ //YOU LOST -> to menu        
        NSInteger newView = 0;
        NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
        NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    }
    
}

-(void)dealloc{
    
    [okayButton release];
    [resultLabel release];
    [subArmy release];
    [super dealloc];
}


@end
