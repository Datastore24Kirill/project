//
//  OutletTable.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 10.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Realm/Realm.h>

@interface OutletTable : RLMObject

@property NSString *outletID;
@property NSString *orgID;
@property NSString *name;
@property NSString *rating;
@property NSString *isFavorite;
@property NSString *address;
@property NSString *lat;
@property NSString *lon;
@property NSString *useMix;
@property NSString *useTaste;
@property NSString *isDeleted;


+ (NSString *)primaryKey;

-(void)insertDataIntoDataBaseWithOutletID:(NSString *)outletID orgID:(NSString *)orgID name:(NSString *)name
                               rating:(NSString *) rating isFavorite:(NSString *) isFavorite
                             address: (NSString *) address lat: (NSString *) lat
                                  lon: (NSString *) lon useMix: (NSString *) useMix
                                 useTaste: (NSString *) useTaste isDeleted: (NSString *) isDeleted;
-(void) deleteDataInDataBase:(id) array;

@end
