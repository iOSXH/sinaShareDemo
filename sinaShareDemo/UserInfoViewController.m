//
//  UserInfoViewController.m
//  sinaShareDemo
//
//  Created by word on 13-5-8.
//  Copyright (c) 2013年 com.wordtech. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@property (nonatomic, retain) SinaWeibo *sina;
@property (nonatomic, retain) NSMutableDictionary *userInfoDic;
@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *nameLab;
@property (nonatomic, retain) UILabel *genderLab;
@property (nonatomic, retain) UILabel *descriptionLab;
@property (nonatomic, retain) UILabel *locationLab;
@property (nonatomic, retain) UILabel *friendsLab;
@property (nonatomic, retain) UILabel *followersLab;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end

@implementation UserInfoViewController

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
    [self setTitle:@"用户信息"];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.activityIndicator setCenter:CGPointMake(150, 130)];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator release];
    [self.activityIndicator startAnimating];
    
    BOOL authValid = self.sina.isAuthValid;
    if (authValid){
        [self.sina requestWithURL:@"users/show.json" params:[NSMutableDictionary dictionaryWithObject:self.sina.userID forKey:@"uid"] httpMethod:@"GET" delegate:self];
    }

    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [self.iconImageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    
    self.nameLab = [[[UILabel alloc] initWithFrame:CGRectMake(150, 10, 150, 25)] autorelease];
    [self.nameLab setTextColor:[UIColor blackColor]];
    [self.nameLab setBackgroundColor:[UIColor clearColor]];
    [self.nameLab setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:25]];
    [self.view addSubview:self.nameLab];
    
    self.genderLab = [[[UILabel alloc] initWithFrame:CGRectMake(150, 40, 150, 25)] autorelease];
    [self.genderLab setTextColor:[UIColor blackColor]];
    [self.genderLab setBackgroundColor:[UIColor clearColor]];
    [self.genderLab setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
    [self.view addSubview:self.genderLab];
    
    self.locationLab = [[[UILabel alloc] initWithFrame:CGRectMake(150, 70, 170, 25)] autorelease];
    [self.locationLab setTextColor:[UIColor blackColor]];
    [self.locationLab setBackgroundColor:[UIColor clearColor]];
    [self.locationLab setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
    [self.view addSubview:self.locationLab];
    
    self.friendsLab = [[[UILabel alloc] initWithFrame:CGRectMake(20, 130, 100, 30)] autorelease];
    [self.friendsLab setTextColor:[UIColor blackColor]];
    [self.friendsLab setBackgroundColor:[UIColor clearColor]];
    [self.friendsLab setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
    [self.view addSubview:self.friendsLab];
    
    self.followersLab = [[[UILabel alloc] initWithFrame:CGRectMake(160, 130, 100, 30)] autorelease];
    [self.followersLab setTextColor:[UIColor blackColor]];
    [self.followersLab setBackgroundColor:[UIColor clearColor]];
    [self.followersLab setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
    [self.view addSubview:self.followersLab];
    
    self.descriptionLab = [[[UILabel alloc] initWithFrame:CGRectMake(20, 200, 290, 30)] autorelease];
    [self.descriptionLab setTextColor:[UIColor blackColor]];
    [self.descriptionLab setBackgroundColor:[UIColor clearColor]];
    [self.descriptionLab setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
    [self.view addSubview:self.descriptionLab];
}

- (void)addInfo{
    NSURL *iconURL = [NSURL URLWithString:[self.userInfoDic objectForKey:@"avatar_large"]];
    NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
    UIImage *icon = [UIImage imageWithData:iconData];
    [self.iconImageView setImage:icon];
    [self.view addSubview:self.iconImageView];

    
    [self.nameLab setText:[self.userInfoDic objectForKey:@"name"]];
    
    NSString *gender = [self.userInfoDic objectForKey:@"gender"];
    if ([gender isEqualToString:@"m"]) {
        [self.genderLab setText:@"性别：男"];
    }else if([gender isEqualToString:@"f"]){
        [self.genderLab setText:@"性别：女"];
    }else{
        [self.genderLab setText:@"性别：未知"];
    }
    
    [self.locationLab setText:[self.userInfoDic objectForKey:@"location"]];
    
    int friends_count = [[self.userInfoDic objectForKey:@"friends_count"] intValue];
    [self.friendsLab setText:[NSString stringWithFormat:@"关注：%d", friends_count]];
    
    int followers_count  = [[self.userInfoDic objectForKey:@"followers_count"] intValue];
    [self.followersLab setText:[NSString stringWithFormat:@"关注：%d", followers_count]];
    
    NSString *text = nil;
    if ([[self.userInfoDic objectForKey:@"description"] length] <= 0) {
        text = @"个人简介：暂无简介";
    }else{
        text = [NSString stringWithFormat:@"个人简介：%@",[self.userInfoDic objectForKey:@"description"]];
    }
    CGSize size = CGSizeMake(290,2000);
    UIFont *font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    CGSize labSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.descriptionLab setText:text];
    [self.descriptionLab setFrame:CGRectMake(20, 200, labSize.width, labSize.height)];
}

#pragma mark - SinaWeiboRequest Delegate

//请求失败回调方法
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error{
    if ([request.url hasSuffix:@"users/show.json"]){
        [self.userInfoDic release], self.userInfoDic = nil;
    }
}

//请求成功回调方法
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    if ([request.url hasSuffix:@"users/show.json"]){
        [self.userInfoDic release];
        self.userInfoDic = [result retain];
        //NSLog(@"用户信息字典：%@", self.userInfoDic);
        [self.activityIndicator stopAnimating];
        [self addInfo];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
