//
//  ScheduleOutlets.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 27.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Realm/Realm.h>

@interface ScheduleOutletsTable : RLMObject

@property NSString *outletID;
@property NSString *open;
@property NSString *close;

+ (NSString *)primaryKey;

-(void)insertDataIntoDataBaseWithOutletID:(NSString *)outletID open:(NSString *)open close:(NSString *)close;


@end
