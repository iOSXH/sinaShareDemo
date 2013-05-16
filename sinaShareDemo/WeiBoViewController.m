//
//  WeiBoViewController.m
//  sinaShareDemo
//
//  Created by word on 13-5-10.
//  Copyright (c) 2013年 com.wordtech. All rights reserved.
//

#import "WeiBoViewController.h"
#import "EGOImageView.h"

@interface WeiBoViewController ()

@property (nonatomic, retain) SinaWeibo *sina;
@property (nonatomic, retain) NSMutableArray *weiBoArr;
@property (nonatomic, retain) UITableView *weiBoTabelView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end

@implementation WeiBoViewController

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
    //[self.view addSubview:self.activityIndicator];
    [self.activityIndicator release];
    [self.activityIndicator startAnimating];
    
    BOOL authValid = self.sina.isAuthValid;
    if (authValid) {
        [self.sina requestWithURL:@"statuses/friends_timeline.json" params:nil httpMethod:@"GET" delegate:self];
    }
    
    UIBarButtonItem *rightBarBtnItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWeiBo)] autorelease];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    self.weiBoTabelView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 420) style:UITableViewStylePlain] autorelease];
    [self.weiBoTabelView setDataSource:self];
    [self.weiBoTabelView setDelegate:self];
    [self.weiBoTabelView addSubview:self.activityIndicator];
    [self.view addSubview:self.weiBoTabelView];
}

//刷新微博
- (void)refreshWeiBo{
    
    
    [self.activityIndicator startAnimating];
    
    BOOL authValid = self.sina.isAuthValid;
    if (authValid) {
        [self.sina requestWithURL:@"statuses/friends_timeline.json" params:nil httpMethod:@"GET" delegate:self];
    }

}

//添加每条微博的View
- (UIView *)addEachWeiBoViewWithNum:(int)num{
    NSMutableDictionary *eachWeiBoDic = [self.weiBoArr objectAtIndex:num];
    
    NSMutableDictionary *userDic = [eachWeiBoDic objectForKey:@"user"];
    NSURL *iconURL = [NSURL URLWithString:[userDic objectForKey:@"avatar_large"]];
    EGOImageView *iconImageView = [[[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]] autorelease];
    [iconImageView setFrame:CGRectMake(10, 3, 50, 50)];
    [iconImageView setImageURL:iconURL];
    
    UILabel *userNameLab = [[[UILabel alloc] initWithFrame:CGRectMake(65, 5, 155, 20)] autorelease];
    [userNameLab setTextColor:[UIColor blackColor]];
    [userNameLab setBackgroundColor:[UIColor clearColor]];
    [userNameLab setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
    [userNameLab setText:[userDic objectForKey:@"name"]];
    
    
    UILabel *eachTextLab = [[[UILabel alloc] initWithFrame:CGRectMake(65, 0, 0,0)] autorelease];
    [eachTextLab setNumberOfLines:0];
    CGSize size = CGSizeMake(245,2000);
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    CGSize labSize = [[eachWeiBoDic objectForKey:@"text"] sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [eachTextLab setFrame:CGRectMake(65, 30, labSize.width, labSize.height)];
    [eachTextLab setFont:font];
    [eachTextLab setText:[eachWeiBoDic objectForKey:@"text"]];
    [eachTextLab setBackgroundColor:[UIColor clearColor]];
    
    NSString *thumbnail_pic = [eachWeiBoDic objectForKey:@"thumbnail_pic"];
    EGOImageView *imageView = nil;
    if (thumbnail_pic) {
        NSURL *imageURL = [NSURL URLWithString:thumbnail_pic];
        imageView = [[[EGOImageView alloc] initWithPlaceholderImage:nil] autorelease];
        [imageView setImageURL:imageURL];
        [imageView setFrame:CGRectMake(65, eachTextLab.frame.origin.y+eachTextLab.frame.size.height+5, 150, 200)];
    }
    
    NSMutableDictionary *retweetedStatusDic = [eachWeiBoDic objectForKey:@"retweeted_status"];
    UILabel *retweetedUserNameLab = nil;
    UILabel *retweetedEachTextLab = nil;
    if (retweetedStatusDic) {
        NSMutableDictionary *retweetedUserDic = [retweetedStatusDic objectForKey:@"user"];
        retweetedUserNameLab = [[[UILabel alloc] initWithFrame:CGRectMake(65, eachTextLab.frame.origin.y+eachTextLab.frame.size.height+5, 200, 20)] autorelease];
        [retweetedUserNameLab setTextColor:[UIColor blackColor]];
        [retweetedUserNameLab setBackgroundColor:[UIColor clearColor]];
        [retweetedUserNameLab setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
        [retweetedUserNameLab setText:[retweetedUserDic objectForKey:@"name"]];
        [retweetedEachTextLab setBackgroundColor:[UIColor clearColor]];
        
        retweetedEachTextLab = [[[UILabel alloc] initWithFrame:CGRectMake(65, 0, 0,0)] autorelease];
        [retweetedEachTextLab setNumberOfLines:0];
        CGSize size = CGSizeMake(245,2000);
        UIFont *font = [UIFont fontWithName:@"Arial" size:12];
        CGSize labSize = [[retweetedStatusDic objectForKey:@"text"] sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        [retweetedEachTextLab setFrame:CGRectMake(65, eachTextLab.frame.origin.y+eachTextLab.frame.size.height+30, labSize.width, labSize.height)];
        [retweetedEachTextLab setFont:font];
        [retweetedEachTextLab setText:[retweetedStatusDic objectForKey:@"text"]];
        
        NSString *thumbnail_pic = [retweetedStatusDic objectForKey:@"thumbnail_pic"];
        if (thumbnail_pic) {
            NSURL *imageURL = [NSURL URLWithString:thumbnail_pic];
            imageView = [[[EGOImageView alloc] initWithPlaceholderImage:nil] autorelease];
            [imageView setFrame:CGRectMake(65, retweetedEachTextLab.frame.origin.y+retweetedEachTextLab.frame.size.height+5, 150, 200)];
            [imageView setImageURL:imageURL];
        }
    }
    
    
    UILabel *reportsLab = [[[UILabel alloc] initWithFrame:CGRectMake(220, 5, 50, 20)] autorelease];
    [reportsLab setTextColor:[UIColor blackColor]];
    [reportsLab setBackgroundColor:[UIColor clearColor]];
    [reportsLab setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:15]];
    int reportsCount = [[eachWeiBoDic objectForKey:@"reposts_count"] intValue];
    NSString *reports = [NSString stringWithFormat:@"转:%d",reportsCount];
    [reportsLab setText:reports];
    
    UILabel *commentsLab = [[[UILabel alloc] initWithFrame:CGRectMake(270, 5, 50, 20)] autorelease];
    [commentsLab setTextColor:[UIColor blackColor]];
    [commentsLab setBackgroundColor:[UIColor clearColor]];
    [commentsLab setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:15]];
    int commentsCount = [[eachWeiBoDic objectForKey:@"reposts_count"] intValue];
    NSString *comments = [NSString stringWithFormat:@"转:%d",commentsCount];
    [commentsLab setText:comments];
    [commentsLab setText:comments];

    
    CGFloat height = 0;
    if (imageView) {
        height = imageView.frame.origin.y + imageView.frame.size.height;
    }else if(retweetedEachTextLab){
        height = retweetedEachTextLab.frame.origin.y + retweetedEachTextLab.frame.size.height;
    }else{
        height = eachTextLab.frame.origin.y + eachTextLab.frame.size.height;
        
        CGFloat tempHeight = iconImageView.frame.origin.y + iconImageView.frame.size.height;
        if (height <= tempHeight) {
            height = tempHeight;
        }
    }
    
    NSString *timeStr = [eachWeiBoDic objectForKey:@"created_at"];
    timeStr = [[timeStr componentsSeparatedByString:@" "] objectAtIndex:3];
    NSString *sourceStr = [eachWeiBoDic objectForKey:@"source"];
    sourceStr = [[sourceStr componentsSeparatedByString:@">"] objectAtIndex:1];
    sourceStr = [[sourceStr componentsSeparatedByString:
                  @"<"] objectAtIndex:0];
    sourceStr = [timeStr stringByAppendingFormat:@"  %@", sourceStr];
    
    UILabel *sourceLab = [[[UILabel alloc] initWithFrame:CGRectMake(65, height + 5, 200, 20)] autorelease];
    [sourceLab setTextColor:[UIColor blackColor]];
    [sourceLab setBackgroundColor:[UIColor clearColor]];
    [sourceLab setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:15]];
    [sourceLab setText:sourceStr];
    
    int attitudesCount = [[eachWeiBoDic objectForKey:@"attitudes_count"] intValue];
    NSString *attitudesStr = [NSString stringWithFormat:@"赞:%d",attitudesCount];
    UIButton *attitudesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [attitudesBtn setFrame:CGRectMake(260, height + 5, 50, 20)];
    [attitudesBtn setTitle:attitudesStr forState:UIControlStateNormal];
    [attitudesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [attitudesBtn addTarget:self action:@selector(attitudesBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 5, 320, height+30)] autorelease];
    [containerView setBackgroundColor:[UIColor orangeColor]];
    
    [containerView addSubview:userNameLab];
    [containerView addSubview:imageView];
    [containerView addSubview:retweetedUserNameLab];
    [containerView addSubview:retweetedEachTextLab];
    [containerView addSubview:iconImageView];
    [containerView addSubview:userNameLab];
    [containerView addSubview:eachTextLab];
    [containerView addSubview:reportsLab];
    [containerView addSubview:commentsLab];
    [containerView addSubview:sourceLab];
    [containerView addSubview:attitudesBtn];
    //[self.view addSubview:containerView];
    return containerView;
}

- (void)attitudesBtnClicked{
    NSLog(@"赞");
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.weiBoArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self addEachWeiBoViewWithNum:indexPath.row].frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id = @"weiBoCellID";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    //if (!cell) {
       UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id] autorelease];
    //}
    [cell.contentView addSubview:[self addEachWeiBoViewWithNum:indexPath.row]];
    
    return cell;

}

#pragma mark - SinaWeiboRequest Delegate

//请求失败回调方法
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error{
    if ([request.url hasSuffix:@"statuses/friends_timeline.json"]){
        [self.weiBoArr release], self.weiBoArr = nil;
    }
}

//请求成功回调方法
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    NSLog(@"success");
    if ([request.url hasSuffix:@"statuses/friends_timeline.json"]){
        NSLog(@"success");
        [self.weiBoArr release];
        self.weiBoArr = [[result objectForKey:@"statuses"] retain];

        NSLog(@"第一条微博：%@", [self.weiBoArr objectAtIndex:0]);
        //[self addEachWeiBoView];
        [self.weiBoTabelView reloadData];
        [self.activityIndicator stopAnimating];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
