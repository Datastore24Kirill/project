//
//  OtherController.h
//  Hookah Manager
//
//  Created by Mac_Work on 24.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface OtherController : MainViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) NSDictionary * profileInfo;

@end
