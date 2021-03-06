
//  SplashScreenViewController.m
//  PE
//  Created by Nithin George on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import "SplashScreenViewController.h"

@implementation SplashScreenViewController
@synthesize delegate;
@synthesize moviePlayer;

@synthesize skipButton;
@synthesize backgroundImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    DebugLog(@"SplashScreenViewController Dealloc");
    
    if (bannerView_ != nil)
    {
        [bannerView_ release];
        
        bannerView_ =   nil;
    }
    
    if (skipButton != nil)
    {
        self.skipButton =   nil;
    }
    
    if (backgroundImage)
    {
        self.backgroundImage.image  =   nil;
        
        self.backgroundImage        =   nil;
    }
    
    if (moviePlayer != nil)
    {
        if (moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
        {
            [moviePlayer pause];
            
            [moviePlayer setInitialPlaybackTime:-1];
            
            [moviePlayer stop];
            
            if (moviePlayer != nil)
            {
                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:MPMoviePlayerPlaybackDidFinishNotification
                                                              object:moviePlayer];
                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                              object:moviePlayer];
                [moviePlayer.view removeFromSuperview];
                
                [moviePlayer release];
                
                moviePlayer =   nil;
            }
        }
    }
    
    
    [super dealloc];
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
    //[self playMovie];
    [self playAdmob];
    skipButton.selected = NO;
    // Register to receive a notification when the movie has finished playing. 
	    // Do any additional setup after loading the view from its nib.
}

#pragma mark -

/**************************************************************************************
 *  Method Name    : playMovie
 *  Purpose        : to start playing movie
 *  Parameters     : localMovieName, localDirectory
 *  Return Value   : void
 **************************************************************************************/

-(void)playMovie{
    		
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"SplashScreen-H264" ofType:@"mp4"];
    if (moviePath)
    {
        movieURL = [NSURL fileURLWithPath:moviePath];
    }
    
    // Initialize a movie player object with the specified URL
	MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
	
    if (mp)	{
		// save the movie player object
		self.moviePlayer = mp;
		[mp release];
		[self.moviePlayer play];
		moviePlayer.view.backgroundColor = [UIColor clearColor];		
		moviePlayer.scalingMode=MPMovieScalingModeFill;
		moviePlayer.controlStyle=MPMovieControlStyleNone;
        moviePlayer.view.frame = CGRectMake(10, 170, 300, 200);
		//moviePlayer.view.center=self.view.center;
		//moviePlayer.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[[self view] addSubview:moviePlayer.view];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification 
                                                   object:moviePlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlaybackStateChanged:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification 
                                                   object:moviePlayer];
	}
    
}

#pragma mark - button click event

- (IBAction)skipButtonClicked:(id)sender {
    
    skipButton.selected = YES;
    
    if (moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
        [moviePlayer pause];
        
        [moviePlayer stop];
    }
}

#pragma mark -
#pragma mark MoviePlayerController delegate
//  Notification called when the movie finished playing.
-(void)moviePlayBackDidFinish:(NSNotification*)notification;
{
    MPMoviePlayerController *player =   [notification object];
    
    if (player == moviePlayer)
    {
        [moviePlayer stop];
    }
}

//  Notification called when the movie playback state changes.
-(void)moviePlaybackStateChanged :(NSNotification *)notification
{
    MPMoviePlayerController *player =   [notification object];
    
    if (player == moviePlayer)
    {
        if (moviePlayer.playbackState == MPMoviePlaybackStateStopped)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerPlaybackDidFinishNotification
                                                          object:moviePlayer];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                          object:moviePlayer];
            
            [moviePlayer pause];
            
            [moviePlayer setInitialPlaybackTime:-1];
            
            [moviePlayer stop];
            
            [moviePlayer setInitialPlaybackTime:-1];
            
            [moviePlayer.view removeFromSuperview];
            
            self.moviePlayer =   nil;           
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(splashMovieCompleted)])
            {
                [self.delegate splashMovieCompleted];
            }
        }
    }
}

-(void)playAdmob{
    
    // Create a view of the standard size at the bottom of the screen.
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                          430,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    activePublisherID = PremierPagePublisherID;
    bannerView_.adUnitID = activePublisherID;
     bannerView_.rootViewController = self;
    //bannerView_.backgroundColor=[UIColor redColor];
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
    [self.view addSubview:bannerView_];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.skipButton =   nil;
    
    self.backgroundImage    =   nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
