//
//  NSData+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/11.
//

#import "NSData+CrashProtector.h"

@implementation NSData (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { NSClassFromString(@"NSData"), @selector(subdataWithRange:), NO },
            { NSClassFromString(@"NSData"), @selector(rangeOfData:options:range:), NO }
        };
        int size = sizeof(sels) / sizeof(sels[0]);
        [self avoidCrashWithSels:sels size:size];
    });
}
- (NSData *)cp_subdataWithRange:(NSRange)range {
    NSData *data = nil;
    @try {
        data = [self cp_subdataWithRange:range];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return data;
    }
}
- (NSRange)cp_rangeOfData:(NSData *)dataToFind options:(NSDataSearchOptions)mask range:(NSRange)searchRange {
    NSRange range = NSMakeRange(NSNotFound, NSNotFound);
    @try {
        range = [self cp_rangeOfData:dataToFind options:mask range:searchRange];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return range;
    }
}
@end
