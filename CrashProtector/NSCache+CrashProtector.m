//
//  NSCache+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/11.
//

#import "NSCache+CrashProtector.h"

@implementation NSCache (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { NSClassFromString(@"NSCache"), @selector(setObject:forKey:cost:), NO }
        };
        int size = sizeof(sels) / sizeof(sels[0]);
        [self avoidCrashWithSels:sels size:size];
    });
}
- (void)cp_setObject:(id)obj forKey:(id)key cost:(NSUInteger)g {
    @try {
        [self cp_setObject:obj forKey:key cost:g];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
@end
