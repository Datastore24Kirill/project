//
//  ChooseTobaccoController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.02.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface ChooseTobaccoController : MainViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (assign, nonatomic) BOOL isBool;
@property (assign, nonatomic) BOOL isBoolHookah;

@property (weak, nonatomic) IBOutlet UIView *viewForTextFild;
@property (weak, nonatomic) IBOutlet UITextField *filterTextFild;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;

@property (weak, nonatomic) IBOutlet UIView *darkViewForButtonNext;

@property (strong, nonatomic) NSString * outletID;
@property (strong, nonatomic) NSString * hookahID;
@property (strong, nonatomic) NSArray * tobaccoArray;
@property (strong, nonatomic) NSArray * tobaccoTempArray;
@property (strong, nonatomic) NSString * chooseTobacco;
@property (strong, nonatomic) NSString * chooseTobaccoName;
@property (strong, nonatomic) NSString * maximumNumberOfFeatures;

- (IBAction)actionButtonNext:(UIButton *)sender;


@end
