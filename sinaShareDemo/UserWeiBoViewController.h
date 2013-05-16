//
//  UserWeiBoViewController.h
//  sinaShareDemo
//
//  Created by word on 13-5-9.
//  Copyright (c) 2013年 com.wordtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface UserWeiBoViewController : UIViewController<SinaWeiboRequestDelegate>

- (void)addWeiBo:(SinaWeibo *)aSina;

@end
