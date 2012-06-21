//
//  Venue.h
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef VENUE
#define VENUE

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Player.h"

@interface Venue : NSObject{
    
    NSString* name;
    NSDecimalNumber* latitude;
    NSDecimalNumber* longitude;
    NSNumber* armySize;
    
    NSString* ID;
    
    Player *owner; //For mapView
    MKMapPoint mapPoint;
    CLLocationCoordinate2D coordinate;
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSDecimalNumber *latitude;
@property (nonatomic, retain) NSDecimalNumber *longitude;
@property (nonatomic, retain) NSNumber *armySize;
@property (nonatomic) MKMapPoint mapPoint;
@property (nonatomic) CLLocationCoordinate2D coordinate;

-(id)initWithName:(NSString*)n andLat:(NSDecimalNumber*)lat andLong:(NSDecimalNumber*)lon andArmy:(NSNumber*)army andID:(NSString*)i;
-(id)initWithName:(NSString*)n andLat:(NSDecimalNumber*)lat andLong:(NSDecimalNumber*)lon andArmy:(NSNumber*)army andID:(NSString*)i andOwnerName:(NSString*)own andOwnerToken:(NSString*)tok;

- (CLLocationCoordinate2D) getCoordinate;

@end

#endif