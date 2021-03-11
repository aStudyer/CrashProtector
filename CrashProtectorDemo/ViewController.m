//
//  ViewController.m
//  CrashProtectorDemo
//
//  Created by suhc on 2021/3/9.
//

#import "ViewController.h"
#import <CrashProtector/CrashProtector.h>
#import "Dog.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CrashProtector activateWithExceptionHandler:^(NSException * _Nonnull exception) {
        NSLog(@"⚠️%@", exception.description);
    }];
    
    [self testAll];
    
    NSLog(@"😝~~~完美谢幕~~~😝");
}
#pragma mark - all
- (void)testAll {
    // hook method
    [self hood_method];
    
    // unrecognized selector
    [self test_unrecognized_selector];
    
    // NSArray
    [self test_NSArray];
    
    // NSMutableArray
    [self test_NSMutableArray];
    
    // NSDictionary
    [self test_NSDictionary];
    
    // NSMutableDictionary
    [self test_NSMutableDictionary];
    
    // NSString
    [self test_NSString];
    
    // NSMutableString
    [self test_NSMutableString];
    
    // NSAttributedString
    [self test_NSAttributedString];
    
    // NSMutableAttributedString
    [self test_NSMutableAttributedString];
    
    // KVC
    [self test_KVC];
    
    // NSCache
    [self test_NSCache];
    
    // NSData
    [self test_NSData];
    
    // NSMutableData
    [self test_NSMutableData];
}

#pragma mark - hook method
- (void)hood_method {
    [Animal exchangeClassMethodWithOriginalSEL:@selector(original_class_method) swizzledSEL:@selector(swizzled_class_method)];
    [Animal exchangeInstanceMethodWithOriginalSEL:@selector(original_instance_method) swizzledSEL:@selector(swizzled_instance_method)];
    
    [Animal original_class_method];
    Animal *animal = [Animal new];
    [animal original_instance_method];
        
    [Dog exchangeClassMethodWithOriginalSEL:@selector(original_class_method) swizzledSEL:@selector(swizzled_class_method)];
    [Dog exchangeInstanceMethodWithOriginalSEL:@selector(original_instance_method) swizzledSEL:@selector(swizzled_instance_method)];
    
    [Dog original_class_method];
    animal = [Dog new];
    [animal original_instance_method];
}

#pragma mark - unrecognized selector
- (void)test_unrecognized_selector {
    Animal *animal = [Animal new];
    [animal animal_instance_method];
    [Animal animal_class_method];
    [animal eat:@"面包"];
    [animal setAge:6];
    
    id array = @[];
    [array addObject:@"1"];
}

#pragma mark - NSArray
- (void)test_NSArray {
    NSString *nilStr = nil;
    NSArray *array = @[@"chenfanfang", nilStr, @"iOSDeveloper"];
    NSLog(@"%@",array);
    NSLog(@"%@", array[6]);
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:100];
    [array objectsAtIndexes:indexSet];
    
    NSRange range = NSMakeRange(0, 11);
    __unsafe_unretained id cArray[range.length];
    [array getObjects:cArray range:range];
}

#pragma mark - NSMutableArray
- (void)test_NSMutableArray {
    NSString *nilStr = nil;
    NSMutableArray *arrayM = [@[] mutableCopy];
    arrayM[3] = @"Lucy";
    NSLog(@"%@", arrayM[9]);
    [arrayM removeObjectAtIndex:10];
    
    [arrayM insertObject:@"Tom" atIndex:11];
    [arrayM insertObject:nilStr atIndex:12];
    
    NSRange range = NSMakeRange(0, 11);
    __unsafe_unretained id cArray[range.length];
    [arrayM getObjects:cArray range:range];
}

#pragma mark - NSDictionary
- (void)test_NSDictionary {
    NSString *nilStr = nil;
    NSDictionary *dict = @{
        @"name" : @"chenfanfang",
        @"age" : nilStr,
        nilStr : nilStr,
        nilStr : @"tom"
    };
    NSLog(@"%@", dict[@"none"]);
}

#pragma mark - NSMutableDictionary
- (void)test_NSMutableDictionary {
    NSString *nilStr = nil;
    NSMutableDictionary *dictM = [@{
        @"name" : @"chenfanfang",
        @"age" : nilStr,
        nilStr : nilStr,
        nilStr : @"tom"
    } mutableCopy];
    NSLog(@"%@", dictM[@"none"]);
    dictM[nilStr] = @"david";
    dictM[@"key"] = nilStr;
    [dictM removeObjectForKey:nilStr];
}

#pragma mark - NSString
- (void)test_NSString {
    NSString *nilStr = nil;
    NSString *str = @"1";
    [str characterAtIndex:1];
    [str substringFromIndex:2];
    [str substringToIndex:3];
    NSRange range = NSMakeRange(0, 100);
    [str substringWithRange:range];
    str = [str stringByReplacingOccurrencesOfString:@"lucy" withString:@"" options:NSCaseInsensitiveSearch range:range];
    str = [str stringByReplacingOccurrencesOfString:nilStr withString:nilStr];
    str = [str stringByReplacingCharactersInRange:range withString:@"david"];
    NSLog(@"%@",str);
}

#pragma mark - NSMutableString
- (void)test_NSMutableString {
    NSMutableString *strM = [@"" mutableCopy];
    NSRange range = NSMakeRange(0, 2);
    [strM replaceCharactersInRange:range withString:@"tom"];
        [strM insertString:@"lucy" atIndex:3];
    [strM deleteCharactersInRange:range];
}

#pragma mark - NSAttributedString
- (void)test_NSAttributedString {
    NSString *nilStr = nil;
    NSAttributedString *nilAttributedStr = nil;
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:nilStr];
    NSLog(@"%@", attributeStr);;
    attributeStr = [[NSAttributedString alloc] initWithAttributedString:nilAttributedStr];
    NSLog(@"%@",attributeStr);
    
    NSDictionary *attributes = @{
                           NSForegroundColorAttributeName : [UIColor redColor]
                           };
    attributeStr = [[NSAttributedString alloc] initWithString:nilStr attributes:attributes];
    NSLog(@"%@",attributeStr);
}

#pragma mark - NSMutableAttributedString
- (void)test_NSMutableAttributedString {
    NSString *nilStr = nil;
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:nilStr];
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : UIColor.whiteColor
                                 };
    attrStrM = [[NSMutableAttributedString alloc] initWithString:nilStr attributes:attributes];
    NSLog(@"%@",attrStrM);
}

#pragma mark - KVC
- (void)test_KVC {
    NSString *nilkey = nil;
    NSString *key = @"key";
    
    NSString *nilvalue = nil;
    NSString *value = @"value";
    
    id obj = [NSObject new];
    [obj setValue:nilvalue forKey:nilkey];
    [obj setValue:nilvalue forKey:key];
    
    [obj setValue:value forKey:nilkey];
    [obj setValue:value forKey:key];
    
    [obj setValue:nilvalue forKeyPath:nilkey];
    [obj setValue:nilvalue forKeyPath:key];
    
    [obj setValue:value forKeyPath:nilkey];
    [obj setValue:value forKeyPath:key];
    
    [obj setValuesForKeysWithDictionary:@{}];
}

#pragma mark - NSCache
- (void)test_NSCache {
    NSString *nilkey = nil;
    NSString *key = @"key";
    
    NSString *nilvalue = nil;
    NSString *value = @"value";
    
    NSCache *cache = [[NSCache alloc] init];
    [cache setObject:nilvalue forKey:nilkey];
    [cache setObject:nilvalue forKey:key cost:0];
    [cache setObject:value forKey:nilkey];
    [cache setObject:value forKey:key cost:0];
}

#pragma mark - NSData
- (void)test_NSData {
    NSData *nilData = nil;
    NSData* data = [[NSData alloc] initWithData:nilData];
    data = [NSData dataWithBytes:NULL length:0];
    [data subdataWithRange:NSMakeRange(1, 10)];
    [data rangeOfData:[@"2" dataUsingEncoding:NSUTF8StringEncoding] options:0 range:NSMakeRange(1, 10)];
    data = [@"123" dataUsingEncoding:NSUTF8StringEncoding];
    [data subdataWithRange:NSMakeRange(1, 10)];
    [data rangeOfData:[@"2" dataUsingEncoding:NSUTF8StringEncoding] options:0 range:NSMakeRange(1, 10)];
}

#pragma mark - NSMutableData
- (void)test_NSMutableData {
    const void *bytes = nil;
    NSMutableData *dataM = [NSMutableData data];
    [dataM appendData:[@"123" dataUsingEncoding:NSUTF8StringEncoding]];
    [dataM resetBytesInRange:NSMakeRange(10, 10)];
    [dataM replaceBytesInRange:NSMakeRange(0, 10) withBytes:[@"12345" dataUsingEncoding:NSUTF8StringEncoding].bytes length:5];
    [dataM replaceBytesInRange:NSMakeRange(10, 10) withBytes:[@"12345" dataUsingEncoding:NSUTF8StringEncoding].bytes];
    [dataM replaceBytesInRange:NSMakeRange(0, 0) withBytes:bytes];
}
@end
