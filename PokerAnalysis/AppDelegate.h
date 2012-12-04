//
//  AppDelegate.h
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-21.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) UINavigationController *navController;

@end
