//
//  NSObject+Basic.m
//  CrashProtector
//
//  Created by suhc on 2021/3/9.
//

#import "NSObject+Private.h"
#import <objc/runtime.h>

@implementation CrashProtector
static CrashProtectorExceptionHandler _exceptionHandler;

+ (void)activateWithExceptionHandler:(CrashProtectorExceptionHandler)handler {
    [self activate:@[
        [NSObject class],
        [NSArray class],
        [NSMutableArray class],
        [NSDictionary class],
        [NSMutableDictionary class],
        [NSString class],
        [NSMutableString class],
        [NSAttributedString class],
        [NSMutableAttributedString class],
        [NSCache class],
        [NSData class],
        [NSMutableData class]
    ] exceptionHandler:handler];
}

+ (void)activate:(NSArray *)classes exceptionHandler:(CrashProtectorExceptionHandler)handler {
    for (Class clazz in classes) {
        [clazz avoidCrash];
    }
    
    _exceptionHandler = handler;
}
+ (void)handleException:(NSException *)exception {
    if (_exceptionHandler) {
        _exceptionHandler(exception);
    }
}
@end

@implementation NSObject (Basic)
+ (NSArray *)ivars {
    NSArray *results = objc_getAssociatedObject(self, @selector(ivars));
    if (!results) {
        unsigned int count;
        Ivar *ivars = class_copyIvarList(self, &count);
        NSMutableArray *resultsM = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [resultsM addObject:@(ivar_getName(ivars[i]))];
        }
        free(ivars);
        results = [resultsM copy];
        objc_setAssociatedObject(self, @selector(ivars), results, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return results;
}

+ (NSArray *)properties {
    NSArray *results = objc_getAssociatedObject(self, @selector(properties));
    if (!results) {
        unsigned int count;
        objc_property_t *property = class_copyPropertyList(self, &count);
        NSMutableArray *resultsM = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [resultsM addObject:@(property_getName(property[i]))];
        }
        free(property);
        results = [resultsM copy];
        objc_setAssociatedObject(self, @selector(properties), results, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return results;
}

+ (NSArray *)instanceMethods {
    NSArray *results = objc_getAssociatedObject(self, @selector(instanceMethods));
    if (!results) {
        unsigned int count;
        Method *methods = class_copyMethodList(self, &count);
        NSMutableArray *resultsM = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            SEL name = method_getName(methods[i]);
            [resultsM addObject:NSStringFromSelector(name)];
        }
        free(methods);
        results = [resultsM copy];
        objc_setAssociatedObject(self, @selector(instanceMethods), results, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return results;
}

+ (NSArray *)classMethods {
    NSArray *results = objc_getAssociatedObject(self, @selector(classMethods));
    if (!results) {
        unsigned int count;
        Method *methods = class_copyMethodList(objc_getMetaClass(class_getName(self)), &count);
        NSMutableArray *resultsM = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            SEL name = method_getName(methods[i]);
            [resultsM addObject:NSStringFromSelector(name)];
        }
        free(methods);
        results = [resultsM copy];
        objc_setAssociatedObject(self, @selector(classMethods), results, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return results;
}

+ (NSArray *)protocols {
    NSArray *results = objc_getAssociatedObject(self, @selector(protocols));
    if (!results) {
        unsigned int count;
        Protocol *__unsafe_unretained *protocols = class_copyProtocolList(self, &count);
        NSMutableArray *resultsM = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [resultsM addObject:@(protocol_getName(protocols[i]))];
        }
        free(protocols);
        results = [resultsM copy];
        objc_setAssociatedObject(self, @selector(protocols), results, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return results;
}

+ (void)exchangeInstanceMethodWithOriginalSEL:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL {
    [self _exchangeMethodWithOriginalSEL:originalSEL swizzledSEL:swizzledSEL isClassMethod:NO];
}

+ (void)exchangeClassMethodWithOriginalSEL:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL {
    [self _exchangeMethodWithOriginalSEL:originalSEL swizzledSEL:swizzledSEL isClassMethod:YES];
}

+ (void)_exchangeMethodWithOriginalSEL:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL isClassMethod:(BOOL)isClassMethod {
    Class clazz = isClassMethod ? objc_getMetaClass(NSStringFromClass(self).UTF8String) : self;
    
    Method originalMethod = isClassMethod ? class_getClassMethod(clazz, originalSEL) : class_getInstanceMethod(clazz, originalSEL);
    Method swizzledMethod = isClassMethod ? class_getClassMethod(clazz, swizzledSEL) : class_getInstanceMethod(clazz, swizzledSEL);
    
    IMP originalImp = method_getImplementation(originalMethod);
    IMP swizzledImp = method_getImplementation(swizzledMethod);
    
    // judge the method named  swizzledMethod is already existed.
    BOOL didAddMethod = class_addMethod(clazz, originalSEL, swizzledImp, method_getTypeEncoding(swizzledMethod));
    // if swizzledMethod is already existed.
    if (didAddMethod) {
        class_replaceMethod(clazz, swizzledSEL, originalImp, method_getTypeEncoding(originalMethod));
    } else {
        class_replaceMethod(clazz,
                            swizzledSEL,
                            class_replaceMethod(clazz,
                                                originalSEL,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}
@end
