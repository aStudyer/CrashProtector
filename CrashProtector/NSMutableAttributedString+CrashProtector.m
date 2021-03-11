//
//  NSMutableAttributedString+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/11.
//

#import "NSMutableAttributedString+CrashProtector.h"

@implementation NSMutableAttributedString (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { NSClassFromString(@"NSConcreteMutableAttributedString"), @selector(initWithString:), NO },
            { NSClassFromString(@"NSConcreteMutableAttributedString"), @selector(initWithString:attributes:), NO },
            { NSClassFromString(@"NSMutableAttributedString"), @selector(removeAttribute:range:), NO },
            { NSClassFromString(@"NSConcreteMutableAttributedString"), @selector(attributedSubstringFromRange:), NO },
            { NSClassFromString(@"NSConcreteMutableAttributedString"), @selector(replaceCharactersInRange:withString:), NO },
            { NSClassFromString(@"NSConcreteMutableAttributedString"), @selector(replaceCharactersInRange:withAttributedString:), NO }
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
- (void)cp_removeAttribute:(NSAttributedStringKey)name range:(NSRange)range {
    @try {
        [self cp_removeAttribute:name range:range];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (NSAttributedString *)cp_attributedSubstringFromRange:(NSRange)range {
    NSAttributedString *ret = nil;
    @try {
        ret = [self cp_attributedSubstringFromRange:range];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (void)cp_replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    @try {
        [self cp_replaceCharactersInRange:range withString:str];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (void)cp_replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrString {
    @try {
        [self cp_replaceCharactersInRange:range withAttributedString:attrString];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
@end
