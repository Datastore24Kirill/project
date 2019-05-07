//
//  HistoryModel.h
//  Hookah Manager
//
//  Created by Mac_Work on 24.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HistoryModelDelegate <NSObject>

@required
-(void) loadDefault:(NSArray *) currentOrder finishOrder:(NSArray *) finishOrder;

@end


@interface HistoryModel : NSObject
@property (assign, nonatomic) id <HistoryModelDelegate> delegate;
- (void) getVisitorOrders;



@end
