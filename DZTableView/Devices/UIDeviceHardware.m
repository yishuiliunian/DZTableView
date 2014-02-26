//
//  UIDeviceHardware.m
//  QQPicShow
//
//  Created by welseyxiao on 13-9-27.
//  Copyright (c) 2013年 Tencent SNS Terminal Develope Center. All rights reserved.
//

#import "UIDeviceHardware.h"
#import <sys/utsname.h>
@implementation UIDeviceHardware

+ (NSString *) platform{
        struct utsname systemInfo;
        uname(&systemInfo);
        return [NSString stringWithCString:systemInfo.machine
                                  encoding:NSUTF8StringEncoding];
}
+ (NSString *) platformString{
    NSString *platform = [UIDeviceHardware platform];
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return IPHONE_1;
    if ([platform isEqualToString:@"iPhone1,2"])    return IPHONE_3;
    if ([platform isEqualToString:@"iPhone2,1"])    return IPHONE_3GS;
    
    if ([platform isEqualToString:@"iPhone3,1"])    return IPHONE_4;
    if ([platform isEqualToString:@"iPhone3,3"])    return IPHONE_4S;
    if ([platform isEqualToString:@"iPhone4,1"])    return IPHONE_4S;
    
    if ([platform isEqualToString:@"iPhone5,1"])    return IPHONE_5;//iPhone 5 (model A1428, AT&T/Canada)
    if ([platform isEqualToString:@"iPhone5,2"])    return IPHONE_5;//iPhone 5 (model A1429, everything else)
    
    if ([platform isEqualToString:@"iPhone5,3"])    return IPHONE_5C;//iPhone 5c (model A1456, A1532 | GSM)
    if ([platform isEqualToString:@"iPhone5,4"])    return IPHONE_5C;//iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)
    
    if ([platform isEqualToString:@"iPhone6,1"])    return IPHONE_5S;//iPhone 5S(model A1433, A1533 | GSM)
    if ([platform isEqualToString:@"iPhone6,2"])    return IPHONE_5S;//iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)
    //iPod
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2";//iPad Mini
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 3";//4th Generation iPad
    //Simulator
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

@end
