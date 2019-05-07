//
//  ChooseTableModel.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 2/1/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseTableModelDelegate <NSObject>

@required
-(void) loadTable:(NSArray *) arrayRespone endCountTables: (NSArray*) countTables;
@property (strong, nonatomic) NSString * outletID;

@end

@interface ChooseTableModel : NSObject

@property (assign, nonatomic) id <ChooseTableModelDelegate> delegate;
@property (strong, nonatomic) NSMutableArray * oneTableArray;
@property (strong, nonatomic) NSMutableArray * moreTableArray;
@property (strong, nonatomic) NSMutableArray * allExistTables;

@property (strong, nonatomic) NSArray * mainArray;


- (void) getArray: (NSString *) outletID;
- (NSMutableArray*) getArrayForPickerLocal: (NSString *) outletID;
- (void) getArrayCloseTimeForServer:(NSString *) outletID andTableID:(NSString *) tableID
                            orderID:(NSString *) orderID ccomplitionBlock: (void (^) (NSArray* response)) compitionBlock;

- (void) getArrayCloseTimeForServer:(NSString *) outletID orderID: (NSString *) orderID ccomplitionBlock: (void (^) (NSArray* response)) compitionBlockOne ;

- (NSArray*) getFinishTime:(NSString *) chooseTime andTableID: (NSString*) tableID andOutletID: (NSString *) outletID;
- (NSDictionary*) chooseTableForTime: (NSString*) time;

@end
