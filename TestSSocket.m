
#import <SocketRocket/SocketRocket.h>
#import "TestSSocket.h"

@interface TestSSocket () <SRWebSocketDelegate>

@property(nonatomic, strong, readwrite) SRWebSocket *socket;

@end

@implementation TestSSocket

#pragma mark - Public

- (void)connectWithUrl:(NSURL *)url {
  self.socket = [[SRWebSocket alloc] initWithURL:url protocols:nil allowsUntrustedSSLCertificates:true];
  [self.socket setDelegate:self];
  [self.socket open];
}

- (void)close {
  if (self.socket && self.socket.readyState == SR_OPEN) {
    [self.socket close];
  }

  self.socket = nil;
}

- (void)sendData:(NSData *)data {
  [self.socket sendData:data error:nil];
}

#pragma mark - Private

#pragma mark - SRWebSocketDelegate

// 当使用open的时候，如果连接成功回调
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
  if (webSocket != self.socket) {
    return;
  }

  if (self.ssocketDelegate && [self.ssocketDelegate respondsToSelector:@selector(webSocketDidOpen)]) {
    [self.ssocketDelegate webSocketDidOpen];
  }
}

// 当服务器拒绝，或者发生错误的时候回调
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
  if (webSocket != self.socket) {
    return;
  }

  if (self.ssocketDelegate && [self.ssocketDelegate respondsToSelector:@selector(webSocketDidFailWithError:)]) {
    [self.ssocketDelegate webSocketDidFailWithError:error];
  }
}

// 服务器关闭的时候回调
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
  if (webSocket != self.socket) {
    return;
  }

  if (self.ssocketDelegate && [self.ssocketDelegate respondsToSelector:@selector(webSocketDidCloseWithCode:reason:wasClean:)]) {
    [self.ssocketDelegate webSocketDidCloseWithCode:code reason:reason wasClean:wasClean];
  }
}

// 服务器心跳回调
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
  if (webSocket != self.socket) {
    return;
  }

  if (self.ssocketDelegate && [self.ssocketDelegate respondsToSelector:@selector(webSocketDidReceivePong:)]) {
    [self.ssocketDelegate webSocketDidReceivePong:pongPayload];
  }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
  if (webSocket != self.socket) {
    return;
  }

  if (self.ssocketDelegate && [self.ssocketDelegate respondsToSelector:@selector(webSocketDidReceiveMessage:)]) {
    [self.ssocketDelegate webSocketDidReceiveMessage:message];
  }
}

#pragma mark - Set/Get

#pragma mark - Life Cycle

+ (instancetype)sharedInstance {
  static TestSSocket *obj;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    obj = [[TestSSocket alloc] init];
  });
  return obj;
}

@end
