//
//  OtherDetailsModel.h
//  Hookah Manager
//
//  Created by Mac_Work on 24.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherDetailsModel : NSObject

+ (NSArray*) setArrayOtherDetails;
-(void)saveCity: (NSString *) cityID andBlock: (void (^) (id response)) compitionBlock;
-(void)saveAll: (NSDictionary *) params andBlock: (void (^) (id response)) compitionBlock;
@end
