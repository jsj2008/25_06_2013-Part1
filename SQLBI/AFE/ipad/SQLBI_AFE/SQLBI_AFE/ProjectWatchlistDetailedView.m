//
//  ProjectWatchlistDetailedView.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProjectWatchlistDetailedView.h"
#import <QuartzCore/QuartzCore.h>
#import "AFE.h"
#import "AppDelegate.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW_HeatMap CGRectMake(15,73,325,472)

@interface  ProjectWatchlistDetailedView(){
    float width;
    float height;
    float xPos;
    float yPos;
    NSDate *startDate;
    NSDate *endDate;
    ProjectWatchListAFETableView *wathclistAFETableView;

    UIActivityIndicatorView *activityIndicViewHeatMap;
    UIView *activityIndicContainerViewHeatMap;
    UIView *activityIndicBGViewHeatMap;
    UILabel *messageLabelHeatMap;
    
    int currentPageShown;
    int totalNoPagesAvailable;
    
}
@property(strong, nonatomic) IBOutlet UIButton *feldEstmtButton;
@property(strong, nonatomic) IBOutlet UIButton *actualsButton;
@property(strong, nonatomic)  UIButton *backGrndBtn;
@property(nonatomic, assign) CGRect actualSizeTRemember;
@property(nonatomic, strong) NSMutableArray *treeMapValues;
//@property(nonatomic, strong) NSMutableArray *afeArray;
@property(nonatomic, strong) NSMutableArray *afeArray_HeatMap;
@property(nonatomic, strong) NSMutableArray *afeArray_Table;
@property(nonatomic,assign)  BOOL IsActualBtnClicked;


-(IBAction)feldEstmtBtnTouched;
-(IBAction)actualsBtnTouched;
-(void)drawTreeGraph;
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;

@end

@implementation ProjectWatchlistDetailedView
@synthesize treeMapV,treeMapAnmtnCell,backgroundView;
@synthesize actualSizeTRemember,treeMapValues;
@synthesize feldEstmtButton,actualsButton;
//@synthesize afeArray;
@synthesize afeArray_Table, afeArray_HeatMap;
@synthesize IsActualBtnClicked,swipeDelegate, delegate;
@synthesize backGrndBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = (ProjectWatchlistDetailedView*) [[[NSBundle mainBundle] loadNibNamed:@"ProjectWatchlistDetailedView" owner:self options:nil] lastObject];
    if (self) {
            // Initialization code
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
        
    }
    return self;
}
-(void) awakeFromNib
{
    self.treeMapValues = [[NSMutableArray alloc] init];

    [self setCustomFontForButton:self.feldEstmtButton];
    [self setCustomFontForButton:self.actualsButton];
    [self.feldEstmtButton setSelected:YES];
    
    self.feldEstmtButton.hidden = YES;
    self.actualsButton.hidden = YES;    
    
    [self createAFETableView];
}

-(void) createAFETableView
{
    if(!wathclistAFETableView)
        wathclistAFETableView = [[ProjectWatchListAFETableView alloc]initWithFrame:CGRectMake(351, 78, 570, 462)];
    else
        [wathclistAFETableView removeFromSuperview];
    
    wathclistAFETableView.delegate = self;
    [self addSubview:wathclistAFETableView];
    [wathclistAFETableView refreshTableWithAFEArray:afeArray_Table forPage:currentPageShown ofTotalPages:totalNoPagesAvailable];
}

-(void) refreshTableWithAFEArray:(NSArray*) afeArrayToUse forPage:(int) page ofTotalPages:(int) totalPages  andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    startDate  = start;
    endDate   = end;
    self.afeArray_Table = (NSMutableArray *)afeArrayToUse;
    currentPageShown = page;
    totalNoPagesAvailable = totalPages;
    
    [self createAFETableView];
    
    [Utility removeLeftSwipeGestureFromViewsRecursively:self];
    [Utility removeRightSwipeGestureFromViewsRecursively:self];
    [Utility addLeftSwipeGestureToViewsRecursively:self  targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
    [Utility addRightSwipeGestureToViewsRecursively:self  targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
}

-(void) refreshHeatMapWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    startDate  = start;
    endDate   = end;
    self.afeArray_HeatMap = (NSMutableArray *)afeArrayToUse;
    [[NSUserDefaults standardUserDefaults] setInteger:315 forKey:@"TREEMAP_WIDTH"];
    [[NSUserDefaults standardUserDefaults] setInteger:462 forKey:@"TREEMAP_HEIGHT"];
    self.treeMapValues = [[NSMutableArray alloc] init];
    //[self sortArray];
    [self drawTreeGraph];
    
    [Utility removeLeftSwipeGestureFromViewsRecursively:self];
    [Utility removeRightSwipeGestureFromViewsRecursively:self];
    [Utility addLeftSwipeGestureToViewsRecursively:self  targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
    [Utility addRightSwipeGestureToViewsRecursively:self  targetDelegate:self handleSelector:@selector(handleSwipeFrom:)];
}

-(void) showActivityIndicatorOverlayViewOnHeatMap
{
    [self removeActivityIndicatorOverlayViewOnHeatMap];
    
    if(!activityIndicViewHeatMap)
    {
        activityIndicViewHeatMap = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else
        [activityIndicViewHeatMap removeFromSuperview];
    
    if(!activityIndicContainerViewHeatMap)
        activityIndicContainerViewHeatMap = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW_HeatMap];
    else
    {
        [activityIndicContainerViewHeatMap.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerViewHeatMap removeFromSuperview];
        
    }
    
    if(!activityIndicBGViewHeatMap)
        activityIndicBGViewHeatMap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicContainerViewHeatMap.frame.size.width, activityIndicContainerViewHeatMap.frame.size.height)];
    else
        [activityIndicBGViewHeatMap removeFromSuperview];
    
    //Set Styling for all Views
    activityIndicContainerViewHeatMap.backgroundColor = [UIColor clearColor];
    activityIndicBGViewHeatMap.backgroundColor = [UIColor blackColor];
    activityIndicBGViewHeatMap.alpha = 0.1;
    activityIndicBGViewHeatMap.layer.cornerRadius = 5;
    activityIndicViewHeatMap.frame = CGRectMake((activityIndicContainerViewHeatMap.frame.size.width-50)/2, (activityIndicContainerViewHeatMap.frame.size.height-50)/2, 50, 50);
    activityIndicViewHeatMap.color = [UIColor darkGrayColor];
    
    [activityIndicContainerViewHeatMap addSubview:activityIndicBGViewHeatMap];
    [activityIndicContainerViewHeatMap addSubview:activityIndicViewHeatMap];
    [self addSubview:activityIndicContainerViewHeatMap];
    
    [activityIndicViewHeatMap startAnimating];
    
}

-(void) removeActivityIndicatorOverlayViewOnHeatMap
{
    if(activityIndicContainerViewHeatMap)
        [activityIndicContainerViewHeatMap removeFromSuperview];
    
    if(activityIndicViewHeatMap)
        [activityIndicViewHeatMap stopAnimating];
    
}

-(void) showMessageOnHeatMap:(NSString*) message
{
    if(!activityIndicContainerViewHeatMap)
        activityIndicContainerViewHeatMap = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW_HeatMap];
    else
    {
        [activityIndicContainerViewHeatMap.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerViewHeatMap removeFromSuperview];
        
    }
    
    if(!messageLabelHeatMap)
    {
        messageLabelHeatMap = [[UILabel alloc] initWithFrame:CGRectMake(0, (activityIndicContainerViewHeatMap.frame.size.height-15)/2, activityIndicContainerViewHeatMap.frame.size.width, 15)];
    }
    
    if(!activityIndicBGViewHeatMap)
        activityIndicBGViewHeatMap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicContainerViewHeatMap.frame.size.width, activityIndicContainerViewHeatMap.frame.size.height)];
    else
        [activityIndicBGViewHeatMap removeFromSuperview];
    
    //Set Styling for all Views
    activityIndicContainerViewHeatMap.backgroundColor = [UIColor clearColor];
    activityIndicBGViewHeatMap.backgroundColor = [UIColor blackColor];
    activityIndicBGViewHeatMap.alpha = 0.1;
    activityIndicBGViewHeatMap.layer.cornerRadius = 5;
    
    messageLabelHeatMap.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:15];
    messageLabelHeatMap.textColor = [UIColor redColor];
    messageLabelHeatMap.backgroundColor= [UIColor clearColor];
    messageLabelHeatMap.text = message? message:@"";
    messageLabelHeatMap.textAlignment = UITextAlignmentCenter;
    
    [activityIndicContainerViewHeatMap addSubview:activityIndicBGViewHeatMap];
    [activityIndicContainerViewHeatMap addSubview:messageLabelHeatMap];
    [self addSubview:activityIndicContainerViewHeatMap];
    
}

-(void) hideMessageOnHeatMap
{
    if(activityIndicContainerViewHeatMap)
        [activityIndicContainerViewHeatMap removeFromSuperview];
    
    if(messageLabelHeatMap)
        messageLabelHeatMap.text = @"";
}


-(void) showActivityIndicatorOverlayViewOnTable
{
    if(wathclistAFETableView)
        [wathclistAFETableView showActivityIndicatorOverlayView];
}

-(void) removeActivityIndicatorOverlayViewOnTable
{
    if(wathclistAFETableView)
        [wathclistAFETableView removeActivityIndicatorOverlayView];
}

-(void) showMessageOnTable:(NSString*) message
{
    if(wathclistAFETableView)
        [wathclistAFETableView showMessageOnView:message];
}

-(void) hideMessageOnTable
{
    if(wathclistAFETableView)
        [wathclistAFETableView hideMessageOnView];
}



-(void)drawTreeGraph{
    [self setData];
    treeMapV.delegate = self;
    treeMapV.dataSource = self;
    for (UIView *view in treeMapV.subviews) 
        {
        [view performSelector:@selector(removeFromSuperview)];
        }
    
    
        //[treeMapV.subviews respondsToSelector:@selector(removeFromSuperview)];
    [self.treeMapV reloadData];
}

-(void)setData{
    [self.treeMapValues removeAllObjects];
    
    AFE *tempAFE = [[AFE alloc] init];
    if([self.afeArray_HeatMap count]){
        
        int count = [self.afeArray_HeatMap count];
        if(4 < count)
            count = 5;
        for(int i = 0; i< count; i++){
            tempAFE = (AFE*)[self.afeArray_HeatMap objectAtIndex:i];
            NSNumber *num;
                // if(IsActualBtnClicked)
                //   num = [NSNumber numberWithFloat:tempAFE.actual];
                //else
            num = [NSNumber numberWithFloat:tempAFE.percntgConsmptn];
            NSLog(@"%@",num);
            
            if(num == NULL || [num isKindOfClass:[NSNull class]])
                {
                NSLog(@"Is NUll");
                }
            
            [self.treeMapValues addObject:num];
        }
    }

    
}

-(void)sortArray{
    //NSLog(@"%@",self.afeArray_HeatMap);
        NSString *sortDescrptr = @"percntgConsmptn";
        //if(IsActualBtnClicked)
        // sortDescrptr = @"percntgConsmptn";
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortDescrptr ascending:NO];
    self.afeArray_HeatMap = (NSMutableArray *) [self.afeArray_HeatMap sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
   // NSLog(@"%@",self.afeArray);
    
    
    
}

-(void)draWTreeMapWith:(NSArray*)graphValue drawType:(TreeGraphDrawType)type{

    treeMapV.delegate = self;
    treeMapV.dataSource = self;
    [self.treeMapV reloadData];

}

#pragma mark -
- (void)updateCell:(TreemapViewCell *)cell forIndex:(NSInteger)index {
    switch (index) {
        case 0:
            cell.backgroundColor =  [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];            break;            
        case 1:
            cell.backgroundColor =  [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];            break;  
        case 2:
            cell.backgroundColor =  [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];            break;  
        case 3:
            cell.backgroundColor =  [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1];            break;  
        case 4:
            cell.backgroundColor =  [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1];            break;  
        default:
            cell.backgroundColor =  [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];              break;
            
    }

}
#pragma mark -
#pragma mark TreemapView delegate

- (void)treemapView:(TreemapView *)treemapView tapped:(NSInteger)index {
    
    UIView *tmpView = (UIView*) [self.treeMapV.subviews objectAtIndex:index];
    NSLog(@"frame = %@\n", NSStringFromCGRect(treemapView.frame));
    NSLog(@"tempoView Frame: %@",  NSStringFromCGRect(tmpView.frame));
    self.actualSizeTRemember = CGRectMake(tmpView.frame.origin.x+treemapView.frame.origin.x, tmpView.frame.origin.y+treemapView.frame.origin.y, tmpView.frame.size.width, tmpView.frame.size.height);
        // indexToRemember = index;
    
    width = self.actualSizeTRemember.size.width;
    height = self.actualSizeTRemember.size.height;
    xPos = self.actualSizeTRemember.origin.x;
    yPos = self.actualSizeTRemember.origin.y;
    NSLog(@"tempoView Frame: %@",  NSStringFromCGRect(self.actualSizeTRemember));
        //float width = self.treeMapV.frame.size.width;
    self.backGrndBtn = [[UIButton alloc] initWithFrame:CGRectMake(treemapView.frame.origin.x, treemapView.frame.origin.y, self.treeMapV.frame.size.width , self.treeMapV.frame.size.height)];
    backGrndBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:backGrndBtn];
    self.backgroundView =[[UIView alloc] initWithFrame:CGRectMake(treemapView.frame.origin.x, treemapView.frame.origin.y, self.treeMapV.frame.size.width , self.treeMapV.frame.size.height)];
    
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.6;
    [self addSubview:self.backgroundView];
    
    self.treeMapAnmtnCell = [[TreeMapAnimationCell alloc] initWithFrame:actualSizeTRemember];
    self.treeMapAnmtnCell.backgroundColor = tmpView.backgroundColor;
    self.treeMapAnmtnCell.frame =tmpView.frame;
    self.treeMapAnmtnCell.delegate = self;
    self.treeMapAnmtnCell.frame = actualSizeTRemember;
    self.treeMapAnmtnCell.layer.borderColor = [UIColor whiteColor].CGColor;
    self.treeMapAnmtnCell.layer.borderWidth = 2.0;
    [self addSubview:self.treeMapAnmtnCell];
    NSLog(@"%@",NSStringFromCGRect(self.treeMapV.frame) );
    
    [UIView animateWithDuration:0.4 animations:^{
        self.treeMapAnmtnCell.frame = CGRectMake(treemapView.frame.origin.x+10,treemapView.frame.origin.y+10,self.treeMapV.frame.size.width -20,self.treeMapV.frame.size.height-20);
    }completion:^(BOOL finished){
        [self setLabels:index];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self 
                   action:@selector(btnTouched)
         forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.text = @"Click";
        button.frame =CGRectMake(0,0,self.treeMapV.frame.size.width -20,self.treeMapV.frame.size.height-20);
        [self.treeMapAnmtnCell addSubview:button]; 
        
    }];
}
- (void)btnTouched {
    [self removeAnimatedCell];
}
-(void)setLabels:(NSInteger)index {
    AFE *tempAFE = [[AFE alloc] init];
    tempAFE = (AFE*)[self.afeArray_HeatMap objectAtIndex:index];
    UIView *containerView = [[ UIView alloc ] init];
    containerView.tag = 12345;
    containerView.frame = CGRectMake((self.treeMapV.frame.size.width/2)-100,(self.treeMapV.frame.size.height/2)-60,60,100);
    containerView.backgroundColor = [UIColor clearColor];
    float Xcor = containerView.frame.origin.x-55;
    float Ycor = containerView.frame.origin.y-135-61;
    UILabel *afeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 20+Ycor, 120, 20)];
    afeLbl.text = @"AFE                     : ";
    [afeLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeLbl.backgroundColor = [UIColor clearColor];
    afeLbl.textColor = [UIColor whiteColor];
    afeLbl.textAlignment = UITextAlignmentLeft;
    afeLbl.font = FONT_SUMMARY_DATE;
    afeLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    
    [containerView addSubview:afeLbl];
    
    UILabel *afeNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(100+Xcor, 20+Ycor, 120, 20)];
    afeNumLbl.text = [NSString stringWithFormat:@"%@",tempAFE.afeNumber];
    [afeNumLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeNumLbl.backgroundColor = [UIColor clearColor];
    afeNumLbl.textColor = [UIColor whiteColor];
    afeNumLbl.textAlignment = UITextAlignmentLeft;
    afeNumLbl.font = FONT_SUMMARY_DATE;
    afeNumLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    
    [containerView addSubview:afeNumLbl];
    
    UILabel *afeEstimateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 40+Ycor, 120, 20)];
    afeEstimateLbl.text = @"AFE Estimate      : ";
    [afeEstimateLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeEstimateLbl.backgroundColor = [UIColor clearColor];
    afeEstimateLbl.textColor = [UIColor whiteColor];
    afeEstimateLbl.textAlignment = UITextAlignmentLeft;
    afeEstimateLbl.autoresizingMask = NO;
    afeEstimateLbl.font = FONT_SUMMARY_DATE;
    afeEstimateLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    
    [containerView addSubview:afeEstimateLbl];
    
    UILabel *afeEstmtDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(100+Xcor, 40+Ycor, 120, 20)];
    afeEstmtDataLbl.text = tempAFE.budgetAsStr? tempAFE.budgetAsStr:@""; //[Utility formatNumber:[NSString stringWithFormat:@"%.f",tempAFE.budget]];//[NSString stringWithFormat:@"%.f",tempAFE.budget];
    [afeEstmtDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    afeEstmtDataLbl.backgroundColor = [UIColor clearColor];
    afeEstmtDataLbl.textColor = [UIColor whiteColor];
    afeEstmtDataLbl.textAlignment = UITextAlignmentLeft;
    afeEstmtDataLbl.font = FONT_SUMMARY_DATE;
    afeEstmtDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    
    [containerView addSubview:afeEstmtDataLbl];
    
    UILabel *accrualsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 60+Ycor, 120, 20)];
    accrualsLbl.text = @"Accruals            : ";
    [accrualsLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    accrualsLbl.backgroundColor = [UIColor clearColor];
    accrualsLbl.textColor = [UIColor whiteColor];
    accrualsLbl.textAlignment = UITextAlignmentLeft;
    accrualsLbl.font = FONT_SUMMARY_DATE;
    accrualsLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    
    [containerView addSubview:accrualsLbl];
    
    UILabel *accrualsDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(100+Xcor, 60+Ycor, 100, 20)];
    accrualsDataLbl.text = [Utility formatNumber:tempAFE.fieldEstimateAsStr];//[NSString stringWithFormat:@"%.f",tempAFE.percntgConsmptn];
    [accrualsDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    accrualsDataLbl.backgroundColor = [UIColor clearColor];
    accrualsDataLbl.textColor = [UIColor whiteColor];
    accrualsDataLbl.textAlignment = UITextAlignmentLeft;
    accrualsDataLbl.font = FONT_SUMMARY_DATE;
    accrualsDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [containerView addSubview:accrualsDataLbl];
    
    
    
    UILabel *feldEstimateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 80+Ycor, 120, 20)];
    feldEstimateLbl.text = @"Actuals              : ";
    [feldEstimateLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    feldEstimateLbl.backgroundColor = [UIColor clearColor];
    feldEstimateLbl.textColor = [UIColor whiteColor];
    feldEstimateLbl.textAlignment = UITextAlignmentLeft;
    feldEstimateLbl.font = FONT_SUMMARY_DATE;
    feldEstimateLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    
    [containerView addSubview:feldEstimateLbl];
    
    UILabel *fldEstmtDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(100+Xcor, 80+Ycor, 120, 20)];
    fldEstmtDataLbl.text = tempAFE.fieldEstimateAsStr? tempAFE.actualsAsStr:@"";//[Utility formatNumber:[NSString stringWithFormat:@"%.f",tempAFE.fieldEstimate]];//[NSString stringWithFormat:@"%.f",tempAFE.fieldEstimate];
    [fldEstmtDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    fldEstmtDataLbl.backgroundColor = [UIColor clearColor];
    fldEstmtDataLbl.textColor = [UIColor whiteColor];
    fldEstmtDataLbl.textAlignment = UITextAlignmentLeft;
    fldEstmtDataLbl.font = FONT_SUMMARY_DATE;
    fldEstmtDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [containerView addSubview:fldEstmtDataLbl];
    
    UILabel *totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 100+Ycor, 120, 20)];
    totalLbl.text = @"Total                   : ";
    [totalLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    totalLbl.backgroundColor = [UIColor clearColor];
    totalLbl.textColor = [UIColor whiteColor];
    totalLbl.textAlignment = UITextAlignmentLeft;
    totalLbl.font = FONT_SUMMARY_DATE;
    totalLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [containerView addSubview:totalLbl];
    
   
    UILabel *totalDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(100+Xcor, 100+Ycor, 150, 20)];
   
    totalDataLbl.text = [NSString stringWithFormat:@"%@",tempAFE.actualPlusAccrualAsStr];
    [totalDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    totalDataLbl.backgroundColor = [UIColor clearColor];
    totalDataLbl.textColor = [UIColor whiteColor];
    totalDataLbl.textAlignment = UITextAlignmentLeft;
    totalDataLbl.font = FONT_SUMMARY_DATE;
    totalDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [containerView addSubview:totalDataLbl];
    
    
    UILabel *consmpnLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 120+Ycor, 120, 20)];
    consmpnLbl.text = @"%Consumption : ";
    [consmpnLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    consmpnLbl.backgroundColor = [UIColor clearColor];
    consmpnLbl.textColor = [UIColor whiteColor];
    consmpnLbl.textAlignment = UITextAlignmentLeft;
    consmpnLbl.font = FONT_SUMMARY_DATE;
    consmpnLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    
    [containerView addSubview:consmpnLbl];
    
    UILabel *consmpnDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(100+Xcor, 120+Ycor, 100, 20)];
    consmpnDataLbl.text = [Utility formatNumber:[NSString stringWithFormat:@"%.2f\%%",tempAFE.percntgConsmptn]];//[NSString stringWithFormat:@"%.f",tempAFE.percntgConsmptn];
    [fldEstmtDataLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    consmpnDataLbl.backgroundColor = [UIColor clearColor];
    consmpnDataLbl.textColor = [UIColor whiteColor];
    consmpnDataLbl.textAlignment = UITextAlignmentLeft;
    consmpnDataLbl.font = FONT_SUMMARY_DATE;
    consmpnDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [containerView addSubview:consmpnDataLbl];
    
    
    
    
    [self.treeMapAnmtnCell addSubview:containerView];
//    UILabel *afeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 20+Ycor, 120, 20)];
//    afeLbl.text = @"AFE                    : ";
//    afeLbl.backgroundColor = [UIColor clearColor];
//    afeLbl.textColor = [UIColor whiteColor];
//    afeLbl.textAlignment = UITextAlignmentLeft;
//    afeLbl.font = FONT_SUMMARY_DATE;
//    afeLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
//    [containerView addSubview:afeLbl];
//    
//    UILabel *afeNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(100+Xcor, 20+Ycor, 120, 20)];
//    afeNumLbl.text =[NSString stringWithFormat:@"%@",tempAFE.afeNumber];
//    afeNumLbl.backgroundColor = [UIColor clearColor];
//    afeNumLbl.textColor = [UIColor whiteColor];
//    afeNumLbl.textAlignment = UITextAlignmentLeft;
//    afeNumLbl.font = FONT_SUMMARY_DATE;
//    afeNumLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
//    
//    [containerView addSubview:afeNumLbl];
//    
//    UILabel *afeEstimateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 40+Ycor, 120, 20)];
//    afeEstimateLbl.text = @"AFE Estimate     : ";
//    afeEstimateLbl.backgroundColor = [UIColor clearColor];
//    afeEstimateLbl.textColor = [UIColor whiteColor];
//    afeEstimateLbl.textAlignment = UITextAlignmentLeft;
//    afeEstimateLbl.autoresizingMask = NO;
//    afeEstimateLbl.font = FONT_SUMMARY_DATE;
//    afeEstimateLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
//    
//    [containerView addSubview:afeEstimateLbl];
//    
//    UILabel *afeEstmtDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(100+Xcor, 40+Ycor, 120, 20)];
//    afeEstmtDataLbl.text = tempAFE.budgetAsStr? tempAFE.budgetAsStr:@"";//[Utility formatNumber:[NSString stringWithFormat:@"%.f",tempAFE.budget]];
//    afeEstmtDataLbl.backgroundColor = [UIColor clearColor];
//    afeEstmtDataLbl.textColor = [UIColor whiteColor];
//    afeEstmtDataLbl.textAlignment = UITextAlignmentLeft;
//    afeEstmtDataLbl.font = FONT_SUMMARY_DATE;
//    afeEstmtDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
//    
//    [containerView addSubview:afeEstmtDataLbl];
//    
//    UILabel *feldEstimateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 60+Ycor, 120, 20)];
//    feldEstimateLbl.text = @"Field Estimate   : ";
//    feldEstimateLbl.backgroundColor = [UIColor clearColor];
//    feldEstimateLbl.textColor = [UIColor whiteColor];
//    feldEstimateLbl.textAlignment = UITextAlignmentLeft;
//    feldEstimateLbl.font = FONT_SUMMARY_DATE;
//    feldEstimateLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
//    
//    [containerView addSubview:feldEstimateLbl];
//    
//    UILabel *fldEstmtDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(100+Xcor, 60+Ycor, 120, 20)];
//    fldEstmtDataLbl.text = tempAFE.fieldEstimateAsStr? tempAFE.fieldEstimateAsStr:@"";//[Utility formatNumber:[NSString stringWithFormat:@"%.f",tempAFE.fieldEstimate]];
//    fldEstmtDataLbl.backgroundColor = [UIColor clearColor];
//    fldEstmtDataLbl.textColor = [UIColor whiteColor];
//    fldEstmtDataLbl.textAlignment = UITextAlignmentLeft;
//    fldEstmtDataLbl.font = FONT_SUMMARY_DATE;
//    fldEstmtDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
//    [containerView addSubview:fldEstmtDataLbl];
//    
//    UILabel *consmpnLbl = [[UILabel alloc] initWithFrame:CGRectMake(0+Xcor, 80+Ycor, 120, 20)];
//    consmpnLbl.text = @"%Consumption : ";
//    consmpnLbl.backgroundColor = [UIColor clearColor];
//    consmpnLbl.textColor = [UIColor whiteColor];
//    consmpnLbl.textAlignment = UITextAlignmentLeft;
//    consmpnLbl.font = FONT_SUMMARY_DATE;
//    consmpnLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
//    
//    [containerView addSubview:consmpnLbl];
//    
//    UILabel *consmpnDataLbl = [[UILabel alloc] initWithFrame:CGRectMake(100+Xcor, 80+Ycor, 100, 20)];
//    consmpnDataLbl.text = [Utility formatNumber:[NSString stringWithFormat:@"%.2f\%%",tempAFE.percntgConsmptn]];
//    consmpnDataLbl.backgroundColor = [UIColor clearColor];
//    consmpnDataLbl.textColor = [UIColor whiteColor];
//    consmpnDataLbl.textAlignment = UITextAlignmentLeft;
//    [containerView addSubview:consmpnDataLbl];
//    consmpnDataLbl.font = FONT_SUMMARY_DATE;
//    consmpnDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
//    [self.treeMapAnmtnCell addSubview:containerView];
}


#pragma mark -
#pragma mark TreeMapAnimationCell Delegate
-(void)removeAnimatedCell{
    [self.backgroundView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.backgroundView removeFromSuperview];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:self.treeMapAnmtnCell cache:YES];
    [self addSubview:treeMapAnmtnCell];
    self.treeMapAnmtnCell.frame = self.actualSizeTRemember;
    [UIView setAnimationDidStopSelector:@selector(myAnimationStopped)];
    
    [UIView commitAnimations];
    [self.treeMapAnmtnCell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *ViewTmp = [self.treeMapV viewWithTag:12345];
    if(ViewTmp){
        [ViewTmp removeFromSuperview];
    }
    
}
-(void)myAnimationStopped {
    [self.backgroundView removeFromSuperview];
    [self.treeMapAnmtnCell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.treeMapAnmtnCell removeFromSuperview];
    [self.backGrndBtn removeFromSuperview];
        // [self.treeMapV reloadData];

}

#pragma mark -
#pragma mark TreemapView data source

- (NSArray *)valuesForTreemapView:(TreemapView *)treemapView {
    return self.treeMapValues;
}

- (TreemapViewCell *)treemapView:(TreemapView *)treemapView cellForIndex:(NSInteger)index forRect:(CGRect)rect {
	TreemapViewCell *cell = [[TreemapViewCell alloc] initWithFrame:rect];
    UILabel *fldEstmtDataLbl = [[UILabel alloc] init];
    CGFloat widthLbl = rect.size.width;
    UIView *tmpV = [[UIView alloc] initWithFrame:CGRectMake((rect.size.width/2)-(widthLbl/2),(rect.size.height/2)-10 , widthLbl, 20)];
    tmpV.backgroundColor = [UIColor clearColor];
    [cell addSubview:tmpV];
    fldEstmtDataLbl.frame = CGRectMake(0, 0 , widthLbl, 20);
        // fldEstmtDataLbl.frame = CGRectMake((rect.size.width/2)-(widthLbl/2),(rect.size.height/2)-10 , widthLbl, 20);
        // fldEstmtDataLbl.frame = CGRectMake((rect.size.width/2)-40,(rect.size.height/2)-10 , 80, 20);
    if(rect.size.width < 50){
        fldEstmtDataLbl.frame = CGRectMake(rect.origin.x, (rect.size.height/2)-40,rect.size.width, 20); 
    }
    AFE *tempAFE = [[AFE alloc] init];
    tempAFE = (AFE*)[self.afeArray_HeatMap objectAtIndex:index];
    fldEstmtDataLbl.text = [NSString stringWithFormat:@"%@",tempAFE.afeNumber];
    fldEstmtDataLbl.backgroundColor = [UIColor clearColor];
    fldEstmtDataLbl.textAlignment = UITextAlignmentCenter;
    fldEstmtDataLbl.font = FONT_DETAIL_PAGE_TAB;
    fldEstmtDataLbl.textColor = COLOR_PIECHART_VALUE_LABEL;
    [tmpV addSubview:fldEstmtDataLbl];
    [cell bringSubviewToFront:tmpV];


	[self updateCell:cell forIndex:index];
	return cell;
}

- (void)treemapView:(TreemapView *)treemapView updateCell:(TreemapViewCell *)cell forIndex:(NSInteger)index forRect:(CGRect)rect {
	[self updateCell:cell forIndex:index];
}
-(IBAction)feldEstmtBtnTouched
{
    [self.actualsButton setSelected:self.feldEstmtButton.selected];
    [self.feldEstmtButton setSelected:!self.feldEstmtButton.selected];
    [self.feldEstmtButton setUserInteractionEnabled:NO];
    [self.actualsButton setUserInteractionEnabled:YES];
    self.IsActualBtnClicked = NO;
    [self sortArray];
    [self drawTreeGraph];

}
-(IBAction)actualsBtnTouched
{
    [self.feldEstmtButton setSelected:self.actualsButton.selected];
    [self.actualsButton setSelected:!self.actualsButton.selected];
    [self.actualsButton setUserInteractionEnabled:NO];
    [self.feldEstmtButton setUserInteractionEnabled:YES];
    self.IsActualBtnClicked = YES;
    [self sortArray];
    [self drawTreeGraph];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {

    //[self setUserInteractionEnabled:NO];
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(didSwipeLeftOnProjectWatchlistDetailedView:)])
        {
            
            //if(recognizer.view != scrubberContainerView)
                [self.swipeDelegate didSwipeLeftOnProjectWatchlistDetailedView:self];
        }
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if(self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(didSwipeRightOnProjectWatchlistDetailedView:)])
        {
            //if(recognizer.view != scrubberContainerView)
                [self.swipeDelegate didSwipeRightOnProjectWatchlistDetailedView:self];
        }
    }
}

-(void) setCustomFontForButton:(UIButton *)button
{
    button.titleLabel.font = FONT_DASHBOARD_BUTTON_DEFAULT_LABEL;
    [button setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [button setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    
    [button setTitleColor:[Utility getUIColorWithHexString:@"192835"] forState:UIControlStateNormal];
    [button setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [button setTitleColor:[Utility getUIColorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    
    
    [button setBackgroundImage:[UIImage imageNamed:@"buttonDark"] forState:UIControlStateSelected];
    
    
    [button.titleLabel setShadowColor:[UIColor whiteColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    
}

#pragma mark - ProjectWatchlistAFETableView Delegate
-(void) didSelectAFEObjectForMoreDetais:(AFE *)afeObj OnProjectWatchListAFETableView:(ProjectWatchListAFETableView *)tableView
{
    AppDelegate *tempAppDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if(tempAppDelegate)
    {
        [tempAppDelegate jumpToAFESearchAndSearchAFEWithID:afeObj.afeID];
    }
}

-(void) getAFEsForProjectWatchListAFETableView:(ProjectWatchListAFETableView*) tableView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(getAFEsForTableInProjectWatchlistDetailedView:forPage:sortByField:andSortOrder:withRecordLimit:)])
    {
        [self.delegate getAFEsForTableInProjectWatchlistDetailedView:self forPage:page sortByField:sortField andSortOrder:sortDirection withRecordLimit:limit];
    }
       
}

-(void) dealloc
{
    startDate = nil;
    endDate = nil;
    wathclistAFETableView = nil;
    self.afeArray_HeatMap = nil;
    self.afeArray_Table = nil;
    self.backgroundView = nil;
    self.treeMapAnmtnCell = nil;
    self.swipeDelegate = nil;
}

@end