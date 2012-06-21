//
//  Player.m
//  Risky Business
//
//  Created by Christian Weigandt on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

@implementation Player
    
@synthesize name,token,armySize;   
    
-(id) initWithToken:(NSString*)t{
    
    token = t;
    
    return self;
    
}

-(id) initWithName:(NSString *)n andToken:(NSString *)t {
    
    name = n;
    token = t;
    
    return self;
}

- (NSString *)description{
    
    NSString* post = [[NSString alloc] initWithFormat:@"token=%@&name=%@&mobileArmy=%d",
                      token,name,[armySize intValue]];
    return post;
}


@end
