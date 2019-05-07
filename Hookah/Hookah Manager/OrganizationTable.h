//
//  OrganizationTable.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 10.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Realm/Realm.h>

@interface OrganizationTable : RLMObject

@property NSString *orgID;
@property NSString *name;
@property NSString *logoURL;
@property NSString *rating;
@property NSString *isDeleted;


+ (NSString *)primaryKey;

-(void)insertDataIntoDataBaseWithOrgID:(NSString *)orgID name:(NSString *)name
                           logoURL:(NSString *) logoURL rating:(NSString *) rating
                             isDeleted: (NSString *) isDeleted;
-(void) deleteDataInDataBase:(id) array;



@end
