//
//  ChooseOtherController.h
//  Hookah Manager
//
//  Created by Viktor on 3/22/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface ChooseOtherController : MainViewController

@property (assign, nonatomic) BOOL isBool;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIView *darkViewForButtonNext;

@property (strong, nonatomic) NSString * outletID;
@property (strong, nonatomic) NSArray * otherArray;
@property (strong, nonatomic) NSMutableArray * chooseOthers;

- (IBAction)buttonNextAction:(UIButton *)sender;


@end
