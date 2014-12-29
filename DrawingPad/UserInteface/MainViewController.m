//
//  MainViewController.m
//  DrawingPad
//
//  Created by Roopesh Mittal on 9/23/14.
//  Copyright (c) 2014 Nagarro. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController{
    BOOL newDrawing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _toolsView.layer.cornerRadius = 7;
    _drawingView.lineWidth = self.slider.value;
    if(_drawingImage) {
        _drawingView.backgroundColor = [UIColor colorWithPatternImage:_drawingImage];
        _drawingView.initialImage = _drawingImage;
        _drawingView.currentImage = [[UIImage alloc] initWithCGImage:_drawingImage.CGImage];
        newDrawing = NO;
    } else {
        newDrawing = YES;
    }
}



- (IBAction)setStrokeRed:(id)sender {
    _drawingView.strokeColor = [UIColor redColor];
    _drawingView.lineWidth = self.slider.value;
    if(!self.slider.enabled) {
        self.slider.enabled = YES;
    }
}

- (IBAction)setStrokeGreen:(id)sender {
    _drawingView.strokeColor = [UIColor greenColor];
    _drawingView.lineWidth = self.slider.value;
    if(!self.slider.enabled) {
        self.slider.enabled = YES;
    }
}

- (IBAction)setStrokeBlue:(id)sender {
    _drawingView.strokeColor = [UIColor blueColor];
    _drawingView.lineWidth = self.slider.value;
    if(!self.slider.enabled) {
        self.slider.enabled = YES;
    }
}

- (IBAction)setStrokeBlack:(id)sender {
    _drawingView.strokeColor = [UIColor blackColor];
    _drawingView.lineWidth = self.slider.value;
    if(!self.slider.enabled) {
        self.slider.enabled = YES;
    }
}

- (IBAction)setStrokeEraser:(id)sender {
    _drawingView.strokeColor = [UIColor whiteColor];
    _drawingView.lineWidth = 25.0;
    self.slider.enabled = NO;
}

- (IBAction)setStrokeYellow:(id)sender {
    _drawingView.strokeColor = [UIColor yellowColor];
    _drawingView.lineWidth = self.slider.value;
    if(!self.slider.enabled) {
        self.slider.enabled = YES;
    }
}

- (IBAction)setStrokeGray:(id)sender {
    _drawingView.strokeColor = [UIColor grayColor];
    _drawingView.lineWidth = self.slider.value;
    if(!self.slider.enabled) {
        self.slider.enabled = YES;
    }
}

- (IBAction)setStrokeOrange:(id)sender {
    _drawingView.strokeColor = [UIColor orangeColor];
    _drawingView.lineWidth = self.slider.value;
    if(!self.slider.enabled) {
        self.slider.enabled = YES;
    }
}

- (IBAction)setStrokeBrown:(id)sender {
    _drawingView.strokeColor = [UIColor brownColor];
    _drawingView.lineWidth = self.slider.value;
    if(!self.slider.enabled) {
        self.slider.enabled = YES;
    }
}

- (IBAction)undoAction:(id)sender {
    [_drawingView undoAction];
}

- (IBAction)redoAction:(id)sender {
    [_drawingView redoAction];
}

-(void)saveAction:(id)sender {
    if(newDrawing) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Title" message:@"Please Enter Title For This Drawing" delegate:self cancelButtonTitle:@"Save" otherButtonTitles: nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    } else {
        DrawingImage *drawingToSave = [self captureView];
        drawingToSave.title = _drawingImage.title;
        drawingToSave.fileName = _drawingImage.fileName;
        [_delegate saveDrawing:drawingToSave];
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
}

- (IBAction)homeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)sliderValueChanged:(id)sender {
    _drawingView.lineWidth = self.slider.value;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    DrawingImage *drawingToSave = [self captureView];
    
    if([[[alertView textFieldAtIndex:0] text] length] > 0) {
        drawingToSave.title = [[alertView textFieldAtIndex:0] text];
    } else{
        drawingToSave.title = [[NSUUID UUID] UUIDString];
    }
    
    [_delegate saveDrawing:drawingToSave];
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (DrawingImage *)captureView {
    CGRect rect = [_drawingView bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_drawingView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    DrawingImage *drawing = [[DrawingImage alloc] initWithCGImage:image.CGImage];
    return drawing;
}
@end
