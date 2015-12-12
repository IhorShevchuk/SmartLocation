//
//  SPSideMenuViewController.m
//  smartplaces
//
//  Created by Admin on 12/11/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "SPSideMenuViewController.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "UIImageView+WebCache.h"

#import "SPFacebookUser.h"
#import "SPUserManager.h"

#import "SPMapViewController.h"
#import "SPSavedPlacesViewController.h"

@interface SPSideMenuViewController()
@property (weak, nonatomic) IBOutlet UIImageView *usersAvatar;
@property (weak, nonatomic) IBOutlet UILabel *usersNameLabel;

@end
@implementation SPSideMenuViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    [self setupUser];
}
#pragma mark - UI
- (void)setupUser {
    self.usersAvatar.layer.cornerRadius = self.usersAvatar.frame.size.height / 2.0;
    [self.usersAvatar setClipsToBounds:YES];
    
    SPFacebookUser *user = [SPUserManager getCurrentUser];
    self.usersNameLabel.text = user.name.length > 0 ? user.name: @"New user";
    [self.usersAvatar sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatarPlaceHolder"]];
}
#pragma mark - Buttons actions
- (void)logoutAction:(id)sender {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    
    [[JASidePanelController sharedInstance] toggleLeftPanel:self];
    [SPUserManager clearCurrentUser];
    [((UINavigationController*)[[JASidePanelController sharedInstance] centerPanel]) popToRootViewControllerAnimated:YES];
}
- (void)showMapAction:(id)sender {
    if([[JASidePanelController sharedInstance].centerPanel isKindOfClass:[SPMapViewController class]]) {
        
    }
    else {
        [JASidePanelController sharedInstance].centerPanel = [[UINavigationController alloc]initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SPMapViewController"]];
    }
}
- (void)showListAction:(id)sender {
    if([[JASidePanelController sharedInstance].centerPanel isKindOfClass:[SPSavedPlacesViewController class]]) {
        
    }
    else {
        [JASidePanelController sharedInstance].centerPanel = [[UINavigationController alloc]initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SPSavedPlacesViewController"]];
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:
            [self showMapAction:tableView];
            break;
        case 2:
            [self showListAction:tableView];
            break;
        case 3:
            [self logoutAction:tableView];
            break;
        default:
            break;
    }
}
@end
