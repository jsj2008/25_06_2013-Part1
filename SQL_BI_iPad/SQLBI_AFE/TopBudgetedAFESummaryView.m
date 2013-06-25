//
//  TopBudgetedAFESummaryView.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 04/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopBudgetedAFESummaryView.h"
#import "AFE.h"
#import "ScrubberView.h"

#define BAR_GRAPH_IMAGE_VIEW_TAG_OFFSET 100;
#define LEGAND_SIZE sizeThatFits:CGSizeMake(16, 16)
#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(4,48,483,253)

@interface TopBudgetedAFESummaryView()
{
    float scalefactor;
    ScrubberView *scrubberView;
    NSArray *afeArray;
    
    NSDate *startDate;
    NSDate *endDate;
    
    UIImageView *staticBudget;
    UILabel *staticBudgetLabel;
    UIImageView *staticActual;
    UILabel *staticActualsLabel;
    UIImageView *budgetBarImageView;
    UIImageView *actualbarImageView;
    UIImageView *accrualsbarImageView;
    UILabel *statusLabel;
    UILabel *budgetLabel;
    UILabel *actualsAccuralsLabel;
    
    NSMutableArray *barImageArray;
    
    UIImageView *accuralsLegand;
    
    UILabel *accuralsLabel;
    UIPopoverController* aPopover;
    
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
    
}

@property (strong, nonatomic) IBOutlet UIButton *detailButton;
@property (strong, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *headerDateLabel;
@property(strong, nonatomic) IBOutlet UIImageView *mainBackgroundImageView;
@property(strong, nonatomic) IBOutlet UIImageView *barchartContainer;

@property(strong, nonatomic) NSMutableArray *stackedBarValues; //New For StackedBar From ajeesh

@property (strong, nonatomic) NSMutableArray *graphData;
- (IBAction)showDetailBtnTouched:(id)sender;
-(void)drawBarChartWithAFEArray:(NSMutableArray *)modelArray;

@end

@implementation TopBudgetedAFESummaryView
@synthesize detailButton,headerDateLabel,graphData, headerTitleLabel, barchartContainer;
@synthesize delegate,mainBackgroundImageView;
@synthesize stackedBarValues;

- (id)initWithFrame:(CGRect)frame
{
    self = (TopBudgetedAFESummaryView*) [[[NSBundle mainBundle] loadNibNamed:@"TopBudgetedAFESummaryView" owner:self options:nil] lastObject];
    if (self) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
    return self;
}

-(void) awakeFromNib
{
    self.headerTitleLabel.font = FONT_SUMMARY_HEADER_TITLE;
    [self.headerTitleLabel setTextColor:COLOR_HEADER_TITLE];
    self.headerDateLabel.font = FONT_SUMMARY_DATE;
    [self.headerDateLabel setTextColor:COLOR_DASHBORD_DATE];
    
    
    //New for Stacked bar chart from Ajeesh
    self.stackedBarValues = [[NSMutableArray alloc] init];
     
}

-(void)drawBarChartWithAFEArray:(NSMutableArray *)modelArray{
    
    for (UIView *view in barchartContainer.subviews) 
    {
        [view performSelector:@selector(removeFromSuperview)];
    }
    if(barImageArray && [barImageArray count])
    {
        for (UIImageView *imgV in barImageArray) {
            [imgV removeFromSuperview];
        }
    }
    if(modelArray)
        self.graphData = modelArray;
    else 
    {
        return;
    }
    scalefactor = 1;
    scalefactor = [self getScalingFactor];
    //NSLog(@"Scaling factor %f",scalefactor);
    
    int legandLabelXCor = 375;
    
    if(!scalefactor)
        scalefactor = 1.0;
    if(!staticBudget)
        staticBudget = [[UIImageView alloc]initWithFrame:CGRectMake(353, 130, 16, 16)];
    else 
        [staticBudget removeFromSuperview];
    [staticBudget LEGAND_SIZE];
    [staticBudget setImage:[UIImage imageNamed:@"bluebar"]];
    [barchartContainer addSubview:staticBudget];
    staticBudget = nil;
    
    if(!staticBudgetLabel)
        staticBudgetLabel = [[UILabel alloc]initWithFrame:CGRectMake(legandLabelXCor, 130, 100, 16)];
    else
        [staticBudgetLabel removeFromSuperview];
    [staticBudgetLabel setText:@"AFE Estimate"];
    [staticBudgetLabel setFont:FONT_SUMMARY_VIEW_BARCHART];
    [staticBudgetLabel setBackgroundColor:[UIColor clearColor]];
    [staticBudgetLabel setTextColor:[Utility getUIColorWithHexString:@"1b2b40"]];
    [barchartContainer addSubview:staticBudgetLabel];
    staticBudgetLabel = nil;
    
    if(!accuralsLegand)
        accuralsLegand = [[UIImageView alloc]initWithFrame:CGRectMake(353, 150, 16, 16)];
    else
        [accuralsLegand removeFromSuperview];
    [accuralsLegand LEGAND_SIZE];
    [accuralsLegand setImage:[UIImage imageNamed:@"yellowbar"]];
    [barchartContainer addSubview:accuralsLegand];
    accuralsLegand = nil;
    
    if(!accuralsLabel)
        accuralsLabel = [[UILabel alloc]initWithFrame:CGRectMake(legandLabelXCor, 150, 100, 16)];
    else
        [accuralsLabel removeFromSuperview];
    [accuralsLabel setText:@"Accruals"];
    [accuralsLabel setTextColor:[Utility getUIColorWithHexString:@"1b2b40"]];
    [accuralsLabel setFont:FONT_SUMMARY_VIEW_BARCHART];
    [accuralsLabel setBackgroundColor:[UIColor clearColor]];
    [barchartContainer addSubview:accuralsLabel];
    accuralsLabel = nil;
    
    
    if(!staticActual)
        staticActual = [[UIImageView alloc]initWithFrame:CGRectMake(353, 170, 16, 16)];
    else
        [staticActual removeFromSuperview];
    [staticActual LEGAND_SIZE];
    [staticActual sizeThatFits:CGSizeMake(16,16)];
    [staticActual setImage:[UIImage imageNamed:@"redbar"]];
    [barchartContainer addSubview:staticActual];
    staticActual = nil;
    
    if(!staticActualsLabel)
        staticActualsLabel = [[UILabel alloc]initWithFrame:CGRectMake(legandLabelXCor, 170, 100, 16)];
    else 
        [staticActualsLabel removeFromSuperview];
    [staticActualsLabel setText:@"Actuals"];
    [staticActualsLabel setTextColor:[Utility getUIColorWithHexString:@"1b2b40"]];
    [staticActualsLabel setFont:FONT_SUMMARY_VIEW_BARCHART];
    [staticActualsLabel setBackgroundColor:[UIColor clearColor]];
    [barchartContainer addSubview:staticActualsLabel];
    staticActualsLabel = nil;
   
    
    int frameOffSet = 5;
    int tag =0;
    int i =0;
    if(!barImageArray)
        barImageArray = [[NSMutableArray alloc]init];    
    else
        [barImageArray removeAllObjects];
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"budget" ascending:NO] ;
    NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor]; 
    self.graphData = (NSMutableArray *)[self.graphData sortedArrayUsingDescriptors:descriptors];

    for(i = 0; i < 4; i++)
    {
            AFE *afeObj;
            if(i < [self.graphData count])
                afeObj = [self.graphData objectAtIndex:i];
            else
                afeObj = [[AFE alloc] init];

        

            CGRect mainFrame = CGRectMake(9, 23+frameOffSet, 2, 20);
            if(!budgetBarImageView)
                budgetBarImageView = [[UIImageView alloc]initWithFrame:mainFrame];
            else
                [budgetBarImageView removeFromSuperview];
        
        
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                         action:@selector(handleTap:)];
            recognizer.numberOfTapsRequired = 1;
            recognizer.delegate = self;
            budgetBarImageView.userInteractionEnabled = YES;
            budgetBarImageView.image = [UIImage imageNamed:@"bluebar"];
            budgetBarImageView.tag = tag+BAR_GRAPH_IMAGE_VIEW_TAG_OFFSET;
            
            tag+=1;
            [budgetBarImageView addGestureRecognizer:recognizer];
            [barchartContainer addSubview:budgetBarImageView];
            [barchartContainer bringSubviewToFront:budgetBarImageView];
            [barImageArray addObject:budgetBarImageView];
            budgetBarImageView = nil;
        
        
            if(!accrualsbarImageView)
                accrualsbarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(9, 43+frameOffSet, 2, 13)];
            else
                [accrualsbarImageView removeFromSuperview];
            UITapGestureRecognizer *recognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleTap:)];
            recognizer.numberOfTapsRequired = 1;
            recognizer.delegate = self;
            CGRect tempFrame = accrualsbarImageView.frame;
            tempFrame.size.width = afeObj.fieldEstimate*scalefactor;
            accrualsbarImageView.frame = tempFrame;
            accrualsbarImageView.userInteractionEnabled = YES;
            [accrualsbarImageView addGestureRecognizer:recognizer3];
            accrualsbarImageView.image = [UIImage imageNamed:@"yellowbar"];
            [barchartContainer addSubview:accrualsbarImageView];
            accrualsbarImageView.tag = tag+BAR_GRAPH_IMAGE_VIEW_TAG_OFFSET;
            tag+=1;
            [barImageArray addObject:accrualsbarImageView];
        
        
            CGRect subFrame = CGRectMake(accrualsbarImageView.frame.origin.x+accrualsbarImageView.frame.size.width+0, 43+frameOffSet, 2, 13);
            if(!actualbarImageView)
                actualbarImageView = [[UIImageView alloc]initWithFrame:subFrame];
            else
                [actualbarImageView removeFromSuperview];
            UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                         action:@selector(handleTap:)];
            recognizer.numberOfTapsRequired = 1;
            recognizer.delegate = self;
            [actualbarImageView addGestureRecognizer:recognizer2];
            actualbarImageView.userInteractionEnabled = YES;
            actualbarImageView.image = [UIImage imageNamed:@"redbar"];
            actualbarImageView.tag = tag+BAR_GRAPH_IMAGE_VIEW_TAG_OFFSET;
            tag+=1;
            [barchartContainer addSubview:actualbarImageView];
            [barImageArray addObject:actualbarImageView];
            
            
            accrualsbarImageView = nil;
            actualbarImageView = nil;
            frameOffSet+=50;
    }
    
    [self addSubview:barchartContainer];
    [UIView animateWithDuration:1
                     animations:^{
                         
                         int j = 0;
                        for (int i =0; i< [barImageArray count]; i+=3) 
                         {
                                AFE *afeObj;
                                 @try 
                                 { 
                                     if(j < [self.graphData count])
                                         afeObj = [self.graphData objectAtIndex:j];
                                     else
                                         afeObj = [[AFE alloc] init];
                                 }
                                 @catch (NSException *exception)
                                 {NSLog(@"Exception");}

                                 UIImageView *imgV = [barImageArray objectAtIndex:i];
                                 CGRect tempFrame = imgV.frame;
                                 //NSLog(@"%f",afeObj.budget);
                                 tempFrame.size.width = afeObj.budget*scalefactor;
                                 if(2 >= tempFrame.size.width)
                                     tempFrame.size.width = 2;
                                 //NSLog(@"%f Applay scaling %f   Act %f ",scalefactor ,afeObj.budget*scalefactor,afeObj.budget);
                                 imgV.frame = tempFrame;
                             
                             j++;

                         }
                         
                         j=0;
                         for (int i = 1; i< [barImageArray count]; i+=3)
                         {
                             UIImageView *tmp;
                             AFE *afeObj = [[AFE alloc]init];
                             @try
                             {
                                 if(j < [self.graphData count])
                                     afeObj = [self.graphData objectAtIndex:j];
                                 else
                                     afeObj = [[AFE alloc] init];
                                 
                                 tmp = [barImageArray objectAtIndex:i-1];
                             }
                             @catch (NSException *exception)
                             {NSLog(@"Exception");}
                             UIImageView *imgV = [barImageArray objectAtIndex:i];
                             CGRect tempFrame = imgV.frame;
                             
                             
                             
                             //tempFrame.origin.x = tmp.frame.origin.x+tmp.frame.size.width+0;
                             tempFrame.size.width = afeObj.fieldEstimate*scalefactor;
                             if(2 >= tempFrame.size.width)
                                 tempFrame.size.width = 2;
                             //NSLog(@"%f Applay scaling %f   Act %f ",scalefactor ,afeObj.fieldEstimate*scalefactor,afeObj.fieldEstimate);
                             imgV.frame = tempFrame;
                             
                             j++;
                         }
                         
                         j = 0;
                         for (int i =2; i<= [barImageArray count]; i+=3)
                         {
                             AFE *afeObj = [[AFE alloc]init];
                             @try 
                             { 
                                if(j < [self.graphData count])
                                    afeObj = [self.graphData objectAtIndex:j];
                                 else
                                     afeObj = [[AFE alloc] init];
                             }
                             @catch (NSException *exception) 
                             {NSLog(@"Exception");}
                             
                             UIImageView *imgV = [barImageArray objectAtIndex:i];
                             CGRect tempFrame = imgV.frame;
                             tempFrame.size.width = afeObj.actual*scalefactor;
                             if(2 >= tempFrame.size.width)
                                 tempFrame.size.width = 2;
                             //NSLog(@"%f Applay Orange scaling %f   Act %f ",scalefactor ,afeObj.actual*scalefactor,afeObj.actual);
                             
                             imgV.frame = tempFrame;
                             
                             j++;
                         }
                         
                         
                         j = 0;
                         
                       
                         
                         
                         
                         
                     }
                     completion:^(BOOL finished)
                     {
                         int j = 0 ;
                         AFE *afeObj;
                         for (UIImageView *barImgeView in barImageArray) 
                         {
                              if(barImgeView.tag >=100)
                             {
                                 barImgeView.tag = barImgeView.tag - BAR_GRAPH_IMAGE_VIEW_TAG_OFFSET;
                                 @try 
                                 {

                                     if(barImgeView.tag != 0 && barImgeView.tag%3 == 0)
                                     {
                                         j++;
                                     }

                                     if(j < [self.graphData count]) 
                                         afeObj = [self.graphData objectAtIndex:j];
                                     else
                                         afeObj = [[AFE alloc] init];
                                         
                                     
                                }
                                 @catch (NSException *exception) 
                                 {
                                     NSLog(@"Exception");
                                 }
                                 int yOffSet = 17;

                                 if(barImgeView.tag%3 == 0)
                                 {
                                     if(!statusLabel)
                                         statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, barImgeView.frame.origin.y-yOffSet, 300, 20)];
                                     else
                                         [statusLabel removeFromSuperview];
                                     statusLabel.text = afeObj.afeNumber;
                                     statusLabel.textColor = [UIColor blackColor];
                                     [statusLabel setFont:FONT_SUMMARY_VIEW_BARCHART];
                                     statusLabel.backgroundColor = [UIColor clearColor];
                                     statusLabel.textAlignment = UITextAlignmentLeft;
                                     [barchartContainer addSubview:statusLabel];
                                     
                                     CGRect tempFrame = barImgeView.frame;
                                     tempFrame.origin.x = barImgeView.frame.size.width+11;
                                     //tempFrame.origin.y-=2; 
                                     if(!budgetLabel)
                                         budgetLabel = [[UILabel alloc]initWithFrame:tempFrame];
                                     else
                                         [budgetLabel removeFromSuperview];
                                    if(2 <= budgetLabel.frame.size.width)
                                        budgetLabel.frame = CGRectMake(budgetLabel.frame.origin.x, budgetLabel.frame.origin.y, 100, budgetLabel.frame.size.height);
                                     budgetLabel.text =[NSString stringWithFormat:@"%@",afeObj.budgetAsStr];
                                     [budgetLabel setTextColor:[UIColor blackColor]];
                                     [budgetLabel setFont:FONT_SUMMARY_VIEW_BARCHART];
                                     budgetLabel.backgroundColor=[UIColor clearColor];
                                        budgetLabel.textAlignment = UITextAlignmentLeft;

                                     if(barchartContainer.frame.size.width - barImgeView.frame.size.width+10<[budgetLabel.text sizeWithFont:budgetLabel.font].width)
                                     {
                                         budgetLabel.lineBreakMode = UILineBreakModeTailTruncation;
                                     }
                                     budgetLabel.textAlignment = UITextAlignmentLeft;
                                     [barchartContainer addSubview:budgetLabel];
                                    [barchartContainer bringSubviewToFront:budgetLabel];
                                     statusLabel = nil;
                                     budgetLabel = nil;
                                 }
                                 if(barImgeView.tag %3 ==2)
                                 {
                                   CGRect tempFrame = CGRectMake(barImgeView.frame.origin.x+barImgeView.frame.size.width+5, barImgeView.frame.origin.y-8, 200, 30);
                                     
                                     
                                     if(!actualsAccuralsLabel)
                                         actualsAccuralsLabel = [[UILabel alloc]initWithFrame:tempFrame];
                                     else
                                         [actualsAccuralsLabel removeFromSuperview];
                                     actualsAccuralsLabel.text =[NSString stringWithFormat:@"%@",afeObj.actualPlusAccrualAsStr];
                                     if(2 <= actualsAccuralsLabel.frame.size.width)
                                     actualsAccuralsLabel.frame = CGRectMake(actualsAccuralsLabel.frame.origin.x, actualsAccuralsLabel.frame.origin.y+8, 80, 15);
                                     [actualsAccuralsLabel setTextColor:[UIColor blackColor]];
                                     [actualsAccuralsLabel setFont:FONT_SUMMARY_VIEW_BARCHART];
                                     [actualsAccuralsLabel setBackgroundColor:[UIColor clearColor]];
                                     if(barchartContainer.frame.size.width - barImgeView.frame.size.width+10<[actualsAccuralsLabel.text sizeWithFont:actualsAccuralsLabel.font].width)
                                     {
                                         actualsAccuralsLabel.lineBreakMode = UILineBreakModeTailTruncation;
                                     }
                                     
                                     actualsAccuralsLabel.textAlignment = UITextAlignmentLeft;
                                     [barchartContainer addSubview:actualsAccuralsLabel];
                                     [barchartContainer bringSubviewToFront:actualsAccuralsLabel];
                                     
                                     statusLabel = nil;
                                     actualsAccuralsLabel = nil;
                                     
                                 }
                                     
                             }
                         }
                     }];

}



-(float) getScalingFactor
{
    NSMutableArray *budgetActualArray = [[NSMutableArray alloc]init];

    for (AFE *afeObj in self.graphData) 
    {

        if([afeObj isKindOfClass:[AFE class]])
        {
            [budgetActualArray addObject:[NSNumber numberWithFloat:afeObj.budget]];
            [budgetActualArray addObject:[NSNumber numberWithFloat:afeObj.actual]];
            [budgetActualArray addObject:[NSNumber numberWithFloat:afeObj.actualPlusAccrual]];
        }

    }    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    budgetActualArray = (NSMutableArray *) [budgetActualArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    if(budgetActualArray && [budgetActualArray count])
    {
        if([[budgetActualArray objectAtIndex:0] doubleValue] > 170)
        {
            return 285.00/[[budgetActualArray objectAtIndex:0] doubleValue];
        }
        else if([[budgetActualArray objectAtIndex:0] doubleValue]<=20.0)
            return 15;
            
    }
    budgetActualArray = nil;
    sortDescriptor = nil;
    return 0.0;
    
}

-(void) createScrubberView
{
    
    if(!scrubberView)
    {
        scrubberView = [[ScrubberView alloc] initWithFrame:CGRectMake(18, 273, 457, 13)];
    }
    else
        [scrubberView removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setObject:startDate?startDate:[NSDate dateWithTimeInterval:-3600*24*20 sinceDate:[NSDate date]] forKey:@"AFEStartDate"];
    [[NSUserDefaults standardUserDefaults] setObject:endDate?endDate:[NSDate dateWithTimeInterval:-3600*24*10 sinceDate:[NSDate date]] forKey:@"AFEEndDate"];
    
    [scrubberView reloadScrubberFromStartDateKey:@"AFEStartDate" andEndDateKey:@"AFEEndDate" forMaximumEndDateOfAvailableRange:[NSDate date] andMaximumDaysAllowedInGraphDateRange:30];
    
    [self addSubview:scrubberView];

}


-(void) refreshBarChartWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    afeArray = afeArrayToUse;
    startDate = start;
    endDate = end;
    self.headerDateLabel.text = (startDate && endDate)? [NSString stringWithFormat:@"%@ - %@",[Utility getStringFromDate:start],[Utility getStringFromDate:endDate]]:@"";
    
        
    [self drawBarChartWithAFEArray:(NSMutableArray*)afeArray];
}

- (IBAction)showDetailBtnTouched:(id)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showDetailViewOfBudgetedAFESummaryView:)])
    {
        [self.delegate showDetailViewOfBudgetedAFESummaryView:self];
    }
    
    
}



-(void) showActivityIndicatorOverlayView
{
    [self removeActivityIndicatorOverlayView];
    
    if(!activityIndicView)
    {
        activityIndicView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else
        [activityIndicView removeFromSuperview];
    
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
    {
        [activityIndicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerView removeFromSuperview];
        
    }
    
    if(!activityIndicBGView)
        activityIndicBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicContainerView.frame.size.width, activityIndicContainerView.frame.size.height)];
    else
        [activityIndicBGView removeFromSuperview];
    
    //Set Styling for all Views
    activityIndicContainerView.backgroundColor = [UIColor clearColor];
    activityIndicBGView.backgroundColor = [UIColor blackColor];
    activityIndicBGView.alpha = 0.1;
    activityIndicBGView.layer.cornerRadius = 5;
    activityIndicView.frame = CGRectMake((activityIndicContainerView.frame.size.width-50)/2, (activityIndicContainerView.frame.size.height-50)/2, 50, 50);
    activityIndicView.color = [UIColor darkGrayColor];
    
    [activityIndicContainerView addSubview:activityIndicBGView];
    [activityIndicContainerView addSubview:activityIndicView];
    [self addSubview:activityIndicContainerView];
    
    [activityIndicView startAnimating];
    
}

-(void) removeActivityIndicatorOverlayView
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(activityIndicView)
        [activityIndicView stopAnimating];
    
}

-(void) showMessageOnView:(NSString*) message
{
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
    {
        [activityIndicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerView removeFromSuperview];
        
    }
    
    if(!messageLabel)
    {
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (activityIndicContainerView.frame.size.height-15)/2, activityIndicContainerView.frame.size.width, 15)];
    }
    
    if(!activityIndicBGView)
        activityIndicBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicContainerView.frame.size.width, activityIndicContainerView.frame.size.height)];
    else
        [activityIndicBGView removeFromSuperview];
    
    //Set Styling for all Views
    activityIndicContainerView.backgroundColor = [UIColor clearColor];
    activityIndicBGView.backgroundColor = [UIColor blackColor];
    activityIndicBGView.alpha = 0.1;
    activityIndicBGView.layer.cornerRadius = 5;
    
    messageLabel.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:15];
    messageLabel.textColor = [UIColor redColor];
    messageLabel.backgroundColor= [UIColor clearColor];
    messageLabel.text = message? message:@"";
    messageLabel.textAlignment = UITextAlignmentCenter;
    
    [activityIndicContainerView addSubview:activityIndicBGView];
    [activityIndicContainerView addSubview:messageLabel];
    [self addSubview:activityIndicContainerView];
    
}

-(void) hideMessageOnView
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(messageLabel)
        messageLabel.text = @"";
}



//New for StackedBarchart from ajeesh
#pragma mark - DELEGATE METHODS


-(NSArray *)valuesForGraph:(id)graph
{
    
    
    return yValuesArray;
    
    
}

-(NSArray *)valuesForXAxis:(id)graph
{
    
    
    return xValuesArray;
}

-(NSArray *)titlesForXAxis:(id)graph
{
    
    
    
    
    return xTitlesArray;
    
}
-(NSDictionary *)barProperties:(id)graph; //barwidth,shadow,horGradient,verticalGradient
{
    return barProperty;
}

-(NSDictionary *)horizontalLinesProperties:(id)graph
{
    if([(MIMBarGraph *)graph tag]==10)
        return [NSDictionary dictionaryWithObjectsAndKeys:@"0,0",@"dotted", nil];
    
    if([(MIMBarGraph *)graph tag]==11)
        return [NSDictionary dictionaryWithObjectsAndKeys:@"0,0",@"dotted", nil];
    
    if([(MIMBarGraph *)graph tag]==12)
        return [NSDictionary dictionaryWithObjectsAndKeys:@"0,0",@"dotted", nil];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:@"1,0",@"dotted", nil];
}


-(UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *a=[[UILabel alloc]initWithFrame:CGRectMake(5, 50, 50, 20)];
    [a setBackgroundColor:[UIColor clearColor]];
    [a setText:text];
    a.numberOfLines=5;
    [a setTextAlignment:UITextAlignmentCenter];
    [a setTextColor:[UIColor redColor]];
    [a setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [a setMinimumFontSize:8];
    return a;
    
}


-(NSDictionary *)animationOnBars:(id)graph
{
    if([(MIMBarGraph *)graph tag]==11)
        return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:BAR_ANIMATION_VGROW_STYLE],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.5],[NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:@"type",@"animationDelay",@"animationDuration",@"transparentBg" ,nil] ];
    
    
    return nil;
}


-(void)setData{
    
    if(self.stackedBarValues)
        [self.stackedBarValues removeAllObjects];
    
    self.stackedBarValues = (NSMutableArray*) afeArray;
    if([afeArray count]){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"budget" ascending:NO];
        self.stackedBarValues = (NSMutableArray *) [self.stackedBarValues sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    
    
    NSArray *myArray =self.stackedBarValues;
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    if([self.stackedBarValues count]){
        int limit;
        if([self.stackedBarValues count] > 4){
            limit = 5;
        }
        else
            limit = [self.stackedBarValues count];
        //[self.treeMapValues removeAllObjects];
        for(int i =  0 ;i < limit;i++){
            [tmpArray addObject:[self.stackedBarValues objectAtIndex:i]];
        }
        self.stackedBarValues = tmpArray;
        NSMutableArray *valuesArray = [[NSMutableArray alloc] init];
        for(int count = 2 ;count < 10 ; count ++){
            AFE *tmpAfe  = (AFE *)[self.stackedBarValues objectAtIndex:(count/2)];
            if(0 == (count % 2)){
                double budget  = tmpAfe.budget;
                [valuesArray addObject:[NSArray arrayWithObjects:@"100",[NSNumber numberWithFloat:budget],nil]]; 
            }
            else{
                double firstPerng = [self getPercentage:tmpAfe.fieldEstimate second:tmpAfe.actual];
                double secondPerng = 100 - firstPerng;
                double total = tmpAfe.fieldEstimate + tmpAfe.actual;
                [valuesArray addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:firstPerng ],[NSNumber numberWithFloat:secondPerng ],[NSNumber numberWithFloat:total],nil]];
                
            }   
            //                  [valuesArray addObject:[NSArray arrayWithObjects:@"%@",@"%@",@"%@",[self getPercentage:tmpAfe.fieldEstimate:tmpAfe.actual],(100 - [self getPercentage:tmpAfe.fieldEstimate:tmpAfe.actual]), tmpAfe.fieldEstimate + tmpAfe.actual],nil]; 
            
        }
        yValuesArray = valuesArray;
    }
    
}

-(double)getPercentage:(double)firstVal second :(double)secondVal{
    
    return ((firstVal/((firstVal+secondVal)/100)));
    
}


-(void)drawStackedBarChart{
    
    [self setData];
    
    xValuesArray=[[NSArray alloc]initWithObjects:[NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr", nil],[NSArray arrayWithObjects:@"May",@"Jun",@"Jul",@"Aug", nil],[NSArray arrayWithObjects: @"Sep",@"Oct",@"Nov",@"Dec", nil],[NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr", nil],[NSArray arrayWithObjects:@"May",@"Jun",@"Jul",@"Aug", nil],[NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr", nil],[NSArray arrayWithObjects:@"May",@"Jun",@"Jul",@"Aug", nil],[NSArray arrayWithObjects: @"Sep",@"Oct",@"Nov",@"Dec", nil],[NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr", nil],[NSArray arrayWithObjects:@"May",@"Jun",@"Jul",@"Aug", nil], nil];
    
    xTitlesArray=[[NSArray alloc]initWithObjects:@"" ,nil];
    barProperty=[[NSDictionary alloc]initWithObjectsAndKeys:@"18",@"barwidth", nil];
    [[NSUserDefaults standardUserDefaults] setInteger:7 forKey:@"GAP_B/W_STACKEDBAR"];
    myBarChart=[[MIMBarGraph alloc]initWithFrame:CGRectMake(-40,10 , 400,400)];
    myBarChart.delegate=self;
    myBarChart.autoresizingMask = UIViewAutoresizingNone;
    //  myBarChart.tag=10+indexPath.row;
    myBarChart.stackedBars=YES;
    myBarChart.isGradient=YES;
    //   myBarChart.
    myBarChart.gradientStyle=HORIZONTAL_GRADIENT_STYLE;
    myBarChart.xTitleStyle=X_TITLES_STYLE1;
    myBarChart.minimumLabelOnYIsZero = YES;
    myBarChart.rightMargin =NO;
    myBarChart.leftMargin = NO;
    [myBarChart drawBarChart];
    myBarChart.transform =CGAffineTransformMakeRotation(1.5707963);
    //    myBarChart.backgroundColor = [UIColor redColor];
    [self addSubview:myBarChart];
    
    
    
    
}


-(void)handleTap:(UITapGestureRecognizer *)sender{
    NSLog(@"Handling tap on ImageView");
    CGPoint touchPoint = [sender locationInView:[sender view]];
    UIView* viewTouched = [[sender view] hitTest:touchPoint withEvent:nil];
    
    switch (viewTouched.tag) {
          
            
        case 0:
        case 1:
        case 2:{
            [self setPopOver:0 frame:viewTouched.frame arrowDir:0];
            break;
        }
        case 3:
        case 4:
        case 5:{
            [self setPopOver:1 frame:viewTouched.frame arrowDir:0];

            break;
        }
        case 6:
        case 7:
        case 8:{
            [self setPopOver:2 frame:viewTouched.frame arrowDir:0];

            break;
        }
        case 9:
        case 10:
        case 11:{
          //  CGRect tempFrame = CGRectMake(viewTouched.frame.origin.x, viewTouched.frame.origin.y - 90, viewTouched.frame.size.width, viewTouched.frame.size.height);
            [self setPopOver:3 frame:viewTouched.frame arrowDir:1];

            break;
        }

        default:{
            break;
        }
           
    }
}

-(void)setPopOver : (int)Tag frame :(CGRect)rect arrowDir:(int)arrowDirection{
    
    if(self.graphData && (Tag < self.graphData.count))
    {
        AFE *tmpAfe = (AFE*)[self.graphData objectAtIndex:Tag];
        
        if(!tmpAfe)
            return;
        
        UIView *contianerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 50)];
        contianerV.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *afeEstimateLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,0,100,20)];
        afeEstimateLbl.text = @"AFE Estimate  :";
        [afeEstimateLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        afeEstimateLbl.backgroundColor = [UIColor clearColor];
        afeEstimateLbl.textColor = [UIColor whiteColor];
        afeEstimateLbl.textAlignment = UITextAlignmentLeft;
        afeEstimateLbl.font = FONT_SUMMARY_DATE;
        afeEstimateLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:afeEstimateLbl];
        
        UILabel *afeEstimateValLbl = [[UILabel alloc] initWithFrame:CGRectMake(110,0,100,20)];
        afeEstimateValLbl.text = tmpAfe.budgetAsStr? tmpAfe.budgetAsStr:@"";
        afeEstimateValLbl.backgroundColor = [UIColor clearColor];
        afeEstimateValLbl.textAlignment = UITextAlignmentLeft;
        afeEstimateValLbl.font = FONT_SUMMARY_DATE;
        afeEstimateValLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:afeEstimateValLbl];
        
        
        UILabel *actualLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,20,100,20)];
        actualLbl.text = @"Actuals           :";
        [actualLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        actualLbl.backgroundColor = [UIColor clearColor];
        actualLbl.textColor = [UIColor whiteColor];
        actualLbl.textAlignment = UITextAlignmentLeft;
        actualLbl.font = FONT_SUMMARY_DATE;
        actualLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:actualLbl];
        
        UILabel *actualValLbl = [[UILabel alloc] initWithFrame:CGRectMake(110,20,100,20)];
        actualValLbl.text = tmpAfe.actualsAsStr? tmpAfe.actualsAsStr:@"";
        actualValLbl.backgroundColor = [UIColor clearColor];
        actualValLbl.textAlignment = UITextAlignmentLeft;
        actualValLbl.font = FONT_SUMMARY_DATE;
        actualValLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:actualValLbl];
        
        UILabel *accrualLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,40,100,20)];
        accrualLbl.text = @"Accruals         : ";
        [accrualLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        accrualLbl.backgroundColor = [UIColor clearColor];
        accrualLbl.textColor = [UIColor whiteColor];
        accrualLbl.textAlignment = UITextAlignmentLeft;
        accrualLbl.font = FONT_SUMMARY_DATE;
        accrualLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:accrualLbl];
        
        UILabel *accrualLblValLbl = [[UILabel alloc] initWithFrame:CGRectMake(110,40,100,20)];
        accrualLblValLbl.text = tmpAfe.fieldEstimateAsStr? tmpAfe.fieldEstimateAsStr:@"";
        accrualLblValLbl.backgroundColor = [UIColor clearColor];
        accrualLblValLbl.textAlignment = UITextAlignmentLeft;
        accrualLblValLbl.font = FONT_SUMMARY_DATE;
        accrualLblValLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:accrualLblValLbl];
        
        UILabel *totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,60,100,20)];
        totalLbl.text = @"Total                : ";
        [totalLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        totalLbl.backgroundColor = [UIColor clearColor];
        totalLbl.textColor = [UIColor whiteColor];
        totalLbl.textAlignment = UITextAlignmentLeft;
        totalLbl.font = FONT_SUMMARY_DATE;
        totalLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:totalLbl];
        
        UILabel *totalValLbl = [[UILabel alloc] initWithFrame:CGRectMake(110,60,100,20)];
        //double totalVal = tmpAfe.budget + tmpAfe.actual;
        totalValLbl.text = tmpAfe.actualPlusAccrualAsStr? tmpAfe.actualPlusAccrualAsStr:@"";
        totalValLbl.backgroundColor = [UIColor clearColor];
        totalValLbl.textAlignment = UITextAlignmentLeft;
        totalValLbl.font = FONT_SUMMARY_DATE;
        totalValLbl.textColor = [Utility getUIColorWithHexString:@"1b2128"];
        [contianerV addSubview:totalValLbl];
        
        UIViewController* controller = [[UIViewController alloc] init] ;
        controller.view = contianerV;
        aPopover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [aPopover setDelegate:self];
        [aPopover setPopoverContentSize:CGSizeMake(230, 80) animated:YES];
        
        
        if(arrowDirection)
            [aPopover presentPopoverFromRect:CGRectMake(rect.origin.x+100,rect.origin.y+75,100,100) inView:self permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        else {
            [aPopover presentPopoverFromRect:CGRectMake(rect.origin.x + 100,rect.origin.y - 25,100,100) inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }   
    }

}

- (void)dealloc{
    
    self.graphData = nil;
    afeArray = nil;
    scrubberView = nil;
    startDate = nil;
    endDate = nil;
    self.delegate = nil;
    
}

@end
