//
//  TesnModelCategory.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 10.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavSearch.h"
#import "FilterView.h"
@protocol SelectStakesModelDelegate <NSObject>

@required

@property (assign, nonatomic) BOOL isLoadOrganization;
@property (assign, nonatomic) BOOL isLoadOoutlet;
@property (strong, nonatomic) FilterView * filterView;
@property (strong, nonatomic) NavSearch * navView;



- (void) checkLoadDataBase;




@end

@interface SelectStakesModel : NSObject
@property (assign, nonatomic) id <SelectStakesModelDelegate> delegate;
@property (assign, nonatomic) BOOL isFilterText;
@property (strong, nonatomic) NSString * filterText;
@property (assign, nonatomic) BOOL inBetween;

- (NSArray*) setArray;
-(void) updateOutletTable;
-(void) updateOrganizationTable;



@end
