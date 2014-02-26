//
//  DZDevices.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZDevices.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "NSString+WizString.h"
#import "UIDeviceHardware.h"

float DeviceSystemMajorVersion() {
    
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* versionStr = [[UIDevice currentDevice] systemVersion];
        NSArray* dots = [versionStr componentsSeparatedByString:@"."];
        float v = 0;
        for (int i = 0 ; i < dots.count; ++i) {
            NSString* str = dots[i];
            float value = [str floatValue] * pow(0.1, i);
            v += value;
        }
        _deviceSystemMajorVersion = v;
        
    });
    return _deviceSystemMajorVersion;
    
}



#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
NSString*  netDeviceMacAddress()
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%x%x%x%x%x%x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}


NSString* DZDevicesIdentify()
{
    static NSString* identify = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        identify =  [netDeviceMacAddress() MD5Hash];
    });
    return identify;
}


NSDictionary* DZDevicesInfos()
{
    static NSMutableDictionary* infos = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        infos = [NSMutableDictionary new];
        [infos setObject:DZDevicesIdentify() forKey:@"guid"];
        [infos setObject:[UIDevice currentDevice].name forKey:@"name"];
        [infos setObject:@"ios" forKey:@"type"];
        [infos setObject:[UIDeviceHardware platformString] forKey:@"platform"];
    });
    return infos;
}

@implementation DZDevices

@end
