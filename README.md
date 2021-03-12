# CrashProtector

## 简介
CrashProtector是一个针对常见的崩溃的拦截防御框架，目前可以拦截到的异常类型主要有KVC、NSArray、NSMutableArray、NSDictionary、NSMutableDictionary、NSString、NSMutableString、NSAttributedString、NSMutableAttributedString、NSCache、NSData、NSMutableData相关的越界、空值、找不到方法等错误

## 集成
1. 直接集成
把示例项目中`CrashProtector`文件夹拖到项目中即可
2. Cocoapods集成
`pod "CrashProtector"`

## 使用
1. 引入头文件
`#import <CrashProtector/CrashProtector.h>`
2. 激活
```objc
[CrashProtector activateWithExceptionHandler:^(NSException * _Nonnull exception) {
     NSLog(@"⚠️%@", exception.description);
}];
```
同时也支持自定义需要拦截的错误类型
```
[CrashProtector activate:@[
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
] exceptionHandler:^(NSException * _Nonnull exception) {
    NSLog(@"⚠️%@", exception.description);
}]
```
