#import <Foundation/Foundation.h>

@class SRWebSocket;

NS_ASSUME_NONNULL_BEGIN

@protocol TestSSocketProtocol;

@interface TestSSocket : NSObject

@property(nonatomic, strong, readonly) SRWebSocket *socket;

// Socket实时代理回调
@property(nonatomic, weak) id <TestSSocketProtocol> ssocketDelegate;

+ (instancetype)sharedInstance;

/**
   通过Url连接Socket通道

   @param url 连接URL
 */
- (void)connectWithUrl:(NSURL *)url;

/**
   关闭Socket通道
 */
- (void)close;

/**
   发送字节消息

   @param data 传输字节内容
 */
- (void)sendData:(NSData *)data;

@end

/**
   将Socket通道产生的数据，实时回调到外部
 */
@protocol TestSSocketProtocol <NSObject>
// 接收到了新数据
- (void)webSocketDidReceiveMessage:(id)message;

@optional
// socket通道已经打开
- (void)webSocketDidOpen;

// socket通道已经关闭
- (void)webSocketDidFailWithError:(NSError *)error;

// socket通道已经关闭
- (void)webSocketDidCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

// 收到服务器的pingpong消息
- (void)webSocketDidReceivePong:(NSData *)pongPayload;

@end

NS_ASSUME_NONNULL_END
