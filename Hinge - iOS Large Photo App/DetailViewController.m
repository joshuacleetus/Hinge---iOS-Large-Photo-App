//
//  DetailViewController.m
//  Hinge - iOS Large Photo App
//
//  Created by Joshua on 10/20/15.
//  Copyright © 2015 joshuacleetus. All rights reserved.
//

#import "DetailViewController.h"
#import "FileDownloadInfo.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.selectedIndex+1,(unsigned long)self.arrFileDownloadData.count];
    
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.bgImageView.autoresizingMask =
    ( UIViewAutoresizingFlexibleBottomMargin
     | UIViewAutoresizingFlexibleHeight
     | UIViewAutoresizingFlexibleLeftMargin
     | UIViewAutoresizingFlexibleRightMargin
     | UIViewAutoresizingFlexibleTopMargin
     | UIViewAutoresizingFlexibleWidth );
    self.bgImageView.clipsToBounds = YES;
    [self.view addSubview:self.bgImageView];
    
    //get the image from downloaded image class FileDownloadInfo
    FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:self.selectedIndex];
    //set image to imageview
    self.bgImageView.image = fdi.fileImage;
    
    //add delete button
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setFrame:CGRectMake((CGRectGetWidth(self.view.frame)) - 70, 0, 70, 60)];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.view addSubview:self.deleteBtn];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.deleteBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateImagesInImageView:) userInfo:Nil repeats:YES];

    
}

- (void)deleteBtnPressed:(id)sender {

    [self.arrFileDownloadData removeObjectAtIndex:self.selectedIndex];
    if([self.delegate respondsToSelector:@selector(updateImagesViewController:didFinishUpdatingArray:)])
    {
        [self.delegate updateImagesViewController:self didFinishUpdatingArray:self.arrFileDownloadData];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)updateImagesInImageView:(id)sender {
    
    if ((self.selectedIndex+1)<self.arrFileDownloadData.count) {
        self.selectedIndex = self.selectedIndex+1;
    }else{
        self.selectedIndex = 0;
    }
    
    //get the image from downloaded image class FileDownloadInfo
    FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:self.selectedIndex];
    //set image to imageview
    if (fdi.fileImage != nil) {
        self.bgImageView.image = fdi.fileImage;
    }else{
        self.bgImageView.image = [UIImage imageNamed:@"No_image.png"];
    }
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.selectedIndex+1,(unsigned long)self.arrFileDownloadData.count];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
