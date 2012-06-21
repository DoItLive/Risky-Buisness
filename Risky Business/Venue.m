//
//  Venue.m
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Venue.h"

@implementation Venue

@synthesize name, latitude, longitude, armySize, ID, mapPoint, coordinate;

//Need to check for & in company name - Also check for , for db
-(id)initWithName:(NSString*)n andLat:(NSDecimalNumber*)lat andLong:(NSDecimalNumber*)lon andArmy:(NSNumber*)army andID:(NSString*)i{
    
    name = n;
    latitude = lat;
    longitude = lon;
    armySize = army;
    ID = i;
    
    return self;
}

-(id)initWithName:(NSString *)n andLat:(NSDecimalNumber *)lat andLong:(NSDecimalNumber *)lon andArmy:(NSNumber *)army andID:(NSString *)i andOwnerName:(NSString *)own andOwnerToken:(NSString *)tok {
    
    name = n;
    latitude = lat;
    longitude = lon;
    armySize = army;
    ID = i;
    
    Player *player = [[Player alloc] initWithName:own andToken:tok];
    owner = player;
    
    coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    mapPoint = MKMapPointForCoordinate(coordinate);
    
    return self;
}

- (CLLocationCoordinate2D) getCoordinate {
    return coordinate;
}

//Overloaded NSObject implementation to compare a venue to a different object
-(BOOL) isEqual:(id)object {
    //Must check if it is a venue class before checking for the object's name
    if ([object isKindOfClass:[Venue class]] && [ID isEqualToString:[object ID]]) {
        return TRUE;
    }
    return FALSE;
}

- (NSString *)description{
    
    NSString* post = [[NSString alloc] initWithFormat:@"venue=%@&statArmy=%d&lat=%@&lon=%@&ID=%@",
          name, [armySize intValue],latitude,longitude, ID];
    return post;
}

@end
