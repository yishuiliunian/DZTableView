//
//  DZDevices.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    float DeviceSystemMajorVersion();
    NSString*  netDeviceMacAddress();
    NSString* DZDevicesIdentify();
    NSDictionary* DZDevicesInfos();
#ifdef __cplusplus
}
#endif

#define bDEVICE_OSVERSION_BEFORE6 (DeviceSystemMajorVersion() < 6)
#define bDEVICE_OSVERSION_EQUAL_OR_BEFORE6 (DeviceSystemMajorVersion() - 5.99999999>0)
#define bDEVICE_OSVERSION_EQUAL_OR_LATER7 (DeviceSystemMajorVersion() - 6.9999999999 > 0)
#define bDEVICE_MACHINE_SCREEN_1136 (CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(640, 1136)))
#define bDEVICE_MACHINE_SCREEN_960 (CGSizeEqualToSize([[UIScreen mainScreen].currentMode size], CGSizeMake(640, 960)))
#define CGRectLoadViewFrame (bDEVICE_OSVERSION_EQUAL_OR_LATER7?[[UIScreen mainScreen] applicationFrame]:[UIScreen mainScreen].bounds)

@interface DZDevices : NSObject

@end
