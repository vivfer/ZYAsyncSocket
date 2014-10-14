//
//  AppDelegate.h
//  ZYAsyncSocket
//
//  Created by Box on 14-10-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AsyncSocket.h"


@interface AppDelegate : NSObject <NSApplicationDelegate,AsyncSocketDelegate>{
    AsyncSocket  *_listenSocket;
    NSMutableArray *_connectedSockets;
}

@property (nonatomic, retain)AsyncSocket  *listenSocket;
@end

