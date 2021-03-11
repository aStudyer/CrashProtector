//
//  Animal.m
//  CrashProtectorDemo
//
//  Created by suhc on 2021/3/11.
//

#import "Animal.h"

@implementation Animal
- (void)original_instance_method {
    NSLog(@"%s", __FUNCTION__);
}

+ (void)original_class_method {
    NSLog(@"%s", __FUNCTION__);
}

- (void)swizzled_instance_method {
    NSLog(@"%s", __FUNCTION__);
}

+ (void)swizzled_class_method {
    NSLog(@"%s", __FUNCTION__);
}
@end
