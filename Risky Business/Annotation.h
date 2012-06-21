//
//  Annotation.h
//  Risky Business
//
//  Created by Langford Thomas on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
    UIImage *image;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *) t subtitle:(NSString *) st;

@end
