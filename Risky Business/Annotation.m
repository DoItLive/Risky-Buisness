//
//  Annotation.m
//  Risky Business
//
//  Created by Langford Thomas on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize image,title,subtitle,coordinate;

- (id) initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t subtitle:(NSString *)st {
    coordinate = c;
    title = t;
    subtitle = st;
    return self;
}

- (void)dealloc {
    [image release];
    
    [super dealloc];
}

@end
