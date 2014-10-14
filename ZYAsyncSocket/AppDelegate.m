//
//  AppDelegate.m
//  ZYAsyncSocket
//
//  Created by Box on 14-10-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import "AppDelegate.h"

#define SERVER_PORT  8888

@interface AppDelegate ()

@property (assign) IBOutlet NSWindow *window;

@end

@implementation AppDelegate
@synthesize listenSocket = _listenSocket;

bool isRunning= NO;

- (void)dealloc {
    self.listenSocket = nil;
}

//发送短消息
- (void)startStop{
    if(!isRunning)
    {
        
        NSError *error = nil;
        if(![_listenSocket acceptOnPort:SERVER_PORT error:&error]){
            return;
        }
        NSLog(@"开始监听");
        
        isRunning = YES;
        
    }
    else
    {	NSLog(@"删除重新监听");
        // Stop accepting connections
        [_listenSocket disconnect];
        
        // Stop any client connections
        int i;
        for(i = 0; i < [_connectedSockets count]; i++)
        {
            
            [[_connectedSockets objectAtIndex:i] disconnect];
        }
        isRunning = false;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.listenSocket = [[AsyncSocket alloc] initWithDelegate: self];
    [self startStop];
    _connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    [_connectedSockets addObject:newSocket];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    
    NSString *welcomeMsg = @"Welcome to the AsyncSocket Echo Server\r\n";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [sock writeData:welcomeData withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    [sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
    // 这句话仅仅接收\r\n的数据
    
    [sock readDataWithTimeout:-1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *msg = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
    if(msg)
    {
        NSLog(@"message--->收到---%@",msg);
    }
    else
    {
        NSLog(@"Error converting received data into UTF-8 String");
    }
    
    NSString *welcomeMsg = @"Welcome to the AsyncSocket Echo Server\r\n";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    // Even if we were unable to write the incoming data to the log,
    // we're still going to echo it back to the client.
    [sock writeData:welcomeData withTimeout:-1 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    [_connectedSockets removeObject:sock];
}

- (IBAction)sendMessageToClient:(id)sender {
    
    NSString *welcomeMsg = @"Welcome to the AsyncSocket Echo Server\r\n";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [_connectedSockets[0] writeData:welcomeData withTimeout:-1 tag:0];
}

@end
