//
//  HistoryController.h
//  Hookah Manager
//
//  Created by Mac_Work on 24.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface HistoryController : MainViewController

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
//Current
@property (weak, nonatomic) IBOutlet UITableView *tableCurrent;
@property (weak, nonatomic) IBOutlet UIView *viewCurrent;
//Pust
@property (weak, nonatomic) IBOutlet UIView *pasrOrdersView;
@property (weak, nonatomic) IBOutlet UITableView *pastOrdersTable;


@end
