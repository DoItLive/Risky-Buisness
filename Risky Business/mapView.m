//
//  mapView.m
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mapView.h"
#import "Annotation.h"
#import "Connection.h"

@implementation mapView

@synthesize mapViewInstance, backButton, armyStatsLabel, usernameLabel,venueInfo, nextButton, curIndex, nVenues, allVenues, fogImageView, fogImage, maskImage, curFogImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
    }
    return self;
}

- (void)initWithPlayer:(Player *)player {
    user = player;
    
    fogImage = [UIImage imageNamed:@"Fog.png"];
    maskImage = [UIImage imageNamed:@"fogMask.png"];
    fogImageView.alpha = 0.5;
    
    
}

- (void)update {
                
    self.mapViewInstance.mapType = MKMapTypeStandard;
    self.mapViewInstance.showsUserLocation = YES;
    
    //NSLog(@"mapView update called");
    
    usernameLabel.text = user.name;
    armyStatsLabel.text = [NSString stringWithFormat:@"Standing Army: %d",[user.armySize intValue]];
    
    NSString *postString = [[NSString alloc] initWithFormat:@"token=%@",user.token];
    NSLog(@"Post string: %@",postString);
    
    [[Connection alloc] initWithSelector:@selector(processData:) 
                                toTarget:self 
                                 withURL:@"http://linus.highpoint.edu/~cweigandt/riskyBusiness/mapRequest.php"
                              withString:postString];
    
    [postString release];
}

- (void)dealloc {
    [mapViewInstance release];
    [backButton release];
    [nextButton release];
    [armyStatsLabel release];
    [usernameLabel release];
    [fogImage release];
    [maskImage release];
    [curFogImage release];
    
    [venueInfo release];
    [allVenues release];
    
    [super dealloc];
}

- (IBAction)backButtonPressed:(id)sender {
    NSInteger mapViewNum = 0;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:mapViewNum];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)nextButtonPressed:(id)sender {
    //NSLog(@"next button pushed");
    
    CLLocationCoordinate2D coordinate = [[allVenues objectAtIndex:curIndex] getCoordinate];
    NSLog(@"coordinate - lat: %lf lon: %lf",coordinate.latitude,coordinate.longitude);
    
    curIndex = (curIndex+1)%nVenues;
    [mapViewInstance setCenterCoordinate:coordinate animated:YES];
}

- (void)processData:(NSData *)receivedData {
    
    if (receivedData == NULL) {
        
        NSString *title = [NSString stringWithFormat:@"Connection Error"];
        NSString *message = [NSString stringWithFormat:@"Could not connect to server. Make sure you are connected to the internet and try again."];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        
        [alert show];
    }
    
    NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    venueInfo = [[NSArray alloc] initWithArray:[responseString componentsSeparatedByString: @","]];
    
    curIndex = nVenues = 0;
    
    //Data looks like:
    //  latitude,longitude,venueName,venueID,token,ownerName,nSoldiers
    
    allVenues = [[NSMutableArray alloc] init];
    
    //Add seven since a set is every seven entries
    for (int i=0; i<venueInfo.count-1; i+=7) {
        NSDecimalNumber *lat = [[NSDecimalNumber alloc] initWithString:[venueInfo objectAtIndex:i]];
        NSDecimalNumber *lon = [[NSDecimalNumber alloc] initWithString:[venueInfo objectAtIndex:i+1]];

        NSString *venueName = [[NSString alloc] initWithString:[venueInfo objectAtIndex:i+2]];
        NSString *venueID = [[NSString alloc] initWithString:[venueInfo objectAtIndex:i+3]];
        NSString *token = [[NSString alloc] initWithString:[venueInfo objectAtIndex:i+4]];
        NSString *userName = [[NSString alloc] initWithString:[venueInfo objectAtIndex:i+5]];
        userName = [userName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        NSString *armySize = [[NSString alloc] initWithString:[venueInfo objectAtIndex:i+6]];
        NSNumber *armyS = [[NSNumber alloc] initWithInteger:[armySize integerValue]];

        NSString *annSubtitle = [[NSString alloc] initWithFormat:@"%@: %@",userName,armySize];
    
        Venue *ven = [[Venue alloc] initWithName:venueName andLat:lat andLong:lon andArmy:armyS andID:venueID andOwnerName:userName andOwnerToken:token];
        
        //Get rid of duplicates
        if (![allVenues containsObject:ven]) {
            CLLocationCoordinate2D venueCoord = CLLocationCoordinate2DMake([lat doubleValue],[lon doubleValue]);
            
            Annotation *ann;
            
            //Create annotation for every friend/user else create annotation for every enemy within specified radius
            if ([token isEqualToString:user.token]) {
                ann = [[FriendAnnotation alloc] initWithCoordinate:venueCoord title:venueName subtitle:annSubtitle];
                [allVenues insertObject:ven atIndex:nVenues];
                nVenues++;
                [mapViewInstance addAnnotation:ann];
                
                [ann release];
                //Set to nil that way when ann is released next it doesn't accidently double release an annotation it was still pointing at
                ann = nil; 
            } else {
                MKMapPoint mapPoint = MKMapPointForCoordinate(venueCoord);
                for (int j=0; j<nVenues; j++) { //Check only the user's venues
                    //NSLog(@"Meters between points: %f",MKMetersBetweenMapPoints(mapPoint, [[allVenues objectAtIndex:j] mapPoint]));
                    if (MKMetersBetweenMapPoints(mapPoint, [[allVenues objectAtIndex:j] mapPoint]) <= RADIUS) {
                        ann = [[EnemyAnnotation alloc] initWithCoordinate:venueCoord title:venueName subtitle:annSubtitle];
                        [allVenues addObject:ven];
                        [mapViewInstance addAnnotation:ann];
                        
                        [ann release];
                        //Set to nil that way when ann is released next it doesn't accidently double release an annotation it was still pointing at
                        ann = nil; 
                    }
                }
            }
        }
        //Can release armySize since I don't pass it as a pointer to an object such as ven.
        //It is only used to make another string so code is nicer
        [armySize release];
        [ven release];
    }
        
    [responseString release];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[[allVenues objectAtIndex:0] latitude] doubleValue], 
                                                                   [[[allVenues objectAtIndex:0] longitude] doubleValue]);    
    /* //Suff for overlays -- For reference
    MKMapRect rect = [mapViewInstance visibleMapRect];
    MKMapPoint points[4],points2[4];

    points[0] = MKMapPointMake(rect.origin.x-rect.size.width/2, rect.origin.y+rect.size.height/2);
    points[1] = MKMapPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2);
    points[2] = MKMapPointMake(rect.origin.x+rect.size.width/2, rect.origin.y-rect.size.height/2);
    points[3] = MKMapPointMake(rect.origin.x-rect.size.width/2, rect.origin.y-rect.size.height/2);
    
    points2[0] = MKMapPointMake(rect.origin.x-rect.size.width/4, rect.origin.y+rect.size.height/4);
    points2[1] = MKMapPointMake(rect.origin.x+rect.size.width/4, rect.origin.y+rect.size.height/4);
    points2[2] = MKMapPointMake(rect.origin.x+rect.size.width/4, rect.origin.y-rect.size.height/4);
    points2[3] = MKMapPointMake(rect.origin.x-rect.size.width/4, rect.origin.y-rect.size.height/4);
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points2 count:4];
    NSArray *interPolys = [[NSArray alloc] initWithObjects:poly, nil];    
    
    [mapViewInstance addOverlay:[MKCircle circleWithCenterCoordinate:coordinate radius:RADIUS]];
    [mapViewInstance addOverlay:[MKPolygon polygonWithPoints:points count:4 interiorPolygons:interPolys]];
    */
     
    //Zoom in on first venue
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 400, 400);
    [mapViewInstance setRegion:region animated:YES];
    curIndex = (curIndex+1)%nVenues;
}

- (void) updateFog {
        
    CGImageRef img = [maskImage CGImage];
    
    UIGraphicsBeginImageContext(maskImage.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, CGImageGetWidth(img), CGImageGetHeight(img));
    CGContextDrawImage(context, rect, img);
    
    [self drawCircles:context];
        
    UIImage *newfogMask = UIGraphicsGetImageFromCurrentImageContext();
    if (newfogMask == nil) {
        NSLog(@"Error: Could not get the current image context");
        exit(1);
    }
    UIGraphicsEndImageContext();
    
    curFogImage = [self maskImage:fogImage withMask:newfogMask];
    
    //FogOverlay *fogOverlay = [[FogOverlay alloc] initWithMapRect:[mapViewInstance visibleMapRect] andImage:curFogImage];
    //[mapViewInstance addOverlay:fogOverlay];
    //[fogOverlay release];
    
    fogImageView.image = curFogImage;
}

- (void) drawCircles:(CGContextRef)context {
    
    for (int i=0; i<nVenues; i++) {
        CLLocationCoordinate2D coord = [[allVenues objectAtIndex:i] getCoordinate];
        
        //If the current visible map region contains the coordinate than calculate the circle for fog of war
        if (MKMapRectContainsPoint([mapViewInstance visibleMapRect], MKMapPointForCoordinate(coord))) {
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, RADIUS*2, RADIUS*2);
            
            CGRect circ = [mapViewInstance convertRegion:region toRectToView:fogImageView];
            circ.origin.x += [mapViewInstance frame].origin.x; //Offset for where view is located
            circ.origin.y += [mapViewInstance frame].origin.y; //Offset for where view is located
        
            CGContextSetRGBFillColor(context, 255, 255, 255, 1.0);
            CGContextFillEllipseInRect(context, circ);
        }
    }
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImg {
    
    CGImageRef maskRef = maskImg.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef), 
                                        CGImageGetHeight(maskRef), 
                                        CGImageGetBitsPerComponent(maskRef), 
                                        CGImageGetBitsPerPixel(maskRef), 
                                        CGImageGetBytesPerRow(maskRef), 
                                        CGImageGetDataProvider(maskRef), NULL, true);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
}


//===========================================UIAlertView Delegate Methods========================================
//
//
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self update];
    }
    NSLog(@"Error: Clicked some other button than cancel or retry");
}

- (void) alertViewCancel:(UIAlertView *)alertView {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
