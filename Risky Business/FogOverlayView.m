//
//  FogOverlayView.m
//  Risky Business
//
//  Created by Langford Thomas on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FogOverlayView.h"

@implementation FogOverlayView

@synthesize fogImage;

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    if (![self.overlay isKindOfClass:[FogOverlay class]]) {
        NSLog(@"Error: Cannot draw overlay because overlay is not of class FogOverlay");
        exit(1);
    }
    
    // UIImage *image = [UIImage imageNamed:@"Fog.png"];
    //CGImageRef imgRef = [image CGImage];
    
    if (fogImage == nil) {
        NSLog(@"Error: fogImage = nil");
        exit(1);
    }
    CGImageRef imgRef = [fogImage CGImage];
    
    MKMapRect mRect = [self.overlay boundingMapRect];
    CGRect rect = [self rectForMapRect:mRect];
    CGRect clipRect = [self rectForMapRect:mapRect];
    
    CGContextAddRect(context, clipRect);
    CGContextClip(context);
    
    CGContextDrawImage(context, rect, imgRef);
}

- (void)setImage:(UIImage *)img {
    fogImage = img;
}

/*- (void)dealloc {
    [fogImage release];
    fogImage = nil;
    
    [super dealloc];
}*/

@end
