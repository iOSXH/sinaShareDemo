//
//  FriendshipsViewController.m
//  sinaShareDemo
//
//  Created by word on 13-5-9.
//  Copyright (c) 2013年 com.wordtech. All rights reserved.
//

#import "FriendshipsViewController.h"
#import "FriendsCell.h"

@interface FriendshipsViewController ()

@property (nonatomic, retain) SinaWeibo *sina;
@property (nonatomic, retain) NSMutableDictionary *userInfoDic;
@property (nonatomic, retain) NSMutableArray *tempArr;
@property (nonatomic, retain) NSMutableArray *friendsArr;
@property (nonatomic, retain) NSMutableArray *followersArr;
@property (nonatomic, retain) NSMutableArray *bilateralFriendsArr;
@property (nonatomic, retain) UISegmentedControl *mySeg;
@property (nonatomic, retain) UIView *animationView;
@property (nonatomic, retain) UITableView *friendsTableView;
@property (nonatomic, retain) UITableView *followersTableView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end

@implementation FriendshipsViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.activityIndicator setCenter:CGPointMake(150, 130)];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator release];
    [self.activityIndicator startAnimating];
    
    BOOL authValid = self.sina.isAuthValid;
    if (authValid) {
        [self.sina requestWithURL:@"users/show.json" params:[NSMutableDictionary dictionaryWithObject:self.sina.userID forKey:@"uid"] httpMethod:@"GET" delegate:self];
        
        [self.sina requestWithURL:@"friendships/friends.json"
                           params:[NSMutableDictionary dictionaryWithObject:self.sina.userID forKey:@"uid"]
                       httpMethod:@"GET"
                         delegate:self];
        
        [self.sina requestWithURL:@"friendships/friends/bilateral.json"
                           params:[NSMutableDictionary dictionaryWithObject:self.sina.userID forKey:@"uid"]
                       httpMethod:@"GET"
                         delegate:self];
        
        [self.sina requestWithURL:@"friendships/followers.json"
                           params:[NSMutableDictionary dictionaryWithObject:self.sina.userID forKey:@"uid"]
                       httpMethod:@"GET"
                         delegate:self];
    }
    
    self.mySeg = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"关注", @"粉丝", @"互相关注", nil]] autorelease];
    [self.mySeg setFrame:CGRectMake(0, 0, 320, 50)];
    [self.mySeg setSelectedSegmentIndex:0];
    [self.mySeg addTarget:self action:@selector(changeView) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.mySeg];
    
    self.animationView = [[[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 370)] autorelease];
    [self.animationView setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:self.animationView];
    
    self.friendsTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 370) style:UITableViewStyleGrouped] autorelease];
    [self.friendsTableView setDataSource:self];
    [self.friendsTableView setDelegate:self];
    [self.friendsTableView addSubview:self.activityIndicator];
    [self.animationView addSubview:self.friendsTableView];

}

- (void)changeView{//响应segmentControl事件
    //获取当前点击的segment
    NSInteger currentClickedSement = [self.mySeg selectedSegmentIndex];
    
    [UIView beginAnimations:@"sss" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.animationView cache:NO];
    
    switch (currentClickedSement) {
        case 0:
            for (UIView *view in [self.animationView subviews]) {
                [view removeFromSuperview];
            }
            self.tempArr = self.friendsArr;
            [self.friendsTableView reloadData];
            [self.animationView addSubview:self.friendsTableView];
            break;
        case 1:
            for (UIView *view in [self.animationView subviews]) {
                [view removeFromSuperview];
            }
            self.tempArr = self.followersArr;
            [self.friendsTableView reloadData];
            [self.animationView addSubview:self.friendsTableView];
            break;
        case 2:
            for (UIView *view in [self.animationView subviews]) {
                [view removeFromSuperview];
            }
            self.tempArr = self.bilateralFriendsArr;
            [self.friendsTableView reloadData];
            [self.animationView addSubview:self.friendsTableView];
            break;
        default:
            break;
    }
    
    [UIView commitAnimations];
}


#pragma mark - SinaWeiboRequest Delegate

//请求失败回调方法
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error{
    if ([request.url hasSuffix:@"users/show.json"]){
        [self.userInfoDic release], self.userInfoDic = nil;
    }else if ([request.url hasSuffix:@"friendships/friends.json"])
    {
        [self.friendsArr release], self.friendsArr = nil;
    }
    else if ([request.url hasSuffix:@"friendships/friends/bilateral.json"])
    {
        [self.bilateralFriendsArr release], self.bilateralFriendsArr = nil;
    }
    else if ([request.url hasSuffix:@"friendships/followers.json"])
    {
        [self.followersArr release], self.followersArr = nil;
    }
}

//请求成功回调方法
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    if ([request.url hasSuffix:@"users/show.json"]){
        [self.userInfoDic release];
        self.userInfoDic = [result retain];
        //NSLog(@"用户信息字典：%@", self.userInfoDic);
        [self setTitle:[self.userInfoDic objectForKey:@"name"]];
    }else if ([request.url hasSuffix:@"friendships/friends.json"])
    {
        //NSLog(@"%@", result);
        [self.friendsArr release];
        self.friendsArr = [[result objectForKey:@"users"] retain];
        //NSLog(@"%dtimeline:%@", self.friendsArr.count, [self.friendsArr objectAtIndex:0] );
    }else if ([request.url hasSuffix:@"friendships/friends/bilateral.json"])
    {
        //NSLog(@"%@", result);
        [self.bilateralFriendsArr release];
        self.bilateralFriendsArr = [[result objectForKey:@"users"] retain];
        
    }else if ([request.url hasSuffix:@"friendships/followers.json"])
    {
        //NSLog(@"%@", result);
        [self.followersArr release];
        self.followersArr = [[result objectForKey:@"users"] retain];
    }
    
    [self.activityIndicator stopAnimating];
    self.tempArr = self.friendsArr;
    [self.friendsTableView reloadData];

}

#pragma mark - tableView Delegate

//设置每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

//设置cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tempArr.count;
}

//设置每个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id = @"friendCellID";
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[[FriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id] autorelease];
    }
    [cell addFriendDict:[self.tempArr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
