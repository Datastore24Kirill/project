//
//  ChooseHookahController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 18.02.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface ChooseHookahController : MainViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (assign, nonatomic) BOOL isBool;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewForTextFild;
@property (weak, nonatomic) IBOutlet UITextField *filterTextFild;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIView *darkViewForButtonNext;



@property (strong, nonatomic) NSString * outletID;
@property (strong, nonatomic) NSArray * hookahArray;
@property (strong, nonatomic) NSArray * hookahTempArray;
@property (strong, nonatomic) NSString * chooseHookah;
@property (strong, nonatomic) NSString * chooseHookahName;
@property (strong, nonatomic) NSString * maximumNumberOfFeatures;

- (IBAction)actionButtonNext:(UIButton *)sender;

@end
