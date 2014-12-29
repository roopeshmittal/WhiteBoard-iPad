//
//  CollectionHeaderView.h
//  DrawingPad
//
//  Created by Roopesh Mittal on 10/9/14.
//  Copyright (c) 2014 Nagarro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *headerNewButton;

@end
