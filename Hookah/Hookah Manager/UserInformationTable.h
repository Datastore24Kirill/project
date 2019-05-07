//
//  UserInformationTable.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 27.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserInformationTable : RLMObject
@property NSString *userID;
@property NSString *token;
@property NSString *city_id;
@property NSString *device_token;
@property NSString *orgRequestTime;
@property NSString *outletRequestTime;




+ (NSString *)primaryKey;
-(void)insertDataIntoDataBaseWithToken:(NSString *)token andCityID:(NSString *)cityId deviceToken:(NSString *) deviceToken;
-(void) updateDataInDataBase;

-(void) deleteDataInDataBase:(id) array;


@end
