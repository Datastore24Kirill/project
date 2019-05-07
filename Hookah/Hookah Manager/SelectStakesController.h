//
//  SelectStakesController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 09.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"
#import "SelectCategoryView.h"
#import "NavSearch.h"
#import "FilterView.h"



@interface SelectStakesController : MainViewController <SelectCategoryViewDelegate>

@property (weak, nonatomic) IBOutlet UITabBarItem *bottomBarButton;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (assign, nonatomic) BOOL isLoadOrganization;
@property (assign, nonatomic) BOOL isLoadOoutlet;

@property (strong, nonatomic) FilterView * filterView;
@property (strong, nonatomic) NavSearch * navView;
@property (strong, nonatomic) NSArray * mainArrayData;



- (void) checkLoadDataBase;

@end
