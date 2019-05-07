//
//  OutletTable.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 10.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "OutletTable.h"

@implementation OutletTable

+ (NSString *)primaryKey
{
    return @"outletID";
}

-(void)insertDataIntoDataBaseWithOutletID:(NSString *)outletID orgID:(NSString *)orgID name:(NSString *)name
                                   rating:(NSString *) rating isFavorite:(NSString *) isFavorite
                                  address: (NSString *) address lat: (NSString *) lat
                                      lon: (NSString *) lon useMix: (NSString *) useMix
                                 useTaste: (NSString *) useTaste isDeleted: (NSString *) isDeleted{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    @try {
        
        [realm beginWriteTransaction];
        
        self.outletID = outletID;
        self.orgID = orgID;
        self.name = name;
        self.rating = rating;
        self.isFavorite  = isFavorite;
        self.address  = address;
        self.lat  = lat;
        self.lon  = lon;
        self.useMix  = useMix;
        self.useTaste  = useTaste;
        self.isDeleted = isDeleted;
        
        [realm addOrUpdateObject:self];
        [realm commitWriteTransaction];
        
    }
    
    @catch (NSException *exception) {
        NSLog(@"exception");
        if ([realm inWriteTransaction]) {
            [realm cancelWriteTransaction];
        }
    }

    
    
    
}

-(void) deleteDataInDataBase:(id) array {
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] deleteObjects:array];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

@end
