//
//  ChooseFlavorCell.h
//  Hookah Manager
//
//  Created by Viktor on 3/22/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseFlavorCellDelegate;

@interface ChooseFlavorCell : UITableViewCell


@property (weak, nonatomic) id <ChooseFlavorCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UISwitch *swichCell;
- (IBAction)actionSwich:(UISwitch *)sender;

@end

@protocol ChooseFlavorCellDelegate <NSObject>

@required

@optional

- (void) actionCell: (ChooseFlavorCell*) chooseFavorCell withSwich: (UISwitch*) swich;

@end
