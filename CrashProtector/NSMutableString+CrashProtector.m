//
//  NSMutableString+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/11.
//

#import "NSMutableString+CrashProtector.h"

@implementation NSMutableString (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { NSClassFromString(@"__NSCFString"), @selector(replaceCharactersInRange:withString:), NO },
            { NSClassFromString(@"__NSCFString"), @selector(insertString:atIndex:), NO },
            { NSClassFromString(@"__NSCFString"), @selector(deleteCharactersInRange:), NO },
            { NSClassFromString(@"__NSCFString"), @selector(substringFromIndex:), NO },
            { NSClassFromString(@"__NSCFString"), @selector(substringToIndex:), NO }
        };
        int size = sizeof(sels) / sizeof(sels[0]);
        [self avoidCrashWithSels:sels size:size];
    });
}
- (void)cp_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    @try {
        [self cp_replaceCharactersInRange:range withString:aString];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (void)cp_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    @try {
        [self cp_insertString:aString atIndex:loc];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (void)cp_deleteCharactersInRange:(NSRange)range {
    @try {
        [self cp_deleteCharactersInRange:range];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
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
@end
