//
//  NSObject+Private.h
//  CrashProtector
//
//  Created by suhc on 2021/3/9.
//

#import "NSObject+Basic.h"

NS_ASSUME_NONNULL_BEGIN

struct CP_SEL {
    Class clazz; //!< 类
    SEL sel; //!<  方法名
    bool isClassSEL; //!<  是否是类方法
};

@protocol CrashProtector <NSObject>

@required
+ (void)avoidCrash;

@end

@interface NSObject (Private)

+ (void)avoidCrashWithSels:(struct CP_SEL *)sels size:(int)size;

+ (void)handleException:(NSException *)exception;

@end

NS_ASSUME_NONNULL_END
