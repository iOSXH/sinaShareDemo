//
//  ViewController.m
//  sinaShareDemo
//
//  Created by word on 13-5-7.
//  Copyright (c) 2013年 com.wordtech. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "UserInfoViewController.h"
#import "SendWeiBoViewController.h"
#import "UserWeiBoViewController.h"
#import "FriendshipsViewController.h"
#import "WeiBoViewController.h"

@interface ViewController ()

@property (nonatomic, retain) SinaWeibo *sina;
@property (nonatomic, retain) UIBarButtonItem *leftButtonItem;
@property (nonatomic, retain) UIButton *userInfoBtn;
@property (nonatomic, retain) UIButton *shareBtn;
@property (nonatomic, retain) UIButton *timelineBtn;
@property (nonatomic, retain) UIButton *friendsBtn;
@property (nonatomic, retain) UIButton *weiboBtn;
@property (nonatomic, retain) NSMutableDictionary *userInfoDic;
@property (nonatomic, retain) NSMutableArray *statuses;

@end

@implementation ViewController

- (SinaWeibo*)sinaWeibo
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.sinaWeibo.delegate = self;
    return delegate.sinaWeibo;
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaWeibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"微博"];
        
    self.leftButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(loginDone)] autorelease];
    self.navigationItem.leftBarButtonItem = self.leftButtonItem;
    
    self.userInfoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.userInfoBtn setFrame:CGRectMake(10, 20, 300, 50)];
    [self.userInfoBtn setTitle:@"未登录" forState:UIControlStateNormal];
    [self.userInfoBtn addTarget:self action:@selector(userInfoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.userInfoBtn];
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.shareBtn setFrame:CGRectMake(10, 80, 300, 50)];
    [self.shareBtn setTitle:@"未登录" forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareBtn];
    
    self.timelineBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.timelineBtn setFrame:CGRectMake(10, 140, 300, 50)];
    [self.timelineBtn setTitle:@"未登录" forState:UIControlStateNormal];
    [self.timelineBtn addTarget:self action:@selector(timelineBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.timelineBtn];
    
    self.friendsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.friendsBtn setFrame:CGRectMake(10, 200, 300, 50)];
    [self.friendsBtn setTitle:@"未登录" forState:UIControlStateNormal];
    [self.friendsBtn addTarget:self action:@selector(friendsBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.friendsBtn];
    
    self.weiboBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.weiboBtn setFrame:CGRectMake(10, 260, 300, 50)];
    [self.weiboBtn setTitle:@"未登录" forState:UIControlStateNormal];
    [self.weiboBtn addTarget:self action:@selector(weiboBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.weiboBtn];

    
}

#pragma mark - button Clicked

//登陆按钮响应方法
- (void)loginDone{
    self.sina = [self sinaWeibo];
    BOOL authValid = self.sina.isAuthValid;
    
    if (!authValid){
        [self.sina logIn];
    }else{
        [self.sina logOut];
        [self.leftButtonItem setTitle:@"登录"];
    }
}


//用户信息按钮响应方法
- (void)userInfoBtnClicked{
    self.sina = [self sinaWeibo];
    BOOL authValid = self.sina.isAuthValid;
    if (!authValid) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未登录，请登录微博！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        self.sina = [self sinaWeibo];
        UserInfoViewController *uivc = [[[UserInfoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        [uivc addWeiBo:self.sina];
        [self.navigationController pushViewController:uivc animated:YES];
         
    }
}

//分享按钮响应方法
- (void)shareBtnClicked{
    self.sina = [self sinaWeibo];
    BOOL authValid = self.sina.isAuthValid;
    if (!authValid) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未登录，请登录微博！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        SendWeiBoViewController *swbvc = [[[SendWeiBoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        self.sina = [self sinaWeibo];
        [swbvc addWeiBo:self.sina];
        [self.navigationController pushViewController:swbvc animated:NO];
    }
}


//用户微博按钮响应方法
- (void)timelineBtnClicked{
    self.sina = [self sinaWeibo];
    BOOL authValid = self.sina.isAuthValid;
    if (!authValid) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未登录，请登录微博！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        self.sina = [self sinaWeibo];
        UserWeiBoViewController *uwbvc = [[[UserWeiBoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        [uwbvc addWeiBo:self.sina];
        [self.navigationController pushViewController:uwbvc animated:YES];
    }
}

//用户朋友按钮响应方法
- (void)friendsBtnClicked{
    self.sina = [self sinaWeibo];
    BOOL authValid = self.sina.isAuthValid;
    if (!authValid) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未登录，请登录微博！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        self.sina = [self sinaWeibo];
        FriendshipsViewController *fsvc = [[[FriendshipsViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        [fsvc addWeiBo:self.sina];
        [self.navigationController pushViewController:fsvc animated:YES];
    }

}

//微博按钮响应方法
- (void)weiboBtnClicked{
    self.sina = [self sinaWeibo];
    BOOL authValid = self.sina.isAuthValid;
    if (!authValid) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未登录，请登录微博！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        self.sina = [self sinaWeibo];
        WeiBoViewController *wbvc = [[[WeiBoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        [wbvc addWeiBo:self.sina];
        [self.navigationController pushViewController:wbvc animated:YES];
    }
    
}

#pragma mark - SinaWeibo Delegate
//取消登录回调方法
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo{
    NSLog(@"取消登录成功！");
}

//登陆成功后回调方法
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    [self.leftButtonItem setTitle:@"注销"];
    NSLog(@"登录成功！");
    
    [self.userInfoBtn setTitle:@"已登录，查看用户信息" forState:UIControlStateNormal];
    [self.shareBtn setTitle:@"已登录，可分享微博" forState:UIControlStateNormal];
    [self.timelineBtn setTitle:@"已登录，查看用户微博" forState:UIControlStateNormal];
    [self.friendsBtn setTitle:@"已登录，查看用户关注" forState:UIControlStateNormal];
    [self.weiboBtn setTitle:@"已登录，查看所有微博" forState:UIControlStateNormal];
    
    //NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    [self storeAuthData];
}

//登出注销后回调方法
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    NSLog(@"登出注销成功");
    [self.userInfoBtn setTitle:@"未登录" forState:UIControlStateNormal];
    [self.shareBtn setTitle:@"未登录" forState:UIControlStateNormal];
    [self.timelineBtn setTitle:@"未登录" forState:UIControlStateNormal];
    [self.friendsBtn setTitle:@"未登录" forState:UIControlStateNormal];
    [self.weiboBtn setTitle:@"未登录" forState:UIControlStateNormal];
    [self removeAuthData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
