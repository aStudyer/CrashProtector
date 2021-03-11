//
//  NSArray+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/9.
//

#import "NSArray+CrashProtector.h"

@implementation NSArray (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { NSClassFromString(@"__NSSingleObjectArrayI"), @selector(objectAtIndex:), NO },
            { NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:), NO },
            { NSClassFromString(@"__NSArrayI"), @selector(objectAtIndexedSubscript:), NO },
            { NSClassFromString(@"__NSArrayI"), @selector(getObjects:range:), NO },
            { NSClassFromString(@"NSArray"), @selector(subarrayWithRange:), NO },
            { NSClassFromString(@"NSArray"), @selector(objectsAtIndexes:), NO },
            { NSClassFromString(@"__NSArray0"), @selector(objectAtIndex:), NO }
        };
        int size = sizeof(sels) / sizeof(sels[0]);
        [self avoidCrashWithSels:sels size:size];
    });
}
- (void)cp_insertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        [self cp_insertObject:anObject atIndex:index];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (id)cp_objectAtIndexedSubscript:(NSUInteger)idx {
    id ret = nil;
    @try {
        ret = [self cp_objectAtIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (id)cp_objectAtIndex:(NSUInteger)index {
    id ret = nil;
    @try {
        ret = [self cp_objectAtIndex:index];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (NSArray *)cp_objectsAtIndexes:(NSIndexSet *)indexes {
    NSArray *ret = nil;
    @try {
        ret = [self cp_objectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
- (void)cp_getObjects:(id  _Nonnull __unsafe_unretained [])objects range:(NSRange)range {
    @try {
        [self cp_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (NSArray *)cp_subarrayWithRange:(NSRange)range {
    NSArray *ret = nil;
    @try {
        ret = [self cp_subarrayWithRange:range];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    } @finally {
        return ret;
    }
}
@end
