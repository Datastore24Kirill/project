//
//  CitiesModel.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 30.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CitiesController.h"

@protocol CitiesModelDelegate <NSObject>

@required

@property (strong, nonatomic) NSArray * arrayCities;
-(void) reloadTable;


@end

@interface CitiesModel : NSObject
@property (assign, nonatomic) id <CitiesModelDelegate> delegate;
- (void) getCityArrayToTableView: (NSString *) countryID andCompitionBack: (void (^) (void)) compitionBack;

@end
