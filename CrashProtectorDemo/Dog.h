//
//  Dog.h
//  CrashProtectorDemo
//
//  Created by suhc on 2021/3/11.
//

#import "Animal.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dog : Animal
- (void)swizzled_instance_method;

+ (void)swizzled_class_method;
@end

NS_ASSUME_NONNULL_END
