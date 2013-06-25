//
//  TDMRestaurantReviewDetailView.m
//  TheDailyMeal
//
//  Created by Apple on 19/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMRestaurantReviewDetailView.h"
@interface TDMRestaurantReviewDetailView()
@end
@implementation TDMRestaurantReviewDetailView
@synthesize reviewScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
        [self createAddReviewButtonOnNavBar];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setRBIconImage];
    reviewScrollView.scrollEnabled = YES;
    static int x = 10;    
    for (int i=0; i<5; i++) 
    {
        NSLog(@"creating view frame at x value %d",x+2);
        UIView *reviewView = [[UIView alloc]initWithFrame:CGRectMake(x+2, 2, 275, 260)];
        [reviewView setBackgroundColor:[UIColor whiteColor]];
        [reviewView.layer setCornerRadius:5.0];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x+6, 6, 60, 60)];
        imageView.image = [UIImage imageNamed:@"business1"];
        [reviewView addSubview:imageView];
        [imageView release];
        UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(x+76, 12, 95, 10)];
        userName.font  =[UIFont systemFontOfSize:12.0];
        userName.text  =@"User Name Here";
        [reviewView addSubview:userName];
        [userName release];
        UIImageView * reviwerImage= [[UIImageView alloc]initWithFrame:CGRectMake(x+167, 12, 20, 20)];
        reviwerImage.image = [UIImage imageNamed:@"business1"];
        [reviewView addSubview:reviwerImage];
        [reviwerImage release];
        UILabel *reviwerLevel = [[UILabel alloc]initWithFrame:CGRectMake(x+190, 12, 70, 10)];
        reviwerLevel.font  =[UIFont systemFontOfSize:10.0];
        reviwerLevel.text  =@"Reviwer level";
        [reviewView addSubview:reviwerLevel];
        [reviwerLevel release];
        UILabel *reviewTitle = [[UILabel alloc]initWithFrame:CGRectMake(x+76, 32, 150, 15)];
        reviewTitle.font  =[UIFont systemFontOfSize:15.0];
        reviewTitle.text  =@"Review Title";
        [reviewView addSubview:reviewTitle];
        [reviewTitle release];
        
        UITextView *review = [[UITextView alloc]initWithFrame:CGRectMake(x+6, 75, 250, 175)];

        [review.layer setCornerRadius:5.0];

        
        
        [review setEditable:NO];
        review.textColor = [UIColor lightGrayColor];
        [reviewView addSubview:review];
        [review release];
        x=x+290;    
        [reviewScrollView addSubview:reviewView];
        [reviewView release];
        reviewView = nil;
    }
    reviewScrollView.clipsToBounds =NO;
    self.reviewScrollView.contentSize = CGSizeMake(x-20, 0);
    x=0;
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidUnload
{
    [self setReviewScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [reviewScrollView release];
    [super dealloc];
}
@end
