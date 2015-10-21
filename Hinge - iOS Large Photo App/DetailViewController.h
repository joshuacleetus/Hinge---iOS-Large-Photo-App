//
//  DetailViewController.h
//  Hinge - iOS Large Photo App
//
//  Created by Joshua on 10/20/15.
//  Copyright © 2015 joshuacleetus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewControllerDelegate <NSObject>
- (void)updateImagesViewController:(id)controller didFinishUpdatingArray:(NSMutableArray *)array;
@end

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *arrFileDownloadData;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) id<DetailViewControllerDelegate> delegate;

@end
