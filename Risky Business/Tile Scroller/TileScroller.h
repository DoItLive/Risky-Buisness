//
//  ButtonScroller.h
//  2DWars
//
//  Created by Christian Weigandt on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"

@interface TileScroller : UIView<UIScrollViewDelegate>{
    
    UIScrollView* scrollView;
    UIImageView* border;
    UILabel* label;
    NSMutableArray* venues;
    
    id target;
    SEL selector;
    
}

@property(nonatomic, retain) UIScrollView* scrollView;
@property(nonatomic, retain) UIImageView* border;
@property(nonatomic, retain) UILabel* label;
@property(nonatomic, retain) NSMutableArray* venues;

-(id)initWithTarget:(id)t andSelector:(SEL)sel;
-(void)addTileWithVenue:(Venue*)venue;
-(Venue*)getCurTile;

@end
