//
//  HookahCell.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 18.02.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@protocol HookahCellDelegate;

@interface HookahCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UILabel *labelNameCell;

@property (weak, nonatomic) IBOutlet UIImageView *imageCheck;
@property (assign, nonatomic) BOOL isBool;


@property (weak, nonatomic) IBOutlet CustomButton *buttonDetail;
@property (weak, nonatomic) IBOutlet CustomButton *buttonChoose;
@property (weak, nonatomic) IBOutlet UIImageView *imageShares;

@property (weak, nonatomic) id <HookahCellDelegate> delegate;

- (IBAction)actionButtonDetail:(CustomButton *)sender;
- (IBAction)actionBuutonChoose:(CustomButton *)sender;


@end

@protocol HookahCellDelegate <NSObject>

@optional

- (void) actionButtonShares: (HookahCell*) hookahCell andButtonSender: (CustomButton*) sender;
- (void) actionButtonDetail:(HookahCell*) hookahCell andButtonSender: (CustomButton*) sender;
- (void) actionBuutonChoose: (HookahCell*) hookahCell andButtonSender: (CustomButton*) sender;

@end
