NetCarbon
=========

This is a simple bit of Socket code to push data directly to Graphite via the Carbon API.
You probably don't want to do this for iOS Apps (owing to security issues), but there is nothing OS X or iOS specific about the code.

Using the library is simple:

    //Defaults to localhost
    NETCarbon *graphite = [[NETCarbon alloc] initWithHost:[[NSURL alloc] initWithString:@"192.168.1.193"]];
    //Defaults to 5 seconds
    graphite.timeout = 1;
    //Not necessary as it's called by sendPath:intValue:andTime, but you can use this to check for the presence of the service
    BOOL connected = [graphite connect];
    //Time is optional, defaults to [NSDate date]
    [graphite sendPath:@"foo.bar.baz" intValue:700 andTime:nil];
