//
//  SPMapViewController.m
//  smartplaces
//
//  Created by Admin on 12/11/15.
//  Copyright © 2015 ihor. All rights reserved.
//
#import <MapKit/MapKit.h>

#import "AFNetworking.h"
#import "SPMapViewController.h"
#import "SPAddEditLocationViewController.h"

#import "SPPinAnnotation.h"
#import "UINavigationBar+BackgroundColor.h"
#import "TMFloatingButton.h"
#import "SPCoreDataManager.h"
#import "SPFindMyLocation.h"
@interface SPMapViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;
@property (strong, nonatomic) SPPlace *selectedPlace;
@end

@implementation SPMapViewController
//TODO: add internet conection check
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setupNavigationBar];
    [self setupAddButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupMap];
    NSSet *plases = [SPCoreDataManager getCurrentUser].places;
    [self addPlacesToMap:plases];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"editLocation"]|| [segue.identifier isEqualToString:@"addLocation"]) {
        
        if([segue.identifier isEqualToString:@"editLocation"]) {
            SPAddEditLocationViewController *destination = segue.destinationViewController;
            destination.place = self.selectedPlace;
            self.selectedPlace = nil;
        }
    }
}
#pragma mark - UI
- (void)setupAddButton {
    TMFloatingButton *addButton = [[TMFloatingButton alloc]initWithSuperView:self.view];
    [addButton addStateWithText:@"add" withAttributes:@{} andBackgroundColor:MainAppColor forName:@"add" applyRightNow:YES];
    [addButton addTarget:self action:@selector(addNewPinAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setupNavigationBar {

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithImage:[JASidePanelController defaultImage] style:UIBarButtonItemStylePlain target:self action:@selector(toggleSideMenu:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    //TODO: add image
    UIBarButtonItem *goToMyLocationButton = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(goToMyLocation:)];
    self.navigationItem.rightBarButtonItem = goToMyLocationButton;
    
    [self.navigationController.navigationBar showWithColor:MainAppColor];
}
- (void)setupMap {
    self.mainMapView.delegate = self;
    __weak SPMapViewController *selfWeak = self;
    [SPFindMyLocation findMyLocation:^(CLLocationCoordinate2D coordinates,NSError *errorMessage){
        if(errorMessage != nil) {
        selfWeak.mainMapView.showsUserLocation = YES;
        [selfWeak.mainMapView setRegion:MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.11, 0.11)) animated:YES];
        }
    }];
}
- (void)addPlacesToMap:(NSSet*)places {
    NSMutableArray *annotations = [[NSMutableArray alloc]initWithCapacity:places.count];
    NSArray *annotationsToRemove = self.mainMapView.annotations;
    for(SPPlace *place in places) {
        SPPinAnnotation *annotationToAdd = [[SPPinAnnotation alloc]initWithPlace:place];
        [annotations addObject:annotationToAdd];
    }
    
    [self.mainMapView addAnnotations:annotations];
    [self.mainMapView removeAnnotations:annotationsToRemove];
}
#pragma mark - Buttons Actions
- (void)toggleSideMenu:(id)sender {
    [[JASidePanelController sharedInstance] toggleLeftPanel:self];
}
- (void)goToMyLocation:(id)sender {
    
}
- (void)addNewPinAction:(id)sender {
    [self performSegueWithIdentifier:@"addLocation" sender:self];
}
#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *GeoPointAnnotationIdentifier = @"RedPin";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
    
    if (!annotationView)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GeoPointAnnotationIdentifier];
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
        annotationView.draggable = NO;
        annotationView.animatesDrop = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }
    
    return annotationView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    SPPinAnnotation *pinAnnotation = view.annotation;
    if([pinAnnotation isKindOfClass:[SPPinAnnotation class]]) {
        self.selectedPlace = pinAnnotation.place;
        [self performSegueWithIdentifier:@"editLocation" sender:self];
    }
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
