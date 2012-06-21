//
//  ButtonScroller.m
//  2DWars
//
//  Created by Christian Weigandt on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TileScroller.h"

@implementation TileScroller

@synthesize scrollView, border, label, venues;

-(id)initWithTarget:(id)t andSelector:(SEL)sel{
    
    self = [super initWithFrame:CGRectMake(0, 390, 320, 70)];
    
    target = t;
    selector = sel;
    
    self.clipsToBounds = NO;
    UIImageView* bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BarBG.png"]];
    bg.frame = CGRectMake(0, 0, 320, 70);
    [self addSubview:bg];
    border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BarBorder.png"]];
    border.frame = CGRectMake(0, 0, 320, 70);
    [self addSubview:border];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(130, 5, 60, 60)];
    scrollView.contentSize = CGSizeMake(60, 60);
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.pagingEnabled = TRUE;
    scrollView.clipsToBounds = NO;
    scrollView.userInteractionEnabled = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, -40, 320, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
    
    venues = [[NSMutableArray alloc] init];
        
    return self;
    
}

-(Venue*)getCurTile{
    
    NSInteger pos = scrollView.contentOffset.x/60;
    if(pos < 0)pos = 0;
    else if(pos >= venues.count) pos = venues.count - 1;
    return [venues objectAtIndex:pos];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [label setAlpha:1];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scroller{

    label.text = [self getCurTile].name;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scroller{

    [target performSelector:selector withObject:[self getCurTile]];
    
    [UIView beginAnimations: @"labelHidden" context: nil];
    [UIView setAnimationDelegate: self];   
    [UIView setAnimationDuration: 0.6];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];  
    [label setAlpha:0];
    [UIView commitAnimations]; 

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
	if ([self pointInside:point withEvent:event]){
		return scrollView;
	}
	return nil;
}

-(void)addTileWithVenue:(Venue*)venue{
    
    UIImageView* tile = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Block_Button"]];
    [tile setFrame:CGRectMake(3+venues.count*60, 3, 54, 54)];
    [venues addObject:venue];
    [scrollView addSubview:tile];
    scrollView.contentSize = CGSizeMake(3+venues.count*60, 1);
    [self bringSubviewToFront:border];
    
}


@end
