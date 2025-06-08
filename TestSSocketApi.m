#import <SocketRocket/SocketRocket.h>
#import "TestSSocket.h"
#import "TestSSocketApi.h"

@interface TestSSocketApi () <TestSSocketProtocol>

// Delegate池
@property(nonatomic, strong) NSMutableArray <TestSSocketApiProtocol> *delegates;

@end

@implementation TestSSocketApi

#pragma mark - Public Method

- (void)connectToHost:(NSString *)host {
  if ([TestSSocket sharedInstance].socket) {
    // 如果当前socket没有关闭，需要强制关闭
    [self close];
    return;
  }

  [[TestSSocket sharedInstance] connectWithUrl:[NSURL URLWithString:host]];
}

- (void)close {
  [[TestSSocket sharedInstance] close];
}

- (void)registServerDelegateServices:(id)delegate {
  if (![self.delegates containsObject:delegate]) {
    [self.delegates addObject:delegate];
  }
}

- (void)unRegistServerDelegateServices:(id)delegate {
  [self.delegates removeObject:delegate];
}

- (void)sendString:(NSString *)string {
  [self sendWithString:string orData:nil orDictionary:nil];
}

- (void)sendData:(NSData *)data {
  [self sendWithString:nil orData:data orDictionary:nil];
}

- (void)sendDictionary:(NSDictionary *)dic {
  [self sendWithString:nil orData:nil orDictionary:dic];
}

- (void)sendWithString:(NSString *)string orData:(NSData *)data orDictionary:(NSDictionary *)dic {
  BOOL flag = (nil != string && string.length > 0) ||
          nil != data ||
          (nil != dic && dic.count > 0);

  // 如果数据为空，则不再发送
  if (!flag) {
    return;
  }

  // 一定要先判断socket是否连接，否则会导致SRWebSocket崩溃
  if ([TestSSocket sharedInstance].socket.readyState != SR_OPEN) {
    return;
  }

  NSData *targetData = nil;

  if (nil != string && string.length > 0) {
    targetData = [string dataUsingEncoding:NSUTF8StringEncoding];
  } else if (nil != data) {
    targetData = data;
  } else if (nil != dic && dic.count > 0) {
    targetData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
  }

  [[TestSSocket sharedInstance] sendData:targetData];
}

#pragma mark - Private Method

#pragma mark - SSocketDelegate

- (void)webSocketDidReceiveMessage:(id)message {
  if (message && [message isKindOfClass:[NSString class]]) {
    NSLog(@"new message: %@", message);
  }
  // 需要将该消息转发到所有客户方
  for (id <TestSSocketApiProtocol> delegate in self.delegates) {
    if (delegate && [delegate respondsToSelector:@selector(receiveMessage:)]) {
      [delegate receiveMessage:message];
    }
  }
}

- (void)webSocketDidOpen {
  NSLog(@"");
}

- (void)webSocketDidFailWithError:(NSError *)error {
  NSLog(@"");
}

- (void)webSocketDidCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
  NSLog(@"");
}

- (void)webSocketDidReceivePong:(NSData *)pongPayload {

}

#pragma mark - Action
#pragma mark - Set/Get


- (NSMutableArray <TestSSocketApiProtocol> *)delegates {
  if (!_delegates) {
    _delegates = [NSMutableArray < TestSSocketApiProtocol > new];
  }

  return _delegates;
}

#pragma mark - Life Cycle

+ (instancetype)sharedInstance {
  static TestSSocketApi *obj;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    obj = [[TestSSocketApi alloc] init];

    [TestSSocket sharedInstance].ssocketDelegate = obj;
  });
  return obj;
}

@end
