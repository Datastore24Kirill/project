//
//  HistoryCell.h
//  Hookah Manager
//
//  Created by Mac_Work on 24.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@protocol HistoryCellDelegate;

@interface HistoryCell : UITableViewCell

@property (weak, nonatomic) id <HistoryCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTable;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (assign, nonatomic) NSUInteger typeCell; //1 активный, 4 - завершен, 5 - отменен, 6 - зарезервирован

@property (weak, nonatomic) IBOutlet CustomButton *buttonCell;

- (IBAction)actionButtonCell:(CustomButton *)sender;

@end

@protocol HistoryCellDelegate <NSObject>

@required

@optional

- (void) actionButtonCell: (HistoryCell*) historyCell withButton: (CustomButton*) sender;

@end
