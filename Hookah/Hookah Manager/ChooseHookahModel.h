//
//  ChooseHookahModel.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 01.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseHookahModelDelegate <NSObject>

@required
-(void) loadHookah:(NSArray *) arrayRespone;


@end

@interface ChooseHookahModel : NSObject
@property (assign, nonatomic) id <ChooseHookahModelDelegate> delegate;
@property (assign, nonatomic) BOOL isFilterText;
@property (strong, nonatomic) NSString * filterText;
- (void) getArray: (NSString *) outletID timeBlock: (void (^) (void)) timeBlock;
-(NSArray *) filtred:(NSArray *) array;


@end
