//
//  TobaccoCell.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.02.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@protocol TobaccoCellDelegate;

@interface TobaccoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imageChoose;

@property (assign, nonatomic) BOOL isBool;

@property (weak, nonatomic) IBOutlet CustomButton *buttonChoose;
@property (weak, nonatomic) IBOutlet CustomButton *buttonDetail;
@property (weak, nonatomic) IBOutlet CustomButton *buttonShares;

@property (weak, nonatomic) id <TobaccoCellDelegate> delegate;

- (IBAction)actionButtonChoose:(CustomButton *)sender;
- (IBAction)actionButtonDetail:(CustomButton *)sender;
- (IBAction)actionButtonShares:(CustomButton *)sender;



@end

@protocol TobaccoCellDelegate <NSObject>

@optional

- (void) actionButtonShares: (TobaccoCell*) hookahCell andButtonSender: (CustomButton*) sender;
- (void) actionButtonDetail:(TobaccoCell*) hookahCell andButtonSender: (CustomButton*) sender;
- (void) actionButtonChoose: (TobaccoCell*) hookahCell andButtonSender: (CustomButton*) sender;

@end
