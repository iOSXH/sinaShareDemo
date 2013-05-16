//
//  SendWeiBoViewController.m
//  sinaShareDemo
//
//  Created by word on 13-5-8.
//  Copyright (c) 2013年 com.wordtech. All rights reserved.
//

#import "SendWeiBoViewController.h"

@interface SendWeiBoViewController ()

@property (nonatomic, retain) UILabel *userNameLab;
@property (nonatomic, retain) SinaWeibo *sina;
@property (nonatomic, retain) NSMutableDictionary *userInfoDic;
@property (nonatomic, retain) UITextView *myTextView;

@end

@implementation SendWeiBoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)addWeiBo:(SinaWeibo *)aWeiBo{
    self.sina = aWeiBo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.sina requestWithURL:@"users/show.json" params:[NSMutableDictionary dictionaryWithObject:self.sina.userID forKey:@"uid"] httpMethod:@"GET" delegate:self];
    
    UIView *titleView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)] autorelease];
    
    UILabel *lab1 = [[[UILabel alloc] initWithFrame:CGRectMake(0, 4, 100, 22)] autorelease];
    [lab1 setText:@"发表微博"];
    [lab1 setFont:[UIFont fontWithName:@"Arial" size:20]];
    [lab1 setTextAlignment:NSTextAlignmentCenter];
    [lab1 setTextColor:[UIColor whiteColor]];
    [lab1 setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:lab1];
    
    self.userNameLab = [[[UILabel alloc] initWithFrame:CGRectMake(0, 24, 100, 18)] autorelease];
    [self.userNameLab setFont:[UIFont fontWithName:@"Arial" size:15]];
    [self.userNameLab setTextAlignment:NSTextAlignmentCenter];
    [self.userNameLab setTextColor:[UIColor whiteColor]];
    [self.userNameLab setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:self.userNameLab];
    
    [self.navigationItem setTitleView:titleView];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    self.myTextView = [[[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)] autorelease];
    [self.myTextView becomeFirstResponder];
    [self.view addSubview:self.myTextView];
}

//发送按钮响应方法
- (void)sendBtnClicked{
    [self.myTextView resignFirstResponder];
    if (self.myTextView.text.length <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未输入信息，不能发送！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }else{
        // post status
        [self.sina requestWithURL:@"statuses/update.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:self.myTextView.text, @"status", nil]
                       httpMethod:@"POST"
                         delegate:self];
    }
}

#pragma mark - SinaWeiboRequest Delegate

//请求成功回调方法
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    if ([request.url hasSuffix:@"users/show.json"]){
        [self.userInfoDic release];
        self.userInfoDic = [result retain];
        [self.userNameLab setText:[self.userInfoDic objectForKey:@"name"]];
        
    }else if ([request.url hasSuffix:@"statuses/update.json"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送微博成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        
        self.myTextView.text = @"";
    }
}

//请求失败回调方法
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error{
    if ([request.url hasSuffix:@"users/show.json"]){
        [self.userInfoDic release], self.userInfoDic = nil;
        
    }else if ([request.url hasSuffix:@"statuses/update.json"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送微博失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
