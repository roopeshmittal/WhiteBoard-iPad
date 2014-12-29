//
//  DrawingView.h
//  DrawingPad
//
//  Created by Roopesh Mittal on 10/10/14.
//  Copyright (c) 2014 Nagarro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingImage.h"

@interface DrawingView : UIView

@property (strong, nonatomic) UIColor *strokeColor;
@property (strong, nonatomic) UIImage *initialImage;
@property (strong, nonatomic) UIImage *currentImage;
@property CGFloat lineWidth;

-(void)undoAction;
-(void)redoAction;


@end
