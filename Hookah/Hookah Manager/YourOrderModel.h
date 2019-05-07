//
//  YourOrderModel.h
//  Hookah Manager
//
//  Created by Mac_Work on 23.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YourOrderModelDelegate <NSObject>

@required
@property (strong, nonatomic) NSString * starCount;
-(void) loadDefault:(NSString *) address open:(NSString *) open close: (NSString *) close
         isFavorite:(NSString*) isFavorite andLogoURL: (NSString*) logoURL andRating:(NSString*) rating;
-(void)deleteActiviti;
-(void) setTotalCoast: (NSString *) totalCoast;
-(void) loadArrayDescription:(NSDictionary *) dict andHistory:(BOOL) isHistory;


@optional
@property (strong, nonatomic) NSString * orgID;
@property (strong, nonatomic) NSString * outletID;
@property (strong, nonatomic) NSString * imageStingURL;
@property (strong, nonatomic) NSDate * currentLocalDate;

@end

@interface YourOrderModel : NSObject
@property (assign, nonatomic) id <YourOrderModelDelegate> delegate;
- (NSArray*) setArrayType;
- (void) setTestArrayDescription:(BOOL) isHistory andOrderID:(NSString *) orderID;
-(void) selectOutlets:(NSString *) outletID;
-(void) loadCoastOrdertimeBlock: (void (^) (void)) timeBlock;
-(void) createOrder: (void (^) (id response)) compitionBlock;
-(void)cancelOrder: (NSString *) orderID andBlock: (void (^) (id response)) compitionBlock;
-(void) updateOrder:(NSString *) orderID andBlock: (void (^) (id response)) compitionBlock;
-(void)loadOrder: (NSString *) orderID andBlock: (void (^) (id response)) compitionBlock;
@end
