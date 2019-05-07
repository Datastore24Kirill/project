//
//  ChooseFlavorModel.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 28.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseFlavorModelDelegate <NSObject>

@required
-(void) loadFlavor:(NSArray *) arrayRespone;


@end

@interface ChooseFlavorModel : NSObject
@property (assign, nonatomic) id <ChooseFlavorModelDelegate> delegate;
- (void) getArray: (NSString *) outletID andTobaccoid: (NSString *) tobaccoID timeBlock: (void (^) (void)) timeBlock;
@end
