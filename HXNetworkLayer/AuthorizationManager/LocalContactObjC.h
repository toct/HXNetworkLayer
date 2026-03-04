#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 纯 ObjC 通讯录模型，供 AddressContact.m 使用，不依赖任何 Swift 头，保证 pod spec lint 与本地构建一致。
@interface LocalContactObjC : NSObject
@property (nonatomic, copy, nullable) NSString *hx_firstName;
@property (nonatomic, copy, nullable) NSString *hx_lastName;
@property (nonatomic, copy, nullable) NSArray<NSString *> *hx_phoneArray;
@property (nonatomic, strong, nullable) NSDate *hx_alterTime;
@end

NS_ASSUME_NONNULL_END
