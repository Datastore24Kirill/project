//
//  MapModel.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 27.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "OutletTable.h"



@interface MapModel : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *myLocationManager;
@property (nonatomic,strong) CLLocation *startLocation;
@property (assign, nonatomic) BOOL inBetween;

-(NSArray *)loadOutletsToMap: (NSString *) outletID;
-(NSString *) getScheduleOutlets: (NSString *) outletID;

@end
