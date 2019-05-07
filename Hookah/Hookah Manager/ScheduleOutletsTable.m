//
//  ScheduleOutlets.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 27.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ScheduleOutletsTable.h"

@implementation ScheduleOutletsTable

+ (NSString *)primaryKey
{
    return @"outletID";
}

-(void)insertDataIntoDataBaseWithOutletID:(NSString *)outletID open:(NSString *)open close:(NSString *)close{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    @try {
        
        [realm beginWriteTransaction];
        
        self.outletID = outletID;
        self.open = open;
        self.close = close;
        
        
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

@end
