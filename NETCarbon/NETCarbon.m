//
//  NETCarbon.m
//  NETCarbon
//
//  Created by Maxwell Cabral on 4/26/14.
//  Copyright (c) 2014 Maxwell Cabral. All rights reserved.
//

#import "NETCarbon.h"

const NSUInteger kGraphiteTimeOutDefault = 5;

#import <sys/un.h>
#import <sys/socket.h>
#import <netinet/in.h>
#include <arpa/inet.h>

@interface NETCarbon ()
@property (strong, nonatomic) __attribute__((NSObject)) CFSocketRef           socket;
@property (nonatomic)                                   struct sockaddr_in    address;
@end

@implementation NETCarbon
@synthesize host = _host;
@synthesize port = _port;

- (id)init
{
    self = [super init];
    if (self){
        self.protocol       = NETCarbonProtocolTCP;
        self.timeout        = kGraphiteTimeOutDefault;
        self->_port         = 2003;
        self.host           = [[NSURL alloc] initWithString:@"localhost"];
    }
    return self;
}

- (id)initWithHost:(NSURL*)host
{
    self = [self init];
    if (self){
        self.host = host;
    }
    return self;
}

- (void)dealloc
{
    [self close];
}

- (NSURL *)host
{
    return self->_host;
}

- (void)setHost:(NSURL *)host
{
    self->_host = host;
    if (host.port == 0){
        self->_port = 2003;
    } else {
        self->_port = [host.port shortValue];
    }
    
    self.address = [self buildSocketAddr];
}

- (ushort)port
{
    return self->_port;
}

- (void)setPort:(ushort)port
{
    self->_port = port;
    
    self.address = [self buildSocketAddr];
}

- (struct sockaddr_in)buildSocketAddr
{
    struct sockaddr_in address;
    address.sin_family      = AF_INET;
    address.sin_port        = htons(self.port);
    inet_aton([self.host fileSystemRepresentation], &address.sin_addr);
    //Zero the socket address' sin_zero member for security reasons
    memset(&address.sin_zero, 0, sizeof(address.sin_zero));
    
    return address;
}

- (BOOL)connect
{
    @try {
        if (self.host == nil){
            @throw [[NSException alloc] initWithName:NSInvalidArgumentException
                                              reason:@"host must not be nil"
                                            userInfo:nil];
        }
        
        self.socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, 0, NULL, NULL);
        if( socket ) {
            CFSocketError status = CFSocketConnectToAddress(self.socket,
                                                            (__bridge CFDataRef)[NSData dataWithBytes:&self->_address
                                                                                               length:sizeof(struct sockaddr_in)],
                                                            self.timeout);

            return status != kCFSocketSuccess ? NO : YES;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception when creating NETCarbon Socket: %@",exception);
        @throw exception;
    }
    
    return NO;
}

- (void)close
{
    CFSocketInvalidate(self.socket);
}

- (BOOL)sendPath:(NSString*)path stringValue:(NSString*)value andTime:(NSDate*)timestamp
{
    NSMutableString *message = [path mutableCopy];
    [message appendFormat:@" %@",value];
    
    //Timestamp is optional
    if (timestamp){
        [message appendFormat:@" %ld",(long)[timestamp timeIntervalSince1970]];
    }
    
    [message appendString:@"\n"];
    
    int failureCount = 0;
    
    //If we're not connected, try to connect three times before giving up
    while (!CFSocketIsValid(self.socket) && failureCount < 3){
        [self connect];
        failureCount++;
    }
    
    //We done blown up
    if (!CFSocketIsValid(self.socket)){
        return NO;
    }
    
    const char *messageCStr = [message cStringUsingEncoding:NSUTF8StringEncoding];
    CFDataRef Data = CFDataCreate(NULL, (const UInt8*)messageCStr, strlen(messageCStr));
    CFSocketError status = CFSocketSendData(self.socket,
                                            (__bridge CFDataRef)[NSData dataWithBytes:&self->_address
                                                                               length:sizeof(struct sockaddr_in)],
                                            Data,
                                            self.timeout);
    [self close];
    
    return status != kCFSocketSuccess ? NO : YES;
}

- (BOOL)sendPath:(NSString*)path numberValue:(NSNumber*)value andTime:(NSDate*)timestamp
{
    return [self sendPath:path stringValue:[NSString stringWithFormat:@"%@",value] andTime:timestamp];
}

- (BOOL)sendPath:(NSString*)path intValue:(int)value andTime:(NSDate*)timestamp
{
    return [self sendPath:path stringValue:[NSString stringWithFormat:@"%d",value] andTime:timestamp];
}

- (BOOL)sendPath:(NSString*)path floatValue:(float)value andTime:(NSDate*)timestamp
{
    return [self sendPath:path stringValue:[NSString stringWithFormat:@"%f",value] andTime:timestamp];
}

@end
