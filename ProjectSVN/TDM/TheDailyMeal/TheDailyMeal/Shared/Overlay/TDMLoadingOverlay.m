//
//  TDMLoadingOverlay.m
//  TheDailyMeal
//
//  Created by Nithin George on 13/01/2012.
//  Copyright 2010 Rapid Value Solutions. All rights reserved.
//

#import "TDMLoadingOverlay.h"
#import <QuartzCore/QuartzCore.h>
#import "TDMAppDelegate.h"

@implementation TDMLoadingOverlay

@synthesize message;
@synthesize stickyMessage;
@synthesize indicator;
@synthesize childView;

NSString * TDMLoadingOverlayNibName = @"TDMLoadingOverlay";

+(TDMLoadingOverlay *)loadOverView:(UIView *)baseView 
					  withMessage:(NSString *)initialMessage 
							title:(NSString*)title 
						 animated:(BOOL)animated 
					centerMessage:(BOOL)centerMessage
{
	@try{
		TDMLoadingOverlay *overlay = nil;		
		NSArray * nibObjects = [[NSBundle mainBundle] 
                              loadNibNamed:TDMLoadingOverlayNibName
                              owner:nil 
                              options:nil];
		
		overlay = [nibObjects objectAtIndex:0];
		
		if (overlay){			
			overlay.message.text = initialMessage;
			
			if (title){
				overlay.stickyMessage.text = title;
			}
			else{
				overlay.stickyMessage.hidden = YES;
			}
			
			overlay.frame = baseView.bounds;
			overlay.alpha = 0;
			
			if (centerMessage){
				CGRect overlayFrame, childViewFrame;
				overlayFrame=overlay.frame;
				childViewFrame=overlay.childView.frame;
				childViewFrame.origin.y=overlayFrame.origin.y+overlayFrame.size.height-(2*childViewFrame.size.height) -50;
				childViewFrame.origin.x=(overlayFrame.size.width-childViewFrame.size.width-32)/2;
				overlay.childView.frame=childViewFrame;
			}
			
			[baseView addSubview:overlay];
			
			if(animated)
			{
				[UIView beginAnimations:@"loadInOverlay" context:nil];
				[UIView	setAnimationDuration:0.25];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
				
				overlay.alpha = 1;
				
				[UIView commitAnimations];
			}

			return overlay;
		}
	}
	@catch (NSException *ex) {
		NSLog(@"exception! %@", ex);
		abort();
	}
	return nil;
}
+(TDMLoadingOverlay *)loadOverView:(UIView *)baseView 
                      withMessage:(NSString *)initialMessage 
                         animated:(BOOL)animated
{	
	return [TDMLoadingOverlay loadOverView:baseView withMessage:initialMessage title:nil animated:animated];	
}

+(TDMLoadingOverlay *)loadOverlayOnTopWithMessage:(NSString *)initialMessage 
                                        animated:(BOOL)animated
{	
	return [TDMLoadingOverlay loadOverlayOnTopWithMessage:initialMessage title:nil animated:animated];
}

+(TDMLoadingOverlay *)loadOverlayOnTopWithMessage:(NSString *)initialMessage 
                                           title:(NSString *)title 
                                        animated:(BOOL)animated
{
	TDMAppDelegate * appDelegate = (TDMAppDelegate *)[UIApplication sharedApplication].delegate;	
	TDMLoadingOverlay *overlay = [TDMLoadingOverlay loadOverView:appDelegate.window withMessage:initialMessage title:title animated:animated];
	
	[overlay doRotation];
	
	return overlay;
	
}
+(TDMLoadingOverlay *)loadOverView:(UIView *)baseView 
                      withMessage:(NSString *)initialMessage 
                            title:(NSString*)title 
                         animated:(BOOL)animated
{
	return [TDMLoadingOverlay loadOverView:baseView withMessage:initialMessage title:title animated:animated centerMessage:NO];
	
}
+(TDMLoadingOverlay *)loadOverReportView:(UIView *)baseView 
                            withMessage:(NSString *)initialMessage 
                               animated:(BOOL)animated 
{
	return [TDMLoadingOverlay loadOverView:baseView withMessage:initialMessage title:nil animated:animated centerMessage:YES];
}

-(void)animateRotationToInterfaceOrientation:(UIInterfaceOrientation)newOrientation 
                                    duration:(NSTimeInterval)duration
{
 
	[UIView beginAnimations:@"OverlayRotation" context:nil];  
	[UIView setAnimationDuration:duration];  
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[self doRotationToInterfaceOrientation:newOrientation];

	[UIView commitAnimations];
}

-(void)doRotation{
	[self doRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
}


-(void)doRotationToInterfaceOrientation:(UIInterfaceOrientation)newOrientation
{
	switch (newOrientation) {
        case UIInterfaceOrientationPortrait:
			NSLog(@"rotating to UIInterfaceOrientationPortrait");
			self.childView.transform = CGAffineTransformMakeRotation(0);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:		
			NSLog(@"rotating to UIInterfaceOrientationPortraitUpsideDown");
			self.childView.transform = CGAffineTransformMakeRotation(3.14159);
            break;
        case UIInterfaceOrientationLandscapeLeft:
			NSLog(@"rotating to UIInterfaceOrientationLandscapeLeft");
			self.childView.transform = CGAffineTransformMakeRotation(-3.14159/2);
            break;
        case UIInterfaceOrientationLandscapeRight:			
			NSLog(@"rotating to UIInterfaceOrientationLandscapeRight");
			self.childView.transform = CGAffineTransformMakeRotation(3.14159/2);
            break;
    }	
}


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(void)removeFromSuperview:(BOOL)animated
{
	if (animated){
		pendingAnimation = YES;
		[UIView beginAnimations:@"removeAnimation" context:nil];		
		[UIView setAnimationDuration:0.25];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		self.alpha = 0;
		[UIView commitAnimations];
		[NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(removeFromSuperview) userInfo:nil repeats:NO];
	}
	else{
		pendingAnimation = NO;
		[self removeFromSuperview];
	}

}

-(void)removeFromSuperview
{
	[super removeFromSuperview];
	
}

-(void)layoutSubviews
{
	childView.layer.cornerRadius = 5.0;
    [childView.layer setMasksToBounds:YES];
	[super layoutSubviews];	
}

- (void)dealloc 
{
	NSLog(@"overlay dealloc happening");
	[childView release];
	[indicator release];
	[message release];
	[stickyMessage release];
    [super dealloc];
}


@end
