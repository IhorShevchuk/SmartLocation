//
//  SPSavedPlacesViewController.m
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//
#import <CoreData/CoreData.h>

#import "SPSavedPlacesViewController.h"
#import "SPAddEditLocationViewController.h"

#import "SPPlaceTableViewCell.h"
#import "SPCoreDataManager.h"
#import "TMFloatingButton.h"
NSString * const placeCellIdentifirier = @"PlaceCell";
@interface SPSavedPlacesViewController()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *placesTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) SPPlace *selectedPlace;
@end

@implementation SPSavedPlacesViewController
#pragma makr - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupAddButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.placesTableView reloadData];
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
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        [_fetchedResultsController performFetch:nil];
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SPPlace"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    NSPredicate *filteringPredicate = [NSPredicate predicateWithFormat:@"user == %@",[SPCoreDataManager getCurrentUser]];
    request.predicate = filteringPredicate;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request managedObjectContext:[SPCoreDataManager managedObjectContext]
                                     sectionNameKeyPath:nil cacheName:nil];
    [_fetchedResultsController performFetch:nil];
    return _fetchedResultsController;
}

#pragma mark - UI
- (void)setupTableView {
    self.placesTableView.delegate = self;
    self.placesTableView.dataSource = self;
    [self.placesTableView registerNib:[UINib nibWithNibName:@"SPPlaceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:placeCellIdentifirier];
    [self.placesTableView reloadData];
}
- (void)setupAddButton {
    TMFloatingButton *addButton = [[TMFloatingButton alloc]initWithSuperView:self.view];
    [addButton addStateWithText:@"add" withAttributes:@{} andBackgroundColor:MainAppColor forName:@"add" applyRightNow:YES];
    [addButton addTarget:self action:@selector(addNewPinAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = [self.fetchedResultsController.sections count];
    return numberOfSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSInteger numberOfRows = [sectionInfo numberOfObjects];
    return numberOfRows;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPlaceTableViewCell *cell = cell = [tableView dequeueReusableCellWithIdentifier:placeCellIdentifirier];
    if (cell == nil) {
        cell = [[SPPlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:placeCellIdentifirier];
    }
    SPPlace *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.placeName.text     = place.name;
    cell.placeAddress.text  = place.formattedAddres;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SPPlace *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedPlace = place;
    [self performSegueWithIdentifier:@"editLocation" sender:self];
}
#pragma mark - Buttons Actions
- (void)addNewPinAction:(id)sender {
    [self performSegueWithIdentifier:@"addLocation" sender:self];
}
@end
