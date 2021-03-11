//
//  NSMutableArray+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/11.
//

#import "NSMutableArray+CrashProtector.h"

@implementation NSMutableArray (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { NSClassFromString(@"__NSPlaceholderArray"), @selector(initWithObjects:count:), NO },
            { NSClassFromString(@"__NSArrayM"), @selector(insertObject:atIndex:), NO },
            { NSClassFromString(@"__NSArrayM"), @selector(objectAtIndexedSubscript:), NO },
            { NSClassFromString(@"__NSArrayM"), @selector(setObject:atIndexedSubscript:), NO },
            { NSClassFromString(@"__NSArrayM"), @selector(removeObjectsInRange:), NO },
            { NSClassFromString(@"__NSArrayM"), @selector(getObjects:range:), NO }
        };
        int size = sizeof(sels) / sizeof(sels[0]);
        [self avoidCrashWithSels:sels size:size];
    });
}
- (instancetype)cp_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self cp_initWithObjects:objects count:cnt];
    } @catch (NSException *exception) {
        // 去除为nil的数据
        NSUInteger count = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[count++] = objects[i];
            }
        }
        instance = [self cp_initWithObjects:newObjects count:count];
        [CrashProtector handleException:exception];
    } @finally {
        return instance;
    }
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
- (void)cp_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    @try {
        [self cp_setObject:obj atIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (void)cp_removeObjectsInRange:(NSRange)range {
    @try {
        [self cp_removeObjectsInRange:range];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
- (void)cp_getObjects:(id  _Nonnull __unsafe_unretained [])objects range:(NSRange)range {
    @try {
        [self cp_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
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
@end
