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
    [self.mapToSelect setCenterCoordinate:self.mapToSelect.userLocation.location.coordinate animated:YES];
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    switch (textField.tag)
    //    {
    //        case 0:
    //            newLoc.name_ = textField.text;
    //            break;
    //        case 1:
    //        {
    //            newLoc.address_ = textField.text;
    //            break;
    //        }
    //        case 2:
    //            newLoc.notes_ = textField.text;
    //            break;
    //
    //        default:
    //            break;
    //    }
}
#pragma mark -map view
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation
{
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
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    [geocoder reverseGeocodeLocation:location1 completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSUInteger count = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] count];
             
             
             annotationPoint.title = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] objectAtIndex:0];
             annotationPoint.subtitle = placemark.country;
             if(count > 2) {
                 annotationPoint.subtitle = placemark.locality;
             }
             
             self.place.lon = [NSNumber numberWithFloat:placemark.location.coordinate.longitude];
             self.place.lat = [NSNumber numberWithFloat:placemark.location.coordinate.latitude];
             self.place.formattedAddres = [placemark address];
//             [self.showingMainTableView reloadData];
         }
     }];
    
    self.annotationToShowPlace = [[MKPinAnnotationView alloc] initWithAnnotation:annotationPoint reuseIdentifier:nil];
    self.annotationToShowPlace.draggable = YES;
    [self.mapToSelect addAnnotation:self.annotationToShowPlace.annotation];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *GeoPointAnnotationIdentifier = @"RedPin";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
    
    if (!annotationView)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GeoPointAnnotationIdentifier];
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
        annotationView.draggable = YES;
        annotationView.animatesDrop = YES;
    }
    
    return annotationView;
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
   fromOldState:(MKAnnotationViewDragState)oldState
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSUInteger count = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] count];
             MKPointAnnotation *annotationPoint;             annotationPoint = view.annotation;
             annotationPoint.title = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] objectAtIndex:0];
             annotationPoint.subtitle = placemark.country;
             if(count > 2) {
                 annotationPoint.subtitle = placemark.locality;
             }
             self.place.lon = [NSNumber numberWithFloat:placemark.location.coordinate.longitude];
             self.place.lat = [NSNumber numberWithFloat:placemark.location.coordinate.latitude];
             self.place.formattedAddres = [placemark address];
             //  [self.addLocTableView reloadData];
         }
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
    [SPCoreDataManager saveContext];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
