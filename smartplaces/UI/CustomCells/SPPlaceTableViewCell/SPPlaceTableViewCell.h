//
//  SPPlaceTableViewCell.h
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SPPlaceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *placeAddress;
@end
