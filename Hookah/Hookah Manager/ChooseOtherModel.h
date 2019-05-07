//
//  ChooseOtherModel.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 28.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseOtherModelDelegate <NSObject>

@required
-(void) loadOther:(NSArray *) arrayRespone;


@end

@interface ChooseOtherModel : NSObject
@property (assign, nonatomic) id <ChooseOtherModelDelegate> delegate;
- (void) getArray: (NSString *) outletID timeBlock: (void (^) (void)) timeBlock;
@end
