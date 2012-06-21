//
//  Player.h
//  Risky Business
//
//  Created by Christian Weigandt on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef PLAYER
#define PLAYER

#import <Foundation/Foundation.h>

@interface Player : NSObject{
    
    NSString* name;
    NSString* token;
    NSNumber* armySize;
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSNumber *armySize;

-(id) initWithToken:(NSString*)t;
-(id) initWithName:(NSString*)n andToken:(NSString*)t;

@end

#endif