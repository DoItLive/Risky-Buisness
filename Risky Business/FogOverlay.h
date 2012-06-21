//
//  FogOverlay.h
//  Risky Business
//
//  Created by Langford Thomas on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FogOverlay : NSObject <MKOverlay> {
    CLLocationCoordinate2D coordinate;
    MKMapRect boundingMapRect;
    
    UIImage *overlayImage;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) UIImage *overlayImage;

- (id)initWithMapRect:(MKMapRect)rect andImage:(UIImage*)img;
- (UIImage*)overlayImage;

@end
