//
//  WeiBoViewController.h
//  sinaShareDemo
//
//  Created by word on 13-5-10.
//  Copyright (c) 2013年 com.wordtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface WeiBoViewController : UIViewController<SinaWeiboRequestDelegate, UITableViewDataSource, UITableViewDelegate>

- (void)addWeiBo:(SinaWeibo *)aSina;

@end
