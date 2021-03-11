//
//  NSDictionary+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/11.
//

#import "NSDictionary+CrashProtector.h"

@implementation NSDictionary (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { NSClassFromString(@"__NSPlaceholderDictionary"), @selector(initWithObjects:forKeys:count:), NO },
        };
        int size = sizeof(sels) / sizeof(sels[0]);
        [self avoidCrashWithSels:sels size:size];
    });
}
- (instancetype)cp_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self cp_initWithObjects:objects forKeys:keys count:cnt];
    } @catch (NSException *exception) {
        // 去除为nil的数据
        NSInteger count = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newKeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[count] = objects[i];
                newKeys[count] = keys[i];
                count++;
            }
        }
        instance = [self cp_initWithObjects:newObjects forKeys:newKeys count:count];
        [CrashProtector handleException:exception];
    } @finally {
        return instance;
    }
}
@end
