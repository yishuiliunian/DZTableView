//
//  UIDeviceHardware.h
//  QQPicShow
//
//  Created by welseyxiao on 13-9-27.
//  Copyright (c) 2013年 Tencent SNS Terminal Develope Center. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceName) {
    IPHONE_1,
    IPHONE_3,
    IPHONE_3GS, 
    IPHONE_4,
    IPHONE_4S,
    IPHONE_5,
    IPHONE_5C,      
    IPHONE_5S
};
#ifndef PLATFROM_DEVIDE_NAME
#define PLATFROM_DEVIDE_NAME
#define IPHONE_1    @"iPhone 1G"
#define IPHONE_3    @"iPhone 3G"
#define IPHONE_3GS  @"iPhone 3GS"
#define IPHONE_4    @"iPhone 4"
#define IPHONE_4S   @"iPhone 4S"
#define IPHONE_5    @"iPhone 5"
#define IPHONE_5C   @"iPhone 5C"
#define IPHONE_5S   @"iPhone 5S"


#endif
@interface UIDeviceHardware : NSObject
+ (NSString *) platform;
/*
 * 返回具体的设备型号，
 * 现在不再次细分网络制式，只判断设备型号
 *  @return 
 */
+ (NSString *) platformString;

@end
