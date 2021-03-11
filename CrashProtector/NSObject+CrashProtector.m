//
//  NSObject+CrashProtector.m
//  CrashProtector
//
//  Created by suhc on 2021/3/9.
//

#import "NSObject+CrashProtector.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import "AppDelegate.h"

@interface ForwardingTarget : NSObject
@end
@implementation ForwardingTarget

void smartFunction(id target, SEL cmd) { }

static BOOL _addMethod(Class clazz, SEL sel) {
    NSMutableString *selName = [NSMutableString stringWithString:NSStringFromSelector(sel)];
    [selName replaceOccurrencesOfString:@":"
                               withString:@"_"
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, selName.length)];
    return class_addMethod(clazz, sel, (IMP)smartFunction, "v@:");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return _addMethod([self class], sel);
}

@end

@implementation NSObject (CrashProtector)
+ (void)avoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct CP_SEL sels[] = {
            { self, @selector(forwardingTargetForSelector:), NO },
            { self, @selector(forwardingTargetForSelector:), YES },
            { self, @selector(setValue:forKey:), NO }
        };
        int size = sizeof(sels) / sizeof(sels[0]);
        [self avoidCrashWithSels:sels size:size];
    });
}

- (id)cp_forwardingTargetForSelector:(SEL)aSelector {
    return _forwardingTargetForSelector(self, aSelector, NO);
}

+ (id)cp_forwardingTargetForSelector:(SEL)aSelector {
    return _forwardingTargetForSelector(self, aSelector, YES);
}

static inline id _forwardingTargetForSelector(id target, SEL cmd, BOOL isClassSEL) {
    static struct dl_info app_info;
    if (app_info.dli_saddr == NULL) {
        dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &app_info);
    }
    struct dl_info self_info = {0};
    dladdr((__bridge void *)[target class], &self_info);
    // system class
    if (self_info.dli_fname == NULL || strcmp(app_info.dli_fname, self_info.dli_fname)) {
        if ([target respondsToSelector:cmd]) {
            return [target cp_forwardingTargetForSelector:cmd];
        }
    }
    
    static ForwardingTarget *_forwardingTarget;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _forwardingTarget = [ForwardingTarget new];
    });
    
    NSString *tip = [NSString stringWithFormat:@"%@[%@ %@]: unrecognized selector sent to instance %p", isClassSEL?@"+":@"-", NSStringFromClass([target class]), NSStringFromSelector(cmd), target];
    NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException reason:tip userInfo:nil];
    [CrashProtector handleException:exception];
    
    return _forwardingTarget;
}

- (void)cp_setValue:(id)value forKey:(NSString *)key {
    @try {
        [self cp_setValue:value forKey:key];
    } @catch (NSException *exception) {
        [CrashProtector handleException:exception];
    }
}
@end
