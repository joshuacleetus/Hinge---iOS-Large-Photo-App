//
//  AppDelegate.h
//  Hinge - iOS Large Photo App
//
//  Created by Joshua on 10/19/15.
//  Copyright © 2015 joshuacleetus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// declare backgroundTransferCompletionHandler property to handle downloads in the background
@property (nonatomic, copy) void(^backgroundTransferCompletionHandler)();

@end

