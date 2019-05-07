//
//  ChooseFlavorController.h
//  Hookah Manager
//
//  Created by Viktor on 3/22/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface ChooseFlavorController : MainViewController

@property (assign, nonatomic) BOOL isBool;
@property (assign, nonatomic) BOOL isBoolHookah;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIView *darkViewForButtonNext;
@property (weak, nonatomic) IBOutlet UILabel *labelFlovers;

- (IBAction)buttonNextAction:(UIButton*)sender;
@property (strong, nonatomic) NSString * outletID;
@property (assign, nonatomic) NSInteger countTabaco;
@property (strong, nonatomic) NSString * toobaccoID;
@property (strong, nonatomic) NSString * toobaccoName;
@property (strong, nonatomic) NSArray * flavorArray;
@property (strong, nonatomic) NSMutableArray * chooseFlovers;
@property (strong, nonatomic) NSString * maximumNumberOfFeatures;

@end
