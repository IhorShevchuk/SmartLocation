//
//  SPSPLoginViewController.m
//  smartplaces
//
//  Created by Admin on 12/8/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "SPLoginViewController.h"
#import "SPFacebookUser+Converter.h"
#import "SPUserManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SPLoginViewController ()<FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginButton;

@end

@implementation SPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SPFacebookUser *user = [SPUserManager getCurrentUser]   ; NSLog(@"%@",user);
    if([SPUserManager getCurrentUser]) {
        [self performSegueWithIdentifier:@"showMapView" sender:self];
    }
    else {
        //TODO: add Animations
        [self.facebookLoginButton setHidden:NO];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error {
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 SPFacebookUser *loggedUser = [SPFacebookUser userFromFacebookResponce:result];
                 [SPUserManager saveToKeyChainUser:loggedUser];
                 [self performSegueWithIdentifier:@"showMapView" sender:self];
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}
@end
