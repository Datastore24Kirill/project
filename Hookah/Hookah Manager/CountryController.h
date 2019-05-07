//
//  CountryController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 30.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"
#import "Macros.h"
#import "HexColors.h"



@interface CountryController : MainViewController <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *countryTableView;
@property (strong, nonatomic) NSArray * arrayCountry;

-(void) reloadTable;

@end


