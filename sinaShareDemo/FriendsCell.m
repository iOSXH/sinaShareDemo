//
//  FriendsCell.m
//  sinaShareDemo
//
//  Created by word on 13-5-9.
//  Copyright (c) 2013年 com.wordtech. All rights reserved.
//

#import "FriendsCell.h"
#import "EGOImageView.h"

@interface FriendsCell ()

@property (nonatomic, retain) NSMutableDictionary *friendInfoDic;
@property (nonatomic, retain) EGOImageView *iconImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *locationLabel;

@end

@implementation FriendsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addInterface];
    }
    return self;
}

- (void)addFriendDict:(NSMutableDictionary *)aFriendDic{
    self.friendInfoDic = aFriendDic;
    
    NSURL *iconURL = [NSURL URLWithString:[self.friendInfoDic objectForKey:@"avatar_large"]];
//    NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
//    UIImage *icon = [UIImage imageWithData:iconData];
//    [self.iconImageView setImage:icon];
    [self.iconImageView setImageURL:iconURL];
    
    [self.nameLabel setText:[self.friendInfoDic objectForKey:@"name"]];
    
    [self.locationLabel setText:[self.friendInfoDic objectForKey:@"location"]];
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.locationLabel];
}

- (void)addInterface{
    self.iconImageView = [[[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]] autorelease];
    [self.iconImageView setFrame:CGRectMake(10, 3, 50, 50)];
    
    self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200, 40)] autorelease];
    //[self.nameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.nameLabel setTextColor:[UIColor blackColor]];
    [self.nameLabel setBackgroundColor:[UIColor clearColor]];
    [self.nameLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]];
    
    self.locationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200, 40, 100, 15)] autorelease];
    //[self.phoneLabel setTextAlignment:NSTextAlignmentLeft];
    [self.locationLabel setTextColor:[UIColor blackColor]];
    [self.locationLabel setBackgroundColor:[UIColor clearColor]];
    [self.locationLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:10]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
