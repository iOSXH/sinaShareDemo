//
//  UserWeiBoViewController.m
//  sinaShareDemo
//
//  Created by word on 13-5-9.
//  Copyright (c) 2013年 com.wordtech. All rights reserved.
//

#import "UserWeiBoViewController.h"

@interface UserWeiBoViewController ()

@property (nonatomic, retain) SinaWeibo *sina;
@property (nonatomic, retain) UIScrollView *weiBoView;
@property (nonatomic, retain) NSMutableDictionary *userInfoDic;
@property (nonatomic, retain) NSMutableArray *statuses;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end

@implementation UserWeiBoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)addWeiBo:(SinaWeibo *)aSina{
    self.sina = aSina;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.activityIndicator setCenter:CGPointMake(150, 130)];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator release];
    [self.activityIndicator startAnimating];
    
    BOOL authValid = self.sina.isAuthValid;
    if (!authValid) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未登录，请登录微博！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        [self.sina requestWithURL:@"users/show.json" params:[NSMutableDictionary dictionaryWithObject:self.sina.userID forKey:@"uid"] httpMethod:@"GET" delegate:self];
    }
    
    if (authValid) {
        [self.sina requestWithURL:@"statuses/user_timeline.json"
                           params:[NSMutableDictionary dictionaryWithObject:self.sina.userID forKey:@"uid"]
                       httpMethod:@"GET"
                         delegate:self];
    }

}

- (void)refreshWeiBo{
    [self addWeiBoView];
    
    for (int i = 0; i < self.statuses.count; i ++) {
        CGFloat subheight = 0;
        for (UIView *view in self.weiBoView.subviews) {
            subheight = subheight + view.bounds.size.height;
        }
        NSString *eachText = [[self.statuses objectAtIndex:i] objectForKey:@"text"];
        [self.weiBoView addSubview:[self addEachWeiBoView:eachText withNum:i withHeight:subheight]];
    }
    
    CGFloat height = 0;
    for (UIView *view in self.weiBoView.subviews) {
        height = height + view.bounds.size.height;
    }
    NSString *eachText = [[self.statuses objectAtIndex:self.statuses.count-1] objectForKey:@"text"];
    height = height + [self addEachWeiBoView:eachText withNum:0 withHeight:0].bounds.size.height;
    [self.weiBoView setContentSize:CGSizeMake(300, height)];
}

//添加微博界面
- (void)addWeiBoView{
    self.weiBoView = [[[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, 300, 400)] autorelease];
    [self.weiBoView setBackgroundColor:[UIColor grayColor]];
    [self.weiBoView setPagingEnabled:YES];
    [self.view addSubview:self.weiBoView];    
}

//添加每条微博界面
- (UIView *)addEachWeiBoView:(NSString *)text withNum:(int)num withHeight:(CGFloat)height{
    UILabel *eachTextLab = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0,0)] autorelease];
    [eachTextLab setNumberOfLines:0];
    CGSize size = CGSizeMake(290,2000);
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    CGSize labSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [eachTextLab setFrame:CGRectMake(0, 0, labSize.width, labSize.height)];
    [eachTextLab setFont:font];
    [eachTextLab setText:text];
    
    UIView *eachWWeiBoView = [[[UIView alloc] initWithFrame:CGRectMake(5,5+height+ 5*num, 300, labSize.height+30)] autorelease];
    [eachWWeiBoView setBackgroundColor:[UIColor yellowColor]];
    [eachWWeiBoView addSubview:eachTextLab];
    
    return eachWWeiBoView;
}

#pragma mark - SinaWeiboRequest Delegate

//请求失败回调方法
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error{
    if ([request.url hasSuffix:@"users/show.json"]){
        [self.userInfoDic release], self.userInfoDic = nil;
    }else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [self.statuses release], self.statuses = nil;
    }
}

//请求成功回调方法
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    if ([request.url hasSuffix:@"users/show.json"]){
        [self.userInfoDic release];
        self.userInfoDic = [result retain];
        //NSLog(@"用户信息字典：%@", self.userInfoDic);
        [self setTitle:[self.userInfoDic objectForKey:@"name"]];
    }else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [self.statuses release];
        self.statuses = [[result objectForKey:@"statuses"] retain];
        NSLog(@"%dtimeline:%@", self.statuses.count, [self.statuses objectAtIndex:0]);
        [self.activityIndicator stopAnimating];
        [self refreshWeiBo];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
