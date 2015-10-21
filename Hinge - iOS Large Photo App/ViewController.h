//!
//  @file ViewController.h
//  @brief This is the header file where my super-code is contained.
//
//  Hinge - iOS Large Photo App
//
//  @author Joshua Cleetus
//  @copyright  2015 Joshua Cleetus
//  @version    10/19/15.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate, DetailViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)startAllDownloads:(id)sender;

- (void)stopAllDownloads:(id)sender;

- (void)initializeAll:(id)sender;

@end

