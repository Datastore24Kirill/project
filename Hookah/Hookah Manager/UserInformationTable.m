//
//  UserInformationTable.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 27.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "UserInformationTable.h"

@implementation UserInformationTable

+ (NSString *)primaryKey
{
    return @"userID";
}

-(void)insertDataIntoDataBaseWithToken:(NSString *)token andCityID:(NSString *)cityId deviceToken:(NSString *) deviceToken
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    @try {
        
        [realm beginWriteTransaction];
        
        self.userID = @"1";
        self.token = token;
        self.city_id = cityId;
        self.device_token = deviceToken;
        self.orgRequestTime = @"0";
        self.outletRequestTime = @"0";
        
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







-(void) updateDataInDataBase {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    //    selectedDataObject.name=name;
    //    selectedDataObject.city=city;
    [realm commitWriteTransaction];
    
}

-(void) deleteDataInDataBase:(id) array {
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] deleteObjects:array];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}


@end
