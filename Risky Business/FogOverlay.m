//
//  FogOverlay.m
//  Risky Business
//
//  Created by Langford Thomas on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FogOverlay.h"

@implementation FogOverlay

@synthesize coordinate,overlayImage;

- (id)initWithMapRect:(MKMapRect)rect andImage:(UIImage *)img{
    boundingMapRect = rect;
    overlayImage = img;
    
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return coordinate;
}

- (MKMapRect)boundingMapRect {
    return boundingMapRect;
}

- (UIImage *)overlayImage {
    return overlayImage;
}

/*- (void)dealloc {
    [image release];
    image = nil;
    
    [super dealloc];
}*/

@end
