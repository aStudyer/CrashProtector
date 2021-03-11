//
//  Animal.h
//  CrashProtectorDemo
//
//  Created by suhc on 2021/3/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Animal : NSObject

- (void)animal_instance_method;

+ (void)animal_class_method;

- (void)eat:(NSString *)food;

- (void)setAge:(int)age;

- (void)original_instance_method;

+ (void)original_class_method;

- (void)swizzled_instance_method;

+ (void)swizzled_class_method;

@end

NS_ASSUME_NONNULL_END
