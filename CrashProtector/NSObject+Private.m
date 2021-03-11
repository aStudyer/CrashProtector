//
//  NSObject+Private.m
//  CrashProtector
//
//  Created by suhc on 2021/3/9.
//

#import "NSObject+Private.h"

@implementation NSObject (Private)
+ (void)avoidCrashWithSels:(struct CP_SEL *)sels size:(int)size {
    for (int i = 0; i < size; i++) {
        struct CP_SEL sel = sels[i];
        SEL old_sel = sel.sel;
        SEL new_sel = NSSelectorFromString([NSString stringWithFormat:@"cp_%@", NSStringFromSelector(old_sel)]);
        if (sel.isClassSEL) {
            [sel.clazz exchangeClassMethodWithOriginalSEL:old_sel swizzledSEL:new_sel];
        } else {
            [sel.clazz exchangeInstanceMethodWithOriginalSEL:old_sel swizzledSEL:new_sel];
        }
    }
}
+ (void)handleException:(NSException *)exception {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(@"CrashProtector_handleException:") withObject:exception];
    #pragma clang diagnostic pop
}
@end
