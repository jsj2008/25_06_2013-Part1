/*
 Copyright (C) 2011- 2012  Reetu Raj (reetu.raj@gmail.com)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
 and associated documentation files (the “Software”), to deal in the Software without 
 restriction, including without limitation the rights to use, copy, modify, merge, publish, 
 distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom
 the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or 
 substantial portions of the Software.

 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT 
 NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *///
//  BarView.h
//  MIMChartLib
//
//  Created by Reetu Raj on 15/08/11.
//  Copyright (c) 2012 __MIM 2D__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFEConstants.h"

@protocol BarViewDelegate <NSObject>

-(void)displayFloatingView:(id)view;

@end

@interface BarView : UIView {
    
    MIMColorClass *color;
    NSDictionary *lColor;
    NSDictionary *dColor;    
    UIColor *borderColor;
    BOOL isGradient;
    GRADIENT_STYLE gradientStyle;
    GLOSS_STYLE glossStyle;
    BOOL negativeBar;
    

    
}
@property(nonatomic,retain) MIMColorClass *color;
@property(nonatomic,retain) NSDictionary *lColor;
@property(nonatomic,retain) NSDictionary *dColor;    
@property(nonatomic,retain) UIColor *borderColor;
@property(nonatomic,assign) BOOL isGradient;
@property(nonatomic,assign) GRADIENT_STYLE gradientStyle;
@property(nonatomic,assign) GLOSS_STYLE glossStyle;
@property(nonatomic,assign) BOOL negativeBar;
@property(nonatomic,assign) id delegate;
@end
