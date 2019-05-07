//
//  OrganizationTable.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 10.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "OrganizationTable.h"

@implementation OrganizationTable

+ (NSString *)primaryKey
{
    return @"orgID";
}

-(void)insertDataIntoDataBaseWithOrgID:(NSString *)orgID name:(NSString *)name
                               logoURL:(NSString *) logoURL rating:(NSString *) rating
                             isDeleted: (NSString *) isDeleted{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    @try {
        
        [realm beginWriteTransaction];
        
        self.orgID = orgID;
        self.name = name;
        self.logoURL = logoURL;
        self.rating  = rating;
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
