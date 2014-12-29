//
//  DrawingView.m
//  DrawingPad
//
//  Created by Roopesh Mittal on 10/10/14.
//  Copyright (c) 2014 Nagarro. All rights reserved.
//

#import "DrawingView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSMutableArray+Stack.h"
#import "DrawingBezierPath.h"

@implementation DrawingView {
    UIBezierPath *path;
    CGPoint pts[4];
    uint ctr;
    NSMutableArray *pathStack;
    NSMutableArray *redoStack;
    BOOL isReverting;

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        pathStack = [[NSMutableArray alloc] init];
        redoStack = [[NSMutableArray alloc] init];
        _strokeColor = [UIColor blackColor];
        isReverting = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if(isReverting){
        [self revertDrawing];
        [_currentImage drawInRect:rect];
        isReverting = NO;
    } else {
        [_currentImage drawInRect:rect];
        [_strokeColor setStroke];
        [path setLineWidth:_lineWidth];
        [path stroke];
    }
}

-(void)revertDrawing{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
    [[UIColor whiteColor] setFill];
    [rectpath fill];
    
    if(_initialImage) {
        [_initialImage drawInRect:self.bounds];
    }
    
    for(DrawingBezierPath *pathTemp in pathStack){
        [pathTemp.strokeColor setStroke];
        [pathTemp stroke];
    }
    
    _currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)revertDrawing:(BOOL)isUndo{
    if(isUndo){
        [self undoAction];
    } else {
        [self redoAction];
    }
}

- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    if(!_currentImage){
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    
    [_currentImage drawAtPoint:CGPointZero];
    [_strokeColor setStroke];
    [path setLineWidth:_lineWidth];
    [path stroke];
    
    _currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    path = [UIBezierPath bezierPath];
    ctr = 0;
    UITouch *touch = [touches anyObject];
    pts[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    ctr++;
    pts[ctr] = p;
    if (ctr == 3)
    {
        pts[2] = CGPointMake((pts[1].x + pts[3].x)/2.0, (pts[1].y + pts[3].y)/2.0);
        [path moveToPoint:pts[0]];
        [path addQuadCurveToPoint:pts[2] controlPoint:pts[1]];
        [self setNeedsDisplay];
        pts[0] = pts[2];
        pts[1] = pts[3];
        ctr = 1;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (ctr == 0)
    {
        [path addArcWithCenter:pts[0] radius:_lineWidth/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    }
    else if (ctr == 1)
    {
        [path moveToPoint:pts[0]];
        [path addLineToPoint:pts[1]];
    }
    else if (ctr == 2)
    {
        [path moveToPoint:pts[0]];
        [path addQuadCurveToPoint:pts[2] controlPoint:pts[1]];
    }
    
    DrawingBezierPath *pathToCache = [[DrawingBezierPath alloc] init];
    pathToCache.CGPath = path.CGPath;
    pathToCache.strokeColor = _strokeColor;
    pathToCache.lineWidth = _lineWidth;
    [pathStack push:pathToCache];
    [self drawBitmap];
    [self setNeedsDisplay];
    ctr = 0;
}

- (void)undoAction {
    if(pathStack.count > 0) {
        [redoStack push:[pathStack pop]];
        isReverting = YES;
        [self setNeedsDisplay];
    }
}

- (void)redoAction{
    if(redoStack.count > 0) {
        [pathStack push:[redoStack pop]];
        isReverting = YES;
        [self setNeedsDisplay];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

@end
