//
//  ViewController.m
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize menuViewInst, preBattleViewInst, fortifyViewInst, battleViewInst, aftermathViewInst, mapViewInst, myVenuesViewInst, checkInViewInst, storeViewInst, user;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeView:) 
                                                 name:@"ViewChange"
                                               object:nil];
    
        
    NSString *filePath =[self dataFilePath];

    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSLog(@"Should be running timer");
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkForDBID:) userInfo:nil repeats:NO];
    }
    else{
        NSNumber *newMode = [[NSNumber alloc] initWithInt:0];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
        NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];    
    }
    
    //Set up location manager
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
}

-(void)checkForDBID:(NSTimer *)Timer{
    
    NSString *filePath =[self dataFilePath];
    NSLog(@"hit the timer");
    
    NSError *error = nil;
    NSString *postString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    postString = [postString stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(postString && postString != @""){
        NSLog(@"DBID %@",postString);
        NSArray *chunks = [[NSArray alloc] initWithArray:[postString componentsSeparatedByString: @";"]];
        NSString* token = [NSString stringWithString:postString];
        user = [[Player alloc] initWithToken:token]; //MINE
        [self setUpUser]; //Only run if token found - FIX
        menuViewInst.token = user.token;
        NSNumber *newMode = [[NSNumber alloc] initWithInt:0];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
        NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [chunks release];
    }else{
        [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(checkForDBID:) userInfo:nil repeats:NO];
    }
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)changeView:(NSNotification *)notif{
    
    NSDictionary *dict = [notif userInfo];
    NSNumber *newMode = [dict objectForKey:@"switchView"];

    NSInteger newView = [newMode integerValue];

    switch(newView){
            
        case 0: //Menu View
            [menuViewInst setup];
            [checkInViewInst setPick];
            lati = locationManager.location.coordinate.latitude;
            longi = locationManager.location.coordinate.longitude;
            NSLog(@"%lf,%lf",lati,longi);
            [menuViewInst setLatitude:lati andLongitude:longi];
            //[menuViewInst setLatitude:35.667576 andLongitude:-80.4751];
            self.view = menuViewInst;
            break;
        case 1:{ //PreBattle View
            NSString *enemyName = [dict objectForKey:@"enemyName"];
            Venue *venue = [dict objectForKey:@"venue"];
            [preBattleViewInst setOpponent:enemyName andVenue:venue];
            self.view = preBattleViewInst;
            break;
        }
        case 2:{ //Fortify View
            NSLog(@"Switching to fortify view");
            Venue* venue = [dict objectForKey:@"venue"];
            [fortifyViewInst setVenue:venue];
            self.view = fortifyViewInst;
            break;
        }
        case 3:{ //Aftermath View
            NSNumber* subArmy = [dict objectForKey:@"subArmy"];
            Venue* venue = [dict objectForKey:@"venue"];
            [aftermathViewInst setArmy:subArmy andVenue:venue];
            self.view = aftermathViewInst;
            break;
        }
        case 4: //Map View
            mapViewInst.mapViewInstance.delegate = self;
            [mapViewInst update];
            self.view = mapViewInst;
            break;
        case 5: //myVenues View
            [myVenuesViewInst update];
            self.view = myVenuesViewInst;
            break;
        case 6:{ //battle View
            NSString *enemyName = [dict objectForKey:@"enemyName"];
            Venue *venue = [dict objectForKey:@"venue"];
            NSNumber *numAttacking = [dict objectForKey:@"subArmy"];
            [battleViewInst setOpponent:enemyName andVenue:venue andSubArmy:[numAttacking intValue]];
            self.view = battleViewInst;
            [battleViewInst startFight];
            break;
        case 7:{ //checkIn View
            [checkInViewInst setInfo:[dict objectForKey:@"venues"]];
            [checkInViewInst updatePick];
            self.view = checkInViewInst;
            break;
        }
        case 8:{
            self.view = storeViewInst;
            break;
        }
            
        }
            
    }
        
}

-(NSString *)dataFilePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"DBID.txt"];
}

-(void)dealloc{
    
    [menuViewInst release];
    [myVenuesViewInst release];
    [preBattleViewInst release];
    [mapViewInst release];
    [fortifyViewInst release];
    [aftermathViewInst release];
    [user release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


//=================================================Delegate functions for map view=================================================//

//Called when one or more annotations are added to the map view
- (void)mapView:(MKMapView*)mv didAddAnnotationViews:(NSArray *)views {
    //NSLog(@"didAddAnnotationViews called");
    
}

//Called when a new annotation is created
//Used for customizing how the annotation looks
- (MKAnnotationView *)mapView: (MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation {
    //NSLog(@"viewForAnnotation called");
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else if([annotation isKindOfClass:[FriendAnnotation class]]) {
        
        static NSString *AnnotationIdentifier = @"FriendAnnotationIdentifier";
        MKPinAnnotationView *pinView = (MKPinAnnotationView*) [mapViewInst.mapViewInstance dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
        
        if(!pinView) {
            pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
            [pinView setPinColor:MKPinAnnotationColorGreen];
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            //NSLog(@"Pin added");
            
            //Add image here for annotation
            
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    
    } else if ([annotation isKindOfClass:[EnemyAnnotation class]]) {
        
        static NSString *AnnotationIdentifier = @"EnemyAnnotationIdentifier";
        MKPinAnnotationView *pinView = (MKPinAnnotationView*) [mapViewInst.mapViewInstance dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
        
        if(!pinView) {
            pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
            [pinView setPinColor:MKPinAnnotationColorRed];
             pinView.animatesDrop = YES;
             pinView.canShowCallout = YES;
             
             //NSLog(@"Pin added");
             
             //Add image here for annotation
             
        } else {
            pinView.annotation = annotation;
        }
        return pinView;

    } else {
        NSLog(@"Error: Annotation is of some class other than FriendAnnotation or EnemyAnnotation - Obviously an error");
        exit(1);
    }
}

//Delegate method for overlays in MapKit
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {    
    
    NSLog(@"%@",[overlay class]);
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [UIColor blueColor];
    
        return [circleView autorelease];
    } else if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonView *polygonView = [[MKPolygonView alloc] initWithOverlay:overlay];
        polygonView.fillColor = [UIColor greenColor];
        
        return [polygonView autorelease];
    } else if ([overlay isKindOfClass:[FogOverlay class]]) {
        FogOverlay *fogOverlay = overlay;
        FogOverlayView *fogOverlayView = [[FogOverlayView alloc] initWithOverlay:fogOverlay];
        [fogOverlayView setImage:[fogOverlay overlayImage]];
        return [fogOverlayView autorelease];
    }
   
    NSLog(@"Error: Overlay is of some class other than MKCircle, MKPolygon, or FogOverlay");
    exit(1);
}

//Called when the region in the map changes - whenever the map moves
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    [mapViewInst updateFog];
    
}

//Called when user touches an annotation
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"didSelectAnnotationView called");
    [mapViewInst bringSubviewToFront:view];
}



//Called when the user's location is updated
- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    //NSLog(@"Updated user location");
}

//Initialize user------------------------------

-(void)setUpUser{
    
    NSString *postString = [[NSString alloc] initWithFormat:@"token=%@",user.token];
    [[Connection alloc] initWithSelector:@selector(initUser:) 
                                toTarget:self 
                                 withURL:@"http://linus.highpoint.edu/~cweigandt/riskyBusiness/getMyInfo.php" 
                              withString:postString];
    
}

-(void)initUser:(NSData*)receivedData{
    
    NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSArray *chunks = [[NSArray alloc] initWithArray:[responseString componentsSeparatedByString: @","]];
    
    user.name = [[NSString alloc] initWithString:[chunks objectAtIndex:0]];
    user.name = [user.name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    user.armySize = [[NSNumber alloc] initWithInt:[[chunks objectAtIndex:1] integerValue]];
    [preBattleViewInst initWithPlayer:user];
    [fortifyViewInst initWithPlayer:user];
    [myVenuesViewInst initWithPlayer:user];
    [mapViewInst initWithPlayer:user];
    [battleViewInst initWithPlayer:user];
    [menuViewInst initWithPlayer:user];
    [storeViewInst initWithPlayer:user];
    [aftermathViewInst initWithPlayer:user];
    [checkInViewInst initWithPlayer:user];

}

@end
