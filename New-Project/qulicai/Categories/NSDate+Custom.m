//
//  NSDate+Custom.m
//  bike
//
//  Created by satgi on 12/10/14.
//  Copyright (c) 2014 yunzao. All rights reserved.
//

static NSString *const kFormatterYYYYMMDDBirthday = @"yyyy-MM-dd";
static NSString *const kFormatterHHMMTime = @"HH:mm";
static NSString *const kFormatterEEEEWeekday = @"EEEE";
static NSString *const kFormatterYYYYMMDDRidingDate = @"yyyy.MM.dd";

#import "NSDate+Custom.h"
#import "NSObject+Custom.h"

@implementation NSDate (Custom)

+ (NSUInteger)weekdayOfToday {
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitWeekday) fromDate:today];
    NSUInteger weekday = [weekdayComponents weekday];
    return weekday;
}

+ (NSString *)readableDateForDate:(NSDate *)date {
    return [NSDate readableDateForDate:date
                             dateStyle:NSDateFormatterLongStyle
                             timeStyle:NSDateFormatterNoStyle];
}

+ (NSString *)readableDateForDate:(NSDate *)date
                        dateStyle:(NSDateFormatterStyle)dateStyle
                        timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:dateStyle];
    [dateFormatter setTimeStyle:timeStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
}

+ (NSNumber *)ageFromBirthday:(NSDate *)birthday {
    if (![birthday isKindOfClass:[NSDate class]]) {
        return nil;
    }
    NSDate *now = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    return @([ageComponents year]);
}

+ (NSString *)relativeDateStringForDate:(NSDate *)date {
    if (![date isKindOfClass:[NSDate class]]) {
        return nil;
    }

    long long durationJustNow = 10;
    long long secondsPerMinute = 60;
    long long minutesPerHour = 60;
    long long hoursPerDay = 24;
    long long daysPerWeek = 7;
    long long weeksPerMonth = 5;
    long long daysPerMonth = 30;
    long long daysPerYear = 365;
    
    long long currentInterval = [[NSDate date] timeIntervalSince1970];
    long long relativeInterval = [date timeIntervalSince1970];
    long long differentInterval = currentInterval - relativeInterval;
    
    NSString *defaultDateFormatter = @"yyyy-MM-dd HH:mm:ss";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = defaultDateFormatter;
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    if (relativeInterval > currentInterval) {
        return dateString;
    }
    
    if (differentInterval <= durationJustNow) {
        dateString = NSLocalizedString(@"LABEL_TEXT_JUST_NOW", nil);
    } else if (differentInterval <= secondsPerMinute) {
        dateString = [NSString stringWithFormat:NSLocalizedString(@"NSDATE_%LLD_SECOND(S)_AGO", nil), differentInterval];
    } else if (differentInterval < secondsPerMinute * minutesPerHour) {
        differentInterval = differentInterval / secondsPerMinute;
        dateString = [NSString stringWithFormat:NSLocalizedString(@"NSDATE_%LLD_MINUTE(S)_AGO", nil), differentInterval];
    } else if (differentInterval < secondsPerMinute * minutesPerHour * hoursPerDay) {
        differentInterval = differentInterval / (secondsPerMinute * minutesPerHour);
        dateString = [NSString stringWithFormat:NSLocalizedString(@"NSDATE_%LLD_HOUR(S)_AGO", nil), differentInterval];
    } else if (differentInterval < secondsPerMinute * minutesPerHour * hoursPerDay * daysPerWeek) {
        differentInterval = differentInterval / (secondsPerMinute * minutesPerHour * hoursPerDay);
        dateString = [NSString stringWithFormat:NSLocalizedString(@"NSDATE_%LLD_DAY(S)_AGO", nil), differentInterval];
    } else if (differentInterval < secondsPerMinute * minutesPerHour * hoursPerDay * daysPerWeek * weeksPerMonth) {
        differentInterval = differentInterval / (secondsPerMinute * minutesPerHour * hoursPerDay * daysPerWeek);
        dateString = [NSString stringWithFormat:NSLocalizedString(@"NSDATE_%LLD_WEEK(S)_AGO", nil), differentInterval];
    } else if (differentInterval < secondsPerMinute * minutesPerHour * hoursPerDay * daysPerYear) {
        differentInterval = differentInterval / (secondsPerMinute * minutesPerHour * hoursPerDay * daysPerMonth);
        dateString = [NSString stringWithFormat:NSLocalizedString(@"NSDATE_%LLD_MONTH(S)_AGO", nil), differentInterval];
    } else {
        differentInterval = differentInterval / (secondsPerMinute * minutesPerHour * hoursPerDay * daysPerYear);
        dateString = [NSString stringWithFormat:NSLocalizedString(@"NSDATE_%LLD_YEAR(S)_AGO", nil), differentInterval];
    }

    return dateString;
}

- (NSString *)dateStringWithFormatterYYYYMMDD {
    return [self dateStringWithDateFormatter:kFormatterYYYYMMDDBirthday];
}

- (NSString *)dateStringWithFormatterHHMM {
    return [self dateStringWithDateFormatter:kFormatterHHMMTime];
}

- (NSString *)dateStringWithFormatterEEEE {
    return [self dateStringWithDateFormatter:kFormatterEEEEWeekday];
}

- (NSString *)dateStringWithRidingDateFormatterYYYYMMDD {
    return [self dateStringWithDateFormatter:kFormatterYYYYMMDDRidingDate];
}

- (NSString *)dateStringWithDateFormatter:(NSString *)formatter {
    NSString *localization = [NSBundle mainBundle].preferredLocalizations.firstObject;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localization];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setLocale:locale];
    NSString *birthday = [dateFormatter stringFromDate:self];
    return birthday;
}

+ (NSString *)timeStringWithCount:(long long)count {
    NSString *countString = count < 10 ?
    [NSString stringWithFormat:@"0%@", @(count)] : [NSString stringWithFormat:@"%@", @(count)];
    return countString;
}

@end
