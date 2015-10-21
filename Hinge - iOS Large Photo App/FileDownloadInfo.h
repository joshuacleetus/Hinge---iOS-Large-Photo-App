//
//  PhotoRecord.h
//  Hinge - iOS Large Photo App
//
//  Created by Joshua on 10/19/15.
//  Copyright © 2015 joshuacleetus. All rights reserved.
//

#import <UIKit/UIKit.h> // because we need UIImage

//An auxiliary class that will help us keep vital data throughout the project
@interface FileDownloadInfo : NSObject

@property (nonatomic, strong) NSString *fileTitle; // This property keeps a title describing the file to be downloaded (not the file name)
@property (nonatomic, strong) UIImage *fileImage; // This property is used to store the downloaded image.
@property (nonatomic, strong) NSString *downloadSource; // The URL source where a file should be downloaded from as a NSString object.

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask; // A NSURLSessionDownloadTask object that will be used to keep a strong reference to the download task of a file.

@property (nonatomic, strong) NSData *taskResumeData; // A NSData object that keeps the data produced by a cancelled download task that can be resumed at a later time (in other words, when it’s paused).

@property (nonatomic) double downloadProgress; // The download progress of a file as reported by the NSURLSession delegate methods.

@property (nonatomic) BOOL isDownloading; // This flag indicates whether a file is being downloaded or not.

@property (nonatomic) BOOL downloadComplete; // Return YES if image download is complete.

@property (nonatomic) unsigned long taskIdentifier; //When a download task is initiated, the NSURLSession assigns it a unique identifier so it can be distinguished among others. The identifier values start from 0.

//A custom init method. In this one, we will provide the file title and the download source as parameters
-(id)initWithFileTitle:(NSString *)title andDownloadSource:(NSString *)source;

@end
