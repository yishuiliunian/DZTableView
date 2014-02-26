//
//  DZSendSelector.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-15.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
extern "C" {
#endif
extern void addArgumentToArray(NSMutableArray* array, id param);
extern void SendSelectorToObjectInMainThread(SEL selector, id observer, id params);
extern void SendSelectorToObjectInMainThreadWith2Params(SEL selector, id observer, id params, id);
extern void SendSelectorToObjectInMainThreadWith3Params(SEL selector, id observer , id param1, id param2, id param3) ;
extern void SendSelectorToObjectInMainThreadWithoutParams(SEL selecrot, id object);

#ifdef __cplusplus
}
#endif