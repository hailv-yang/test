#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TestSSocketApiProtocol;

@interface TestSSocketApi : NSObject

+ (instancetype)sharedInstance;

/**
   连接Socket服务器

   @param host IM服务器地址（IP+端口或者域名）
 */
- (void)connectToHost:(NSString *)host;

- (void)close;

/**
   注册Delegate服务

   @param delegate 客户方
 */
- (void)registServerDelegateServices:(id)delegate;

- (void)unRegistServerDelegateServices:(id)delegate;

- (void)sendDictionary:(NSDictionary *)dic;

@end

/**
   提供给外部的消息动态
 */
@protocol TestSSocketApiProtocol <NSObject>

@optional

- (void)receiveMessage:(id)message;

@end

NS_ASSUME_NONNULL_END
