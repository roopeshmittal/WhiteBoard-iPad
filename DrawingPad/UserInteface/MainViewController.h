//
//  MainViewController.h
//  DrawingPad
//
//  Created by dev on 9/23/14.
//  Copyright (c) 2014 Nagarro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingView.h"
#import "DrawingImage.h"

@protocol SaveDrawingDelegate <NSObject>
-(void)saveDrawing:(UIImage *)drawingImage;
@end

@interface MainViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *toolsView;
@property (strong, nonatomic) IBOutlet DrawingView *drawingView;
@property (strong, nonatomic) DrawingImage *drawingImage;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) id <SaveDrawingDelegate> delegate;


- (IBAction)setStrokeRed:(id)sender;
- (IBAction)setStrokeGreen:(id)sender;
- (IBAction)setStrokeBlue:(id)sender;
- (IBAction)setStrokeBlack:(id)sender;
- (IBAction)setStrokeEraser:(id)sender;
- (IBAction)setStrokeYellow:(id)sender;
- (IBAction)setStrokeGray:(id)sender;
- (IBAction)setStrokeOrange:(id)sender;
- (IBAction)setStrokeBrown:(id)sender;
- (IBAction)undoAction:(id)sender;
- (IBAction)redoAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)homeAction:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

@end