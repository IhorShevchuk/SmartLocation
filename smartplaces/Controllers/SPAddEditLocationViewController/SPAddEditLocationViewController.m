//
//  SPAddEditLocationViewController.m
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//
#import <MapKit/MapKit.h>

#import "SPAddEditLocationViewController.h"
#import "ELCTextFieldCell.h"
#import "SPCoreDataManager.h"

#import "UINavigationBar+BackgroundColor.h"
#import "CLPlacemark+FormattedAddress.h"
#import "SPPlace+Coordinates.h"
#import "CLGeocoder+formattedAddress.h"


@interface SPAddEditLocationViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, ELCTextFieldDelegate>
@property(nonatomic, strong) MKMapView *mapToSelect;
@property(nonatomic, strong) MKPinAnnotationView *annotationToShowPlace;
@property(nonatomic, strong) NSString *formatedAddress;
@property (weak, nonatomic) IBOutlet UITableView *showingMainTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) ELCTextFieldCell *addressCell;
@end
@implementation SPAddEditLocationViewController
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMap];
    [self setupMainTableView];
    [self setupNaviagationBar];
    if(!self.place) {
        self.place = [SPCoreDataManager newPlaceInstace];
    }
}
#pragma mark - UI
- (void)setupMap {
    self.mapToSelect = [[MKMapView alloc] init];
    self.mapToSelect.delegate = self;
    if(!self.place) {
        [self.mapToSelect setCenterCoordinate:self.mapToSelect.userLocation.location.coordinate animated:YES];
    } else {
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = self.place.coordinates;
        annotationPoint.title = self.place.name;
        annotationPoint.subtitle = self.place.formattedAddres;
        self.annotationToShowPlace = [[MKPinAnnotationView alloc] initWithAnnotation:annotationPoint reuseIdentifier:nil];
        self.annotationToShowPlace.draggable = YES;
        [self.mapToSelect addAnnotation:self.annotationToShowPlace.annotation];
    }
    self.mapToSelect.showsUserLocation = YES;
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 400);
    [UIView animateWithDuration:0.5
                          delay:0.3
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         [self.mapToSelect setFrame:rect];
                     }
                     completion:nil
     ];
}
- (void)setupMainTableView {
    self.showingMainTableView.dataSource = self;
    self.showingMainTableView.delegate = self;
}
- (void)setupNaviagationBar {
    [self.navigationBar showWithColor:MainAppColor];
    if(self.place) {
        self.navigationBar.topItem.title = @"Edit Place";
    }
    else {
        self.navigationBar.topItem.title = @"Add new Place";
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if(indexPath.section == 0)
    {
        ELCTextFieldCell *fieldCell = [[ELCTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [self configureCell:fieldCell atIndexPath:indexPath];
        cell = fieldCell;
    }
    else
    {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selected = NO;
        [cell.contentView addSubview:self.mapToSelect];
    }
    return cell;
}
- (void)configureCell:(ELCTextFieldCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //cell.rightTextField.text = @"";
    switch (indexPath.row)
    {
        case 0:
            cell.rightTextField.tag = 0;
            cell.leftLabel.text = NSLocalizedString(@"Title",@"");
            cell.rightTextField.placeholder = NSLocalizedString(@"Title of location",@"");
            cell.rightTextField.text = self.place.name;
            
            break;
        case 1:
        {
            cell.rightTextField.tag = 1;
            cell.leftLabel.text = NSLocalizedString(@"Address",@"");
            cell.rightTextField.placeholder = NSLocalizedString(@"Full address of location",@"");
            self.addressCell = cell;
            cell.rightTextField.text = self.place.formattedAddres;
            break;
        }
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == 0)
        return 44.0;
  
    return 400.0;
 
}
- (void)textFieldCell:(ELCTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue
{
//    NSMutableArray *newLocInfoMut = [[NSMutableArray alloc] initWithArray:newLocInfo];
    switch (inIndexPath.row)
    {
        case 0:
            self.place.name = inValue;
            break;
            
        case 1:
        {
            __weak SPAddEditLocationViewController *selfWeak = self;
            NSString *location = inValue;
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:location
                         completionHandler:^(NSArray *placemarks, NSError *error){
                             if(error) {
                                 return;
                             }
                             if (placemarks && placemarks.count > 0)
                             {
                                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                 MKCoordinateRegion region = selfWeak.mapToSelect.region;
                                 region.center = [(CLCircularRegion *)placemark.region center];
                                 NSUInteger count = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] count];
                                 
                                 switch (count)
                                 {
                                     case 1:
                                         region.span.latitudeDelta = region.span.longitudeDelta = 10.0;
                                         break;
                                     case 2:
                                         region.span.latitudeDelta = region.span.longitudeDelta = 4.2;
                                         break;
                                     case 3:
                                         region.span.latitudeDelta = region.span.longitudeDelta = 0.04;
                                         
                                         break;
                                     default:
                                         break;
                                 }
                                
                                 MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc]init];
                                 annotationPoint.coordinate = placemark.location.coordinate;
                                 annotationPoint.title = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] objectAtIndex:0];
                                 
                                 annotationPoint.subtitle = placemark.country;
                                 if(count > 2)
                                     annotationPoint.subtitle = placemark.locality;
                                 selfWeak.place.lat = [NSNumber numberWithFloat:annotationPoint.coordinate.latitude];
                                selfWeak.place.lon = [NSNumber numberWithFloat:annotationPoint.coordinate.longitude];

                                 [selfWeak.mapToSelect setRegion:region animated:YES];
                                 [selfWeak.mapToSelect removeAnnotation:selfWeak.annotationToShowPlace.annotation];
                                 selfWeak.annotationToShowPlace = [[MKPinAnnotationView alloc] initWithAnnotation:annotationPoint reuseIdentifier:nil];
                                 selfWeak.annotationToShowPlace.draggable = YES;
                                 
                                 [selfWeak.mapToSelect removeAnnotation:selfWeak.annotationToShowPlace.annotation];
                                 [selfWeak.mapToSelect addAnnotation:selfWeak.annotationToShowPlace.annotation];
                             }
                         }
             ];
            break;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
#pragma mark -map view
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation
{
    if(self.annotationToShowPlace != nil) {
        return;
    }
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = location;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    self.annotationToShowPlace = [[MKPinAnnotationView alloc] initWithAnnotation:annotationPoint reuseIdentifier:nil];
    __weak SPAddEditLocationViewController *selfWeak = self;
    [geocoder reverseGeocodeWithFormatedAddressLocation:clLocation completionHandler:^(NSString *formattedAddres,CLLocationCoordinate2D coordinates,NSError *error){
        selfWeak.place.lon = [NSNumber numberWithFloat:coordinates.longitude];
        selfWeak.place.lat = [NSNumber numberWithFloat:coordinates.latitude];
        selfWeak.place.formattedAddres = formattedAddres;
        
        MKPointAnnotation *annotationPoint;
        annotationPoint = selfWeak.annotationToShowPlace.annotation;
        annotationPoint.title = selfWeak.place.name;
        annotationPoint.subtitle = formattedAddres;
    }];
    
    self.annotationToShowPlace.draggable = YES;
    [self.mapToSelect addAnnotation:self.annotationToShowPlace.annotation];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {

        return nil;
    }
    static NSString *GeoPointAnnotationIdentifier = @"RedPin";
    
    return self.annotationToShowPlace;
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
    
//    if (!annotationView)
//    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GeoPointAnnotationIdentifier];
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
        annotationView.draggable = YES;
        annotationView.animatesDrop = YES;
//    }
    
    return annotationView;
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    for(MKAnnotationView *annotationView in views) {
        if([annotationView.annotation isEqual:mapView.userLocation]) {
            [annotationView setEnabled:![annotationView.annotation isEqual:mapView.userLocation]];
            [annotationView.superview sendSubviewToBack:annotationView];
        }
    }
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView resignFirstResponder];
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    for(UIView *view in mapView.subviews)
    {
        [view resignFirstResponder];
        if([view isKindOfClass:[ELCTextFieldCell class]])
        {
            [((ELCTextFieldCell *)view).rightTextField resignFirstResponder];
        }
    }
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
    __weak SPAddEditLocationViewController *selfWeak = self;
    [geocoder reverseGeocodeWithFormatedAddressLocation:location completionHandler:^(NSString *formattedAddres,CLLocationCoordinate2D coordinates,NSError *error){
        selfWeak.place.lon = [NSNumber numberWithFloat:coordinates.longitude];
        selfWeak.place.lat = [NSNumber numberWithFloat:coordinates.latitude];
        selfWeak.place.formattedAddres = formattedAddres;
        
        MKPointAnnotation *annotationPoint;
        annotationPoint = view.annotation;
        annotationPoint.title = selfWeak.place.name;
        annotationPoint.subtitle = formattedAddres;
    }];
    self.addressCell.rightTextField.text = self.place.formattedAddres;
}
#pragma mark - Buttons Actions
- (IBAction)cancelButtonAction:(id)sender {
    [SPCoreDataManager rollback];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)doneButtonAction:(id)sender {
    if([self.place.name length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.tag = 0;
        [alert setTitle:NSLocalizedString(@"Alert!",@"")];
        [alert setMessage:NSLocalizedString(@"You need set 'Title' field",@"")];
        [alert addButtonWithTitle:NSLocalizedString(@"Ok",@"")];
        [alert show];
        return;
    }
    if([self.place.formattedAddres length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.tag = 0;
        [alert setTitle:NSLocalizedString(@"Alert!",@"")];
        //FIX IT: no Localiztion
        [alert setMessage:NSLocalizedString(@"You need set 'Address' field",@"")];
        [alert addButtonWithTitle:NSLocalizedString(@"Ok",@"")];
        [alert show];
        return;
    }
    
    CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:[self.place.lat doubleValue] longitude:[self.place.lon doubleValue]];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __weak SPAddEditLocationViewController *selfWeak = self;
    [geocoder reverseGeocodeWithFormatedAddressLocation:clLocation completionHandler:^(NSString *formattedAddres,CLLocationCoordinate2D coordinates,NSError *error){
        selfWeak.place.formattedAddres = formattedAddres;
        [SPCoreDataManager saveContext];
        [selfWeak dismissViewControllerAnimated:YES completion:^{}];
    }];
    
}
@end
