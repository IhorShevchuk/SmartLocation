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

@interface SPSideMenuViewController()
@property (weak, nonatomic) IBOutlet UIImageView *usersAvatar;
@property (weak, nonatomic) IBOutlet UILabel *usersNameLabel;

@end
@implementation SPSideMenuViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
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
    
}
- (void)showListAction:(id)sender {
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   // UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
   // [cell setSelected:NO animated:YES];
    switch (indexPath.row) {
        case 1:
        
            break;
        case 2:
            
            break;
        case 3:
            [self logoutAction:tableView];
            break;
        default:
            break;
    }
}
@end
