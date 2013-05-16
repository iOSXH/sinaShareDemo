//
//  AppDelegate.h
//  sinaShareDemo
//
//  Created by word on 13-5-7.
//  Copyright (c) 2013年 com.wordtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class SinaWeibo;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (readonly, nonatomic) SinaWeibo *sinaWeibo;

@end
