//
//  MainCollectionViewController.h
//  DrawingPad
//
//  Created by Roopesh Mittal on 10/7/14.
//  Copyright (c) 2014 Nagarro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface MainCollectionViewController : UICollectionViewController<SaveDrawingDelegate>

@property (strong, nonatomic) NSMutableArray *drawingsCollection;
- (IBAction)newAction:(id)sender;

@end
