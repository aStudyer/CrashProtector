//
//  NSMutableDictionary+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/11.
//

#import "NSMutableDictionary+CrashProtector.h"

@implementation NSMutableDictionary (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKeyedSubscript:), NO },
            { NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:), NO },
            { NSClassFromString(@"__NSDictionaryM"), @selector(removeObjectForKey:), NO }
        };
        int size = sizeof(sels) / sizeof(sels[0]);
        [self avoidCrashWithSels:sels size:size];
    });
}
- (void)cp_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    @try {
        [self cp_setObject:obj forKeyedSubscript:key];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (void)cp_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self cp_setObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (void)cp_removeObjectForKey:(id)aKey {
    @try {
        [self cp_removeObjectForKey:aKey];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
@end
