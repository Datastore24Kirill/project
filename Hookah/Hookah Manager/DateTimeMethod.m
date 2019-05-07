//
//  DateTimeMethod.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 19.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "DateTimeMethod.h"

@implementation DateTimeMethod


+ (NSString *) dateToTimestamp: (NSDate *) date{
    
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    NSInteger timeStampObj = timeStamp;
    NSString * timeString = [NSString stringWithFormat:@"%ld",(long)timeStampObj];
    return timeString;
}

+(NSDate *) timestampToDate: (NSString *) timestamp {
    // Set up an NSDateFormatter for UTC time zone
    NSString* format = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDateFormatter* formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Cast the input string to NSDate
    NSDate* utcDate = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    
    // Set up an NSDateFormatter for the device's local time zone
    NSDateFormatter* formatterLocal = [[NSDateFormatter alloc] init];
    [formatterLocal setDateFormat:format];
    [formatterLocal setTimeZone:[NSTimeZone localTimeZone]];
    
    // Create local NSDate with time zone difference
    NSDate* localDate = [formatterUtc dateFromString:[formatterLocal stringFromDate:utcDate]];
    return localDate;
}

+ (NSString *)timeFormattedHHMM:(int)totalSeconds
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
   
    
    
//    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
    
    
    return [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
}

+ (NSString *) getCurrentDateFormattedHH{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    
    
    //    int minutes = (totalSeconds / 60) % 60;
    //    int hours = totalSeconds / 3600;
    
    
    return [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
}

+ (NSString *) getCurrentDateFormattedMM{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    

    
    //    int minutes = (totalSeconds / 60) % 60;
    //    int hours = totalSeconds / 3600;
    
    
    return [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
}

+ (NSString *) getCurrentDateFormattedHHMMYYYY{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    
    
    
    //    int minutes = (totalSeconds / 60) % 60;
    //    int hours = totalSeconds / 3600;
    
    
    return [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
}

@end
