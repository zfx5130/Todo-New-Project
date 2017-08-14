//
//  NSDate+Custom.h
//  bike
//
//  Created by satgi on 12/7/14.
//  Copyright (c) 2014 yunzao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSDate (Custom)

+ (NSUInteger)weekdayOfToday;

+ (NSString *)readableDateForDate:(NSDate *)date;
+ (NSString *)readableDateForDate:(NSDate *)date
                        dateStyle:(NSDateFormatterStyle)dateStyle
                        timeStyle:(NSDateFormatterStyle)timeStyle;

+ (NSNumber *)ageFromBirthday:(NSDate *)birthday;

/**
 *  将当前时间之前的日期转化为可读日期
 *
 *  @param date 当前时间之前的日期
 *
 *  @return 返回的可读日期格式有，秒，分，小时，天，周，月，年
 */
+ (NSString *)relativeDateStringForDate:(NSDate *)date;

- (NSString *)dateStringWithFormatterYYYYMMDD;
- (NSString *)dateStringWithDateFormatter:(NSString *)formatter;

/**
 *  yyyy.mm.dd
 *
 *  @return 日期格式
 */
- (NSString *)dateStringWithRidingDateFormatterYYYYMMDD;


/**
 *  hh:mm
 *
 *  @return hh:mm字符串
 */
- (NSString *)dateStringWithFormatterHHMM;

/**
 *  weekday
 *
 *  @return weekday
 */
- (NSString *)dateStringWithFormatterEEEE;

+ (NSString *)hoursStringWithDuration:(long long)duration;
+ (NSString *)minutesStringWithDuration:(long long)duration;
+ (NSString *)secondsStringWithDuration:(long long)duration;
+ (NSString *)durationStringWithDuration:(long long)duration;

@end
