//
//  SPMapViewController.m
//  smartplaces
//
//  Created by Admin on 12/11/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "SPMapViewController.h"
#import "JASidePanelController+fakeSharedInstance.h"

@interface SPMapViewController ()

@end

@implementation SPMapViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI
- (void)setupNavigationBar {

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithImage:[JASidePanelController defaultImage] style:UIBarButtonItemStylePlain target:self action:@selector(toggleSideMenu:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    //TODO: add image
    UIBarButtonItem *goToMyLocationButton = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(goToMyLocation:)];
    self.navigationItem.rightBarButtonItem = goToMyLocationButton;
}

#pragma mark - Buttons Actions
- (void)toggleSideMenu:(id)sender {
    [[JASidePanelController sharedInstance] toggleLeftPanel:self];
}
- (void)goToMyLocation:(id)sender {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
