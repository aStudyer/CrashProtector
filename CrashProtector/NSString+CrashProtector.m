//
//  NSString+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/11.
//

#import "NSString+CrashProtector.h"

@implementation NSString (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { NSClassFromString(@"__NSCFConstantString"), @selector(characterAtIndex:), NO },
            { NSClassFromString(@"__NSCFConstantString"), @selector(substringFromIndex:), NO },
            { NSClassFromString(@"__NSCFConstantString"), @selector(substringToIndex:), NO },
            { NSClassFromString(@"__NSCFConstantString"), @selector(substringWithRange:), NO },
            { NSClassFromString(@"__NSCFConstantString"), @selector(stringByReplacingOccurrencesOfString:withString:options:range:), NO },
            { NSClassFromString(@"NSTaggedPointerString"), @selector(substringFromIndex:), NO },
            { NSClassFromString(@"NSTaggedPointerString"), @selector(substringToIndex:), NO },
            { NSClassFromString(@"NSTaggedPointerString"), @selector(substringWithRange:), NO },
            { NSClassFromString(@"__NSCFString"), @selector(substringWithRange:), NO },
            { NSClassFromString(@"__NSCFConstantString"), @selector(rangeOfString:options:range:locale:), NO }
        };
        int size = sizeof(sels) / sizeof(sels[0]);
        [self avoidCrashWithSels:sels size:size];
    });
}
- (unichar)cp_characterAtIndex:(NSUInteger)index {
    unichar ret;
    @try {
        ret = [self cp_characterAtIndex:index];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (NSString *)cp_substringFromIndex:(NSUInteger)from {
    NSString *ret = nil;
    @try {
        ret = [self cp_substringFromIndex:from];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (NSString *)cp_substringToIndex:(NSUInteger)to {
    NSString *ret = nil;
    @try {
        ret = [self cp_substringToIndex:to];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (NSString *)cp_substringWithRange:(NSRange)range {
    NSString *ret = nil;
    @try {
        ret = [self cp_substringWithRange:range];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (NSString *)cp_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    NSString *ret = nil;
    @try {
        ret = [self cp_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (NSRange)cp_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(NSLocale *)locale {
    NSRange range = NSMakeRange(NSNotFound, NSNotFound);
    @try {
        range = [self cp_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return range;
    }
}
@end
