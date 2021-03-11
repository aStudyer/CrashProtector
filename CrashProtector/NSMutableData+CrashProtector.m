//
//  NSMutableData+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/11.
//

#import "NSMutableData+CrashProtector.h"

@implementation NSMutableData (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { NSClassFromString(@"NSConcreteMutableData"), @selector(resetBytesInRange:), NO },
            { NSClassFromString(@"NSConcreteMutableData"), @selector(replaceBytesInRange:withBytes:length:), NO },
            { NSClassFromString(@"NSConcreteMutableData"), @selector(replaceBytesInRange:withBytes:), NO }
        };
        int size = sizeof(sels) / sizeof(sels[0]);
        [self avoidCrashWithSels:sels size:size];
    });
}
- (void)cp_resetBytesInRange:(NSRange)range {
    @try {
        [self cp_resetBytesInRange:range];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (void)cp_replaceBytesInRange:(NSRange)range withBytes:(const void *)replacementBytes length:(NSUInteger)replacementLength {
    @try {
        [self cp_replaceBytesInRange:range withBytes:replacementBytes length:replacementLength];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (void)cp_replaceBytesInRange:(NSRange)range withBytes:(const void *)bytes {
    @try {
        [self cp_replaceBytesInRange:range withBytes:bytes];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
@end
