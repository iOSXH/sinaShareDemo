//
//  SendWeiBoViewController.h
//  sinaShareDemo
//
//  Created by word on 13-5-8.
//  Copyright (c) 2013年 com.wordtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface SendWeiBoViewController : UIViewController<SinaWeiboRequestDelegate>

- (void)addWeiBo:(SinaWeibo *)aWeiBo;

@end
