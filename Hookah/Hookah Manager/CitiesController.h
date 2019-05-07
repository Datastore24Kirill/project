//
//  CitiesController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 30.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"
#import "Macros.h"
#import "HexColors.h"

@interface CitiesController : MainViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *citiesTableView;
@property (strong, nonatomic) NSString * countryID;
@property (strong, nonatomic) NSArray * arrayCities;


-(void) reloadTable;

@end
