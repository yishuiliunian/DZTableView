//
//  DZProgramDefines.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-21.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFINE_PROPERTY_KEY(key)  static void const *  kPK##key = &kPK##key

/**
 *
 * 定义字符串
 */
#define DEFINE_NSString(str)  static NSString* const kDZ##str = @""#str;

#define DEFINE_NOTIFICATION_MESSAGE(str) static NSString* const kDZNotification_##str = @""#str;

#define DEFINE_PROPERTY(mnmKind, type , name) @property (nonatomic, mnmKind)  type  name
#define DEFINE_PROPERTY_ASSIGN(type, name) DEFINE_PROPERTY(assign, type, name)
#define DEFINE_PROPERTY_ASSIGN_Float(name) DEFINE_PROPERTY_ASSIGN(float, name)
#define DEFINE_PROPERTY_ASSIGN_INT64(name) DEFINE_PROPERTY_ASSIGN(int64_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT32(name) DEFINE_PROPERTY_ASSIGN(int32_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT16(name) DEFINE_PROPERTY_ASSIGN(int16_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT8(name) DEFINE_PROPERTY_ASSIGN(int8_t, name)
#define DEFINE_PROPERTY_ASSIGN_Double(name) DEFINE_PROPERTY_ASSIGN(double, name)


#define DEFINE_PROPERTY_STRONG(type, name) DEFINE_PROPERTY(strong, type, name)
#define DEFINE_PROPERTY_STRONG_UILabel(name) DEFINE_PROPERTY_STRONG(UILabel*, name)
#define DEFINE_PROPERTY_STRONG_NSString(name) DEFINE_PROPERTY_STRONG(NSString*, name)
#define DEFINE_PROPERTY_STRONG_UIImageView(name) DEFINE_PROPERTY_STRONG(UIImageView*, name)



#define INIT_SUBVIEW(sView, class, name) name = [[class alloc] init]; [sView addSubview:name];
#define INIT_SUBVIEW_UIImageView(sView, name) INIT_SUBVIEW(sView, UIImageView, name)
#define INIT_SUBVIEW_UILabel(sView, name) INIT_SUBVIEW(sView, UILabel, name)

#define INIT_SELF_SUBVIEW(class, name) INIT_SUBVIEW(self, class , name)
#define INIT_SELF_SUBVIEW_UIImageView(name) INIT_SUBVIEW_UIImageView(self, name)
#define INIT_SELF_SUBVIEW_UILabel(name) INIT_SUBVIEW_UILabel(self, name)


#define DEFINE_PROPERTY_WEAK(type, name) DEFINE_PROPERTY(weak, type, name)

/**
 *  初始化一个点击的手势
 *
 *  @param name   点击手势的名称
 *  @param view   要添加手势的视图的名称
 *  @param taps   需要的点击次数
 *  @param touchs 需要的手指数量
 *
 */
#define INIT_GESTRUE_TAP_IN_VIEW(name, view, taps, touchs)  name=[[UITapGestureRecognizer alloc] init];\
name.numberOfTapsRequired = 1;\
name.numberOfTouchesRequired = 1;\
[view addGestureRecognizer:name];

/**
 *  在当前视图上初始化一个点击手势
 */
#define INIT_GESTRUE_TAP_IN_SELF(name, taps, touchs) INIT_GESTRUE_TAP_IN_VIEW(name, self, taps, touchs)

@interface DZProgramDefines : NSObject

@end
