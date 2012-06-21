//
//  checkInView.m
//  Risky Business
//
//  Created by Christian Weigandt on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "checkInView.h"

@implementation checkInView

@synthesize venuePicker, chooseButton, info, selection, user, venue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithPlayer:(Player*)u{
    
    user = u;
    return self;
    
}

-(void)setPick{
    venuePicker.showsSelectionIndicator = YES;
    [venuePicker setDataSource: self];
    [venuePicker setDelegate: self];
    info = [[NSArray alloc] init];
}

-(void)updatePick{
    [venuePicker reloadAllComponents];
    self.selection = 0;
}

-(void)setInfo:(NSArray *)incoming{
    [info release];
    info = [[NSArray alloc] initWithArray:incoming];
}


-(IBAction)choosePushed:(id)sender{ //Change from NSDictionary to Venue
    NSDictionary* dict = [info objectAtIndex:selection];
    NSString* name = [dict objectForKey:@"name"];
    NSString* lat = [dict objectForKey:@"latitude"];
    NSString* lon = [dict objectForKey:@"longitude"];
    NSString* ID = [dict objectForKey:@"id"];
    NSDecimalNumber* latitude = [[NSDecimalNumber alloc] initWithFloat:[lat floatValue]];
    NSDecimalNumber* longitude = [[NSDecimalNumber alloc] initWithFloat:[lon floatValue]];
    NSNumber* army = [[NSNumber alloc] initWithInt:0];
    
    //BIG TODO venue is NULL for no good reason
    NSLog(@"%@ - %f - %f - %@",name, [latitude floatValue], [longitude floatValue], ID);
    venue = [[Venue alloc] initWithName:name andLat:latitude andLong:longitude andArmy:army andID:ID];
    NSLog(@"Venue - %@",venue);

    NSString *postString = [[NSString alloc] initWithFormat:@"uname=%@&token=%@&ID=%@",user.name, user.token,venue.ID];
    [[Connection alloc] initWithSelector:@selector(chooseView:) 
                                toTarget:self 
                                 withURL:@"http://linus.highpoint.edu/~cweigandt/riskyBusiness/checkIn.php" 
                              withString:postString];
    
}

-(void) chooseView:(NSData*)receivedData{
    
    NSLog(@"chooseView");
    //Get back "enemyName,armySize" Both NULL/0 if no one is there
    NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSArray *chunks = [[NSArray alloc] initWithArray:[responseString componentsSeparatedByString: @","]];
    
    NSString *enemyName = [[NSString alloc] initWithString:[chunks objectAtIndex:0]];
    enemyName = [enemyName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    NSString *enemyArmy = [[NSString alloc] initWithString:[chunks objectAtIndex:1]];
    NSNumber *newMode = [NSNumber alloc];
    venue.armySize = [NSNumber numberWithInt:[enemyArmy intValue]];
    
    if( ![enemyName compare:@"NULL"] || ![enemyName compare:user.name]){ //Probably should compare tokens rather than names
        NSLog(@"No enemy or you own it already");
        newMode = [NSNumber numberWithInt:2];
        
    }else{ //Time to battle
        NSLog(@"Enemy!");
        newMode = [NSNumber numberWithInt:1];
    }
    
    NSArray* values = [[NSArray alloc] initWithObjects:newMode,venue,enemyName,nil];
    NSArray* keys = [[NSArray alloc] initWithObjects:@"switchView",@"venue",@"enemyName",nil];
    
    //NSLog(@"%d - %@ - %d - %@ - %@ - %@",[newMode integerValue],enemyName,[armySize integerValue],venueName,lat,lon);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSNotification* notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [responseString release];
    [chunks release];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.info count];
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [(NSDictionary *)[self.info objectAtIndex: row] objectForKey:@"name"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selection = row;
}


@end
