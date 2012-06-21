//
//  FogOverlayView.h
//  Risky Business
//
//  Created by Langford Thomas on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FogOverlay.h"

@interface FogOverlayView : MKOverlayView {
    UIImage *fogImage;
}

@property (nonatomic, retain) UIImage *fogImage;

- (void) setImage:(UIImage*)img;

@end
