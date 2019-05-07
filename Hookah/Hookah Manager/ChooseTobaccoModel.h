//
//  ChooseTobaccoModel.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 01.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseTobaccoModelDelegate <NSObject>

@required
-(void) loadTobacco:(NSArray *) arrayRespone;


@end

@interface ChooseTobaccoModel : NSObject
@property (assign, nonatomic) id <ChooseTobaccoModelDelegate> delegate;
@property (assign, nonatomic) BOOL isFilterText;
@property (strong, nonatomic) NSString * filterText;
- (void) getArray: (NSString *) outletID andHookahID: (NSString *) hookahID timeBlock: (void (^) (void)) timeBlock;
- (NSArray *) filtred:(NSArray *) array;

@end
