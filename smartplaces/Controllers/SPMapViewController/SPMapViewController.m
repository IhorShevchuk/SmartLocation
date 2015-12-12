//
//  SPMapViewController.m
//  smartplaces
//
//  Created by Admin on 12/11/15.
//  Copyright © 2015 ihor. All rights reserved.
//
#import <MapKit/MapKit.h>

#import "SPMapViewController.h"
#import "SPPinAnnotation.h"
#import "UINavigationBar+BackgroundColor.h"
#import "TMFloatingButton.h"
#import "SPCoreDataManager.h"
@interface SPMapViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;
@end

@implementation SPMapViewController
//TODO: add internet conection check
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setupNavigationBar];
    [self setupAddButton];
    [self setupMap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSSet *plases = [SPCoreDataManager getCurrentUser].places;
    [self addPlacesToMap:plases];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"editLocation"]|| [segue.identifier isEqualToString:@"addLocation"]) {
        
        if([segue.identifier isEqualToString:@"editLocation"]) {
            //TODO: add edited location
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
}
- (void)addPlacesToMap:(NSSet*)places {
    NSMutableArray *annotations = [[NSMutableArray alloc]initWithCapacity:places.count];
    NSArray *annotationsToRemove = self.mainMapView.annotations;
    for(SPPlace *place in places) {
        CLLocationCoordinate2D coordinates;
        coordinates.latitude = [place.lat doubleValue];
        coordinates.longitude = [place.lon doubleValue];
        SPPinAnnotation *annotationToAdd = [[SPPinAnnotation alloc]initWithCoordinate:coordinates andTitle:place.name andSubTitle:place.formattedAddres];
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
    }
    
    return annotationView;
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
