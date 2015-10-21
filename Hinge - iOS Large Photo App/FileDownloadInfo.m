//
//  PhotoRecord.m
//  Hinge - iOS Large Photo App
//
//  Created by Joshua on 10/19/15.
//  Copyright © 2015 joshuacleetus. All rights reserved.
//

#import "FileDownloadInfo.h"
#import "FileDownloadInfo.h"
#import "AppDelegate.h"


@implementation FileDownloadInfo

-(id)initWithFileTitle:(NSString *)title andDownloadSource:(NSString *)source{
    if (self == [super init]) {
        self.fileTitle = title;
        self.downloadSource = source;
        self.downloadProgress = 0.0;
        self.isDownloading = NO;
        self.downloadComplete = NO;
        self.taskIdentifier = -1;
    }
    
    return self;
}

@end
