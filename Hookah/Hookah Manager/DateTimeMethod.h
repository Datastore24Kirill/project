//
//  DateTimeMethod.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 19.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeMethod : NSObject
+ (NSString *) dateToTimestamp: (NSDate *) date;
+ (NSDate *) timestampToDate: (NSString *) timestamp;
+ (NSString *) timeFormattedHHMM:(int)totalSeconds;
+ (NSString *) getCurrentDateFormattedHH;
+ (NSString *) getCurrentDateFormattedMM;
+ (NSString *) getCurrentDateFormattedHHMMYYYY;
@end
