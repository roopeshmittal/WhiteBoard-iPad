//
//  MainCollectionViewController.m
//  DrawingPad
//
//  Created by Roopesh Mittal on 10/7/14.
//  Copyright (c) 2014 Nagarro. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "MainViewController.h"
#import "CollectionHeaderView.h"
#import "DrawingImage.h"

@interface MainCollectionViewController ()

@end

@implementation MainCollectionViewController{
    NSInteger selectedDrawingIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedDrawingIndex = -1;

    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.drawingsCollection = [[NSMutableArray alloc] init];
    [self loadDrawingsFromDisk];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.drawingsCollection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    for(UIView *subView in [cell.contentView subviews]) {
        [subView removeFromSuperview];
    }
    
    UIImageView *bckimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardbgbox"]];
    cell.backgroundView = bckimageView;
    
    DrawingImage *drawing = (DrawingImage *)[self.drawingsCollection objectAtIndex:indexPath.row];
    

    
    UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 280, 200)];
    thumbnailImageView.image = [self createThumbnail:drawing];
    
    [cell.contentView addSubview:thumbnailImageView];
    
    UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 280, 30)];
    titleLabel.text = drawing.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:titleLabel];
    
    return cell;
}
-(UIImage *)createThumbnail:(UIImage *)originalImage {
    
    CGSize destinationSize = CGSizeMake(180, 150);
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnail;
}
#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MainViewController *drawingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DrawingViewController"];
    drawingViewController.drawingImage = (DrawingImage *)[self.drawingsCollection objectAtIndex:indexPath.row];
    drawingViewController.delegate = self;
    selectedDrawingIndex = indexPath.row;
    [self presentViewController:drawingViewController animated:YES completion:nil];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];

        headerView.headerLabel.text = @"WhiteBoard";
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

#pragma mark UI Actions
- (IBAction)newAction:(id)sender {
    MainViewController *drawingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DrawingViewController"];
    drawingViewController.delegate = self;
    selectedDrawingIndex = -1;
    [self presentViewController:drawingViewController animated:YES completion:nil];
}

#pragma mark SaveDrawingDelegate
-(void)saveDrawing:(DrawingImage *)drawingImage {

    if(selectedDrawingIndex == -1) {
        //New Drawing
        [self.drawingsCollection addObject:drawingImage];
        [self saveDrawingToDisk:drawingImage isNew:YES];
    } else {
        [_drawingsCollection replaceObjectAtIndex:selectedDrawingIndex withObject:drawingImage];
        selectedDrawingIndex = -1;
        [self saveDrawingToDisk:drawingImage isNew:NO];
    }
    
    [self.collectionView reloadData];

}

- (void)saveDrawingToDisk: (DrawingImage *)drawing isNew:(BOOL)isNew
{
    if (drawing != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *drawingFolder = [documentsDirectory stringByAppendingPathComponent:@"Drawings"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:drawingFolder]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:drawingFolder withIntermediateDirectories:NO attributes:nil error:nil];
        }
        if(isNew) {
            drawing.fileName = [NSString stringWithFormat:@"%@%@", [[NSUUID UUID] UUIDString], drawing.title];
        }
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@",drawing.fileName, @".png"];
        NSString* path = [drawingFolder stringByAppendingPathComponent:fileName];
        
        NSData* data = UIImagePNGRepresentation(drawing);
        [data writeToFile:path atomically:YES];
    }
}

- (void)loadDrawingsFromDisk {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *drawingFolder = [documentsDirectory stringByAppendingPathComponent:@"Drawings"];
    
    NSURL *drawingFolderURL = [NSURL fileURLWithPath:drawingFolder];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:drawingFolderURL includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error: nil];
    
    for (NSURL *filePath in directoryContent)
    {
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:filePath]];
        DrawingImage *drawing = [[DrawingImage alloc] initWithCGImage:image.CGImage];
        drawing.fileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
        drawing.title = [drawing.fileName substringFromIndex:36];
        [_drawingsCollection addObject:drawing];
    }
}

@end
