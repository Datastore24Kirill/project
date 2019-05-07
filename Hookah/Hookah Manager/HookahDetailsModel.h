//
//  HookahDetailsModel.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 16.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@protocol HookahDetailsModelDelegate <NSObject>

@required
@property (strong, nonatomic) NSString * starCount;
@property (strong, nonatomic) NSString * latMap;
@property (strong, nonatomic) NSString * lonMap;
-(void) loadDefault:(NSString *) address open:(NSString *) open close: (NSString *) close
       addressArray: (NSArray *) addressArray isFavorite:(NSString*) isFavorite;
- (void) loadReviews:(NSArray *) reviewsArray;
- (void) loadShares:(NSArray *) sharesArray;

@optional
@property (strong, nonatomic) NSString * orgID;
@property (strong, nonatomic) NSString * outletID;
@property (strong, nonatomic) NSString * imageStingURL;
@property (strong, nonatomic) NSDate * currentLocalDate;




@end


@interface HookahDetailsModel : NSObject <CLLocationManagerDelegate>
@property (assign, nonatomic) id <HookahDetailsModelDelegate> delegate;
@property (nonatomic, strong) CLLocationManager *myLocationManager;
@property (nonatomic,strong) CLLocation *startLocation;

- (void) selectOutlets:(NSString *) outletID;
- (void) setArrayShares;
- (void) setArrayReviews;


-(void) setFavorites: (BOOL) isFavorite andOutletID: (NSString *) outletID
     complitionBlock: (void (^) (void)) compitionBack;

@end
