//
//  Dog.m
//  CrashProtectorDemo
//
//  Created by suhc on 2021/3/11.
//

#import "Dog.h"

@implementation Dog
- (void)swizzled_instance_method {
    NSLog(@"%s", __FUNCTION__);
}

+ (void)swizzled_class_method {
    NSLog(@"%s", __FUNCTION__);
}
@end
