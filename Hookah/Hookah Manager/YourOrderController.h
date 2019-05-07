//
//  YourOrderController.h
//  Hookah Manager
//
//  Created by Viktor on 3/22/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface YourOrderController : MainViewController


@property (strong, nonatomic) NSString * orderID;
@property (strong, nonatomic) NSString * outletID;
@property (strong, nonatomic) NSDate * currentLocalDate;
@property (strong, nonatomic) NSString * starCount;
@property (assign, nonatomic) BOOL isHistory;
@property (assign, nonatomic) BOOL isChange;

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageStars;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
//Buttons
@property (weak, nonatomic) IBOutlet UIButton *buttonBookmarkOn;
@property (weak, nonatomic) IBOutlet UIButton *buttonBookmarkOff;
@property (weak, nonatomic) IBOutlet UIButton *buttonOrder;

@property (weak, nonatomic) IBOutlet UIButton *buttonChange;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancelOrder;

@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (assign, nonatomic) BOOL checkForDobblePush;

@property (assign, nonatomic) NSInteger typeOrder; //0 - при создании, 1 активный, 4 - завершен, 5 - отменен, 6 - зарезервирован, 7 -  положение после нажатия на кнопку потворить заказ.

- (IBAction)actionButtonBookmarkOn:(id)sender;
- (IBAction)actionButtonBookmarkOff:(id)sender;
- (IBAction)actionButtonOrder:(id)sender;
- (IBAction)actionButtonCancel:(id)sender;
- (IBAction)actionButtonChange:(id)sender;
- (IBAction)actionButtonCancelOrder:(id)sender;
- (IBAction)actionBackButton:(id)sender;




@end
