//
//  Hinge___iOS_Large_Photo_AppTests.m
//  Hinge - iOS Large Photo AppTests
//
//  Created by Joshua on 10/20/15.
//  Copyright © 2015 joshuacleetus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FileDownloadInfo.h"
#import "AppDelegate.h"

@interface Hinge___iOS_Large_Photo_AppTests : XCTestCase <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session; //The session object is the NSURLSession session that we will create and use in our application.

@property (nonatomic, strong) NSMutableArray *arrFileDownloadData; //This is the array in which the FileDownloadInfo objects will be stored.

@property (nonatomic, strong) NSURL *docDirectoryURL; // The path to the Documents directory expressed as a NSURL object.

@end

@implementation Hinge___iOS_Large_Photo_AppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // This method is called before the invocation of each test method in the class.
    self.continueAfterFailure = false;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAsynchronousDataTask
{
    
    //initialize the array of urls to be downloaded
    [self initializeFileDownloadDataArray];
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    self.docDirectoryURL = [URLs objectAtIndex:0];
    
    
    // We will instantiate a NSURLSessionConfiguration object using the backgroundSessionConfiguration class method.
    // The backgroundSessionConfiguration class method accepts one parameter, an identifier, which uniquely identifies the session started by our app in the system.
    // It’s not possible two sessions with the same identifier to exist at the same time.
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.HingeBackgroundTransfer"];
    // We will set only one property, the HTTPMaximumConnectionsPerHost. Through this, we will allow ten simultaneous downloads to take place at once
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 10;
    
    // We will the session property using the sessionConfiguration object.
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];
    // Start download task
    [self startAllDownloads:nil];
    
}

#pragma mark - Private method implementation

// Initializer an array of urls of images to be downloaded.
-(void)initializeFileDownloadDataArray{
    
    // make nsmutable array thread safe using @synchronized
    @synchronized(self.arrFileDownloadData) {
        
        self.arrFileDownloadData = [[NSMutableArray alloc] init];
        
        [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"1" andDownloadSource:@"http://upload.wikimedia.org/wikipedia/commons/8/81/Carn_Eige_Scotland_-_Full_Panorama_from_Summit.jpeg"]];
        [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"2" andDownloadSource:@"http://upload.wikimedia.org/wikipedia/commons/1/1c/NGC_6302_Hubble_2009.full.jpg"]];
        [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"3" andDownloadSource:@"http://upload.wikimedia.org/wikipedia/commons/3/3c/Merging_galaxies_NGC_4676_%28captured_by_the_Hubble_Space_Telescope%29.jpg"]];
        [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"4" andDownloadSource:@"http://spaceflight.nasa.gov/gallery/images/shuttle/sts-125/hires/s125e012033.jpg"]];
        [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"5" andDownloadSource:@"http://mayang.com/textures/Plants/images/Flowers/large_flower_6080110.JPG"]];
        [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"6" andDownloadSource:@"http://setiathome.berkeley.edu/img/head_20.png"]];
        [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"7" andDownloadSource:@"http://upload.wikimedia.org/wikipedia/commons/c/ca/Star-forming_region_S106_%28captured_by_the_Hubble_Space_Telescope%29.jpg"]];
        [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"8" andDownloadSource:@"http://hdwallpaper.freehdw.com/0003/nature-landscapes_widewallpaper_large-flowers-close-up_21096.jpg"]];
        [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"9" andDownloadSource:@"http://media.cleveland.com/neobirding_impact/photo/11460704-large.jpg"]];
        [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:@"10" andDownloadSource:@"http://www.factzoo.com/sites/all/img/birds/great-hornbill-flying.jpg"]];
        
    }
    
}

// Get the index of the FileDownloadInfoObject
-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier{
    
    @synchronized(self.arrFileDownloadData) {
        
        int index = 0;
        for (int i=0; i<[self.arrFileDownloadData count]; i++) {
            FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
            if (fdi.taskIdentifier == taskIdentifier) {
                index = i;
                break;
            }
        }
        
        return index;
    }
    
}


#pragma mark - Download image method implementation
// Start download task
- (void)startAllDownloads:(id)sender {
    // Access all FileDownloadInfo objects using a loop.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        // Check if a file is already being downloaded or not.
        if (!fdi.isDownloading) {
            // Check if should create a new download task using a URL, or using resume data.
            if (fdi.taskIdentifier == -1) {
                fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource]];
            }
            else{
                fdi.downloadTask = [self.session downloadTaskWithResumeData:fdi.taskResumeData];
            }
            
            // Keep the new taskIdentifier.
            fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
            
            // Start the download.
            [fdi.downloadTask resume];
            
            // Indicate for each file that is being downloaded.
            fdi.isDownloading = YES;
        }
        
    }
    
}

#pragma mark - NSURLSession Delegate method implementation

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    NSURL *destinationURL = [self.docDirectoryURL URLByAppendingPathComponent:destinationFilename];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        [fileManager removeItemAtURL:destinationURL error:nil];
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    
    // Change the flag values of the respective FileDownloadInfo object.
    int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
    
    
    if (success) {
        
        @synchronized(self.arrFileDownloadData) {
            
            FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:index];
            UIImage *downloadedImage = [UIImage imageWithData:
                                        [NSData dataWithContentsOfURL:location]];
            if (downloadedImage!=nil) {
                fdi.fileImage = downloadedImage;
            }else{
                fdi.fileImage = nil;
            }
            
            fdi.isDownloading = NO;
            fdi.downloadComplete = YES;
            
            
            
            // Set the initial value to the taskIdentifier property of the fdi object,
            // so when the start button gets tapped again to start over the file download.
            fdi.taskIdentifier = -1;
            
            // In case there is any resume data stored in the fdi object, just make it nil.
            fdi.taskResumeData = nil;
            
        }
        
        
    }
    else{
        
        NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
    }
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
        XCTAssertNotNil(error, @"download error");

    }
    else{
        NSLog(@"Download finished successfully.");
        
    }
    
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"Unknown transfer size");
    }
    else{
        
    }
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    // Check if all download tasks have been finished.
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if ([downloadTasks count] == 0) {
            if (appDelegate.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = appDelegate.backgroundTransferCompletionHandler;
                
                // Make nil the backgroundTransferCompletionHandler.
                appDelegate.backgroundTransferCompletionHandler = nil;
                
                // Call the completion handler to tell the system that there are no other background transfers.
                completionHandler();

            }
        }
    }];
}


- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
