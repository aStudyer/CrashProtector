//
//  NSObject+Basic.h
//  CrashProtector
//
//  Created by suhc on 2021/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CrashProtectorExceptionHandler)(NSException *exception);

@interface CrashProtector : NSObject

+ (void)activateWithExceptionHandler:(CrashProtectorExceptionHandler)handler;

+ (void)activate:(NSArray *)classes exceptionHandler:(CrashProtectorExceptionHandler)handler;

@end

@interface NSObject (Basic)

/// 成员变量列表
@property (nonatomic, copy, readonly, class) NSArray *ivars;

/// 属性列表
@property (nonatomic, copy, readonly, class) NSArray *properties;

/// 实例方法列表
@property (nonatomic, copy, readonly, class) NSArray *instanceMethods;

/// 类方法列表
@property (nonatomic, copy, readonly, class) NSArray *classMethods;

/// 遵循协议列表
@property (nonatomic, copy, readonly, class) NSArray *protocols;

/// 交互实例方法
/// @param originalSEL 交换前的方法
/// @param swizzledSEL 交换后的方法
+ (void)exchangeInstanceMethodWithOriginalSEL:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL;

/// 交互类方法
/// @param originalSEL 交换前的方法
/// @param swizzledSEL 交换后的方法
+ (void)exchangeClassMethodWithOriginalSEL:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL;

@end

NS_ASSUME_NONNULL_END
