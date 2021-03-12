# CrashProtector

## 简介
CrashProtector是一个针对常见的崩溃的拦截防御框架，目前可以拦截到的异常类型主要有KVC、NSArray、NSMutableArray、NSDictionary、NSMutableDictionary、NSString、NSMutableString、NSAttributedString、NSMutableAttributedString、NSCache、NSData、NSMutableData相关的越界、空值、找不到方法等错误

## 集成
1. 直接集成<br/>
把示例项目中`CrashProtector`文件夹拖到项目中即可

2. Cocoapods集成<br/>
`pod "CrashProtector"`

## 使用
1. 引入头文件<br/>
`#import <CrashProtector/CrashProtector.h>`
2. 激活
     1. 方式一（默认拦截所有错误类型）
     ```objc
     [CrashProtector activateWithExceptionHandler:^(NSException * _Nonnull exception) {
          // 处理拦截到的异常信息
          NSLog(@"%@", exception.description);
     }];
     ```
     2. 方式二（自定义需要拦截的类型）
     ```objc
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
         // 处理拦截到的异常信息
         NSLog(@"%@", exception.description);
     }]
     ```
