//
//  NETCarbon.h
//  NETCarbon
//
//  Created by Maxwell Cabral on 4/26/14.
//  Copyright (c) 2014 Maxwell Cabral. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSUInteger kGraphiteTimeOutDefault;

typedef enum {
    NETCarbonProtocolTCP,
} NETCarbonProtocol;

/**
 *  <#Description#>
 */
@interface NETCarbon : NSObject
/**
 *  The service host. Defaults to Localhost
 */
@property (strong,nonatomic)    NSURL                       *host;
/**
 *  The port number for the service. Defaults to 2003
 */
@property (nonatomic)           ushort                      port;
/**
 *  The amount of time to wait on the socket for. Defaults to kGraphiteTimeOutDefault
 */
@property (nonatomic)           NSUInteger                  timeout;
/**
 *  Specifies the protocol to be used for TX. Carbon only supports TCP so there is currently only one option.
 */
@property (nonatomic)           NETCarbonProtocol           protocol;

/**
 *  @return A new NETCarbon object using Localhost, port 2003, and a 5 second timeout
 */
- (id)init;

/**
 *  @return A new NETCarbon object using the given host, port 2003, and a 5 second timeout
 */
- (id)initWithHost:(NSURL*)host;

/**
 *  Connects to the Graphite/Carbon service.
 *
 *  @return YES if the connection was successful
 */
- (BOOL)connect;

/**
 *  Disconnects from the Graphite/Carbon service
 */
- (void)close;

/**
 *  Sends data to Graphite/Carbon via an INET Socket
 *
 *  @param path      The statistic name to be set
 *  @param value     The numberic value to be sent
 *  @param timestamp The time the stat took plae
 *
 *  @return YES if data was sent successfully
 */
- (BOOL)sendPath:(NSString*)path numberValue:(NSNumber*)value andTime:(NSDate*)timestamp;

/**
 *  Sends data to Graphite/Carbon via an INET Socket
 *
 *  @param path      The statistic name to be set
 *  @param value     The int value to be sent
 *  @param timestamp The time the stat took plae
 *
 *  @return YES if data was sent successfully
 */
- (BOOL)sendPath:(NSString*)path intValue:(int)value andTime:(NSDate*)timestamp;

/**
 *  Sends data to Graphite/Carbon via an INET Socket
 *
 *  @param path      The statistic name to be set
 *  @param value     The float value to be sent
 *  @param timestamp The time the stat took plae
 *
 *  @return YES if data was sent successfully
 */
- (BOOL)sendPath:(NSString*)path floatValue:(float)value andTime:(NSDate*)timestamp;
@end