//
//  CountryModel.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 30.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountryController.h"

@protocol CountryModelDelegate <NSObject>

@required

@property (strong, nonatomic) NSArray * arrayCountry;
-(void) reloadTable;


@end


@interface CountryModel : NSObject
@property (assign, nonatomic) id <CountryModelDelegate> delegate;
- (void) getCountryArrayToTableView: (void (^) (void)) compitionBack;

@end

