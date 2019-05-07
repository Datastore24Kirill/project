//
//  HelpMethodForOutlets.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 30.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HelpMethodForOutlets : NSObject <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *myLocationManager;
@property (nonatomic,strong) CLLocation *startLocation;

-(BOOL) getScheduleOutlets: (NSString *) orgID;
-(NSString *) getDistance: (NSString *) orgID;
-(NSDictionary *) getScheduleOutletOne: (NSString *) outletID;
-(NSString *) getOrgImageURL: (NSString *) orgID;
@end
