//
//  ViewController.m
//  Hinge - iOS Large Photo App
//
//  Created by Joshua on 10/19/15.
//  Copyright © 2015 joshuacleetus. All rights reserved.
//

#import "ViewController.h"
#import "FileDownloadInfo.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

// Define some constants regarding the tag values of the prototype cell's subviews.
#define CellProgressBarTagValue  40

@interface ViewController ()

@property (nonatomic, strong) NSURLSession *session; //The session object is the NSURLSession session that we will create and use in our application.

@property (nonatomic, strong) NSMutableArray *arrFileDownloadData; //This is the array in which the FileDownloadInfo objects will be stored.

@property (nonatomic, strong) NSURL *docDirectoryURL; // The path to the Documents directory expressed as a NSURL object.


-(void)initializeFileDownloadDataArray; //Method to intialize array and fill it with FileInfo objects
-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier; //This is a method to find the index of the FileDownloadInfo object

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //set title for app here
    self.title = @"iOS Large Photo App";
    
    //add tableview as subview to the main view
    self.tableView = [[UITableView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = 10;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    //set the frame of the uitableview
    self.tableView.frame = CGRectMake(0,
                                          0,
                                          CGRectGetWidth(self.view.frame),
                                          CGRectGetHeight(self.view.frame));
    
    //initialize the array of urls to be downloaded
    [self initializeFileDownloadDataArray];
    
    // Make self the delegate and datasource of the table view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Enable scrolling in table view.
    self.tableView.scrollEnabled = YES;
    
    
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

- (UINavigationItem *)navigationItem{
    UINavigationItem *item = [super navigationItem];
    if (item != nil && item.backBarButtonItem == nil)
    {
        item.backBarButtonItem = [[UIBarButtonItem alloc] init];
        item.backBarButtonItem.title = @"Back";
    }
    
    return item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    @synchronized(self.arrFileDownloadData) {
        return self.arrFileDownloadData.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    for (UIView* view in [cell.contentView subviews])
    {
        if ([view isKindOfClass:[UIImageView class]])  //Condition if that view belongs to any specific class
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIProgressView class]])  //Condition if that view belongs to any specific class
        {
            [view removeFromSuperview];
        }
    }

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.contentMode = UIViewContentModeScaleToFill;
    cell.backgroundColor = [UIColor whiteColor];
    
    @synchronized(self.arrFileDownloadData) {
        
        // Get the respective FileDownloadInfo object from the arrFileDownloadData array.
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:indexPath.row];
        
        // Place a progress view.
        UIProgressView *progressView =[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.frame = CGRectMake(20, 100, CGRectGetWidth(self.view.frame)-40, 10);
        progressView.progressTintColor=[UIColor blueColor];
        progressView.tag = CellProgressBarTagValue;
        [cell addSubview:progressView];
        
        UIImageView *imgView =[[UIImageView alloc] init];
        imgView.frame = CGRectMake(20, 5, cell.frame.size.width-40, CGRectGetHeight(cell.frame)-10);
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.autoresizingMask =
        ( UIViewAutoresizingFlexibleBottomMargin
         | UIViewAutoresizingFlexibleHeight
         | UIViewAutoresizingFlexibleLeftMargin
         | UIViewAutoresizingFlexibleRightMargin
         | UIViewAutoresizingFlexibleTopMargin
         | UIViewAutoresizingFlexibleWidth );
        imgView.clipsToBounds = YES;
        [cell addSubview:imgView];
        
        // Set the file title.
        cell.textLabel.text = fdi.fileTitle;
        
        // Depending on whether the current file is being downloaded or not, specify the status
        // of the progress bar.
        if (!fdi.isDownloading) {
            // Hide the progress view .
            [progressView setHidden:YES];
            [imgView setBackgroundColor:[UIColor whiteColor]];
            // If the image is not nil set the downloaded image in the cell
            if (fdi.fileImage!=nil) {
                cell.textLabel.text = @"";
                imgView.image = fdi.fileImage;

//                imgView.hidden = YES;
//                // Show the image with a small delay
//                [UIView animateWithDuration:0.5 animations:^{
//                    imgView.hidden = NO;
//                    
//                }];
                
            }else{
                //if no image is present remove any previous image present
                imgView.image = [UIImage imageNamed:@"No_image.png"];
                cell.textLabel.text = @"";
            }
            
        }
        else{
            // Show the progress view and update its progress.
            [progressView setHidden:NO];
            NSLog(@"%f",fdi.downloadProgress);
            progressView.progress = fdi.downloadProgress;
            
            //remove any previous images present.
            imgView.image = nil;
            
        }

    }
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // Make nsmutable array thread safe
    @synchronized(self.arrFileDownloadData) {
        //Show the detail view when we select an image
        DetailViewController *media = [[DetailViewController alloc]init];
        media.selectedIndex = indexPath.row;
        media.arrFileDownloadData = self.arrFileDownloadData;
        media.delegate = self;
        [self.navigationController pushViewController:media animated:YES];
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
    
    // Reload the table view.
    [self.tableView reloadData];
}

//Stop all download tasks
- (void)stopAllDownloads:(id)sender {
    // Access all FileDownloadInfo objects using a loop.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        // Check if a file is being currently downloading.
        if (fdi.isDownloading) {
            // Cancel the task.
            [fdi.downloadTask cancel];
            
            // Change all related properties.
            fdi.isDownloading = NO;
            fdi.taskIdentifier = -1;
            fdi.downloadProgress = 0.0;
            fdi.downloadTask = nil;
        }
    }
    
    // Reload the table view.
    [self.tableView reloadData];
}

// Initialize all FileDownloadInfo objects
- (void)initializeAll:(id)sender {
    
        @synchronized(self.arrFileDownloadData) {
            
            // Access all FileDownloadInfo objects using a loop and give all properties their initial values.
            for (int i=0; i<[self.arrFileDownloadData count]; i++) {

             FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
            
            if (fdi.isDownloading) {
                [fdi.downloadTask cancel];
            }
            
            fdi.isDownloading = NO;
            fdi.downloadComplete = NO;
            fdi.taskIdentifier = -1;
            fdi.downloadProgress = 0.0;
            fdi.downloadTask = nil;
        }

    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Get all files in documents directory.
    NSArray *allFiles = [fileManager contentsOfDirectoryAtURL:self.docDirectoryURL
                                   includingPropertiesForKeys:nil
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    for (int i=0; i<[allFiles count]; i++) {
        [fileManager removeItemAtURL:[allFiles objectAtIndex:i] error:nil];
    }
    
    // Reload the table view.
    [self.tableView reloadData];
    
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
            
            // We make sure the downloaded images are updated in the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                // Reload the respective table view row using the main thread.
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationNone];
                
            }];

        }
        
        
    }
    else{

        NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
    }
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
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
        
        @synchronized(self.arrFileDownloadData) {
            
            // Locate the FileDownloadInfo object among all based on the taskIdentifier property of the task.
            int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
            FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:index];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // Calculate the progress.
                fdi.downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
                
                // Get the progress view of the appropriate cell and update its progress.
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                UIProgressView *progressView = (UIProgressView *)[cell viewWithTag:CellProgressBarTagValue];
                progressView.progress = fdi.downloadProgress;
                
                
            }];

        }
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
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    
                    // Show a local notification when all downloads are over.
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
            }
        }
    }];
}

// Update the images after coming back from the detail view
- (void)updateImagesViewController:(id)controller didFinishUpdatingArray:(NSMutableArray *)array {
    
    //using delegate method, get data back from second page view controller and set it to property declared in here
//    NSLog(@"This was returned from secondPageViewController: %@",array);
    
    @synchronized(self.arrFileDownloadData) {
        self.arrFileDownloadData = [NSMutableArray new];
        self.arrFileDownloadData = array;
    }

    //re load the images
    [self initializeAll:nil];
    
    
}

@end
