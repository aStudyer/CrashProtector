//
//  NSAttributedString+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/11.
//

#import "NSAttributedString+CrashProtector.h"

@implementation NSAttributedString (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { NSClassFromString(@"NSConcreteAttributedString"), @selector(initWithString:), NO },
            { NSClassFromString(@"NSConcreteAttributedString"), @selector(initWithString:attributes:), NO },
            { NSClassFromString(@"NSConcreteMutableAttributedString"), @selector(attribute:atIndex:effectiveRange:), NO },
            { NSClassFromString(@"NSAttributedString"), @selector(enumerateAttribute:inRange:options:usingBlock:), NO },
            { NSClassFromString(@"NSAttributedString"), @selector(enumerateAttributesInRange:options:usingBlock:), NO }
        };
        int size = sizeof(sels) / sizeof(sels[0]);
        [self avoidCrashWithSels:sels size:size];
    });
}
- (instancetype)cp_initWithString:(NSString *)str {
    id ret = nil;
    @try {
        ret = [self cp_initWithString:str];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (instancetype)cp_initWithString:(NSString *)str attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    id ret = nil;
    @try {
        ret = [self cp_initWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (id)cp_attribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    id ret = nil;
    @try {
        ret = [self cp_attribute:attrName atIndex:location effectiveRange:range];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (void)cp_enumerateAttribute:(NSAttributedStringKey)attrName inRange:(NSRange)enumerationRange options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (^)(id _Nullable, NSRange, BOOL * _Nonnull))block {
    @try {
        [self cp_enumerateAttribute:attrName inRange:enumerationRange options:opts usingBlock:block];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (void)cp_enumerateAttributesInRange:(NSRange)enumerationRange options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (^)(NSDictionary<NSAttributedStringKey,id> * _Nonnull, NSRange, BOOL * _Nonnull))block {
    @try {
        [self cp_enumerateAttributesInRange:enumerationRange options:opts usingBlock:block];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
@end
