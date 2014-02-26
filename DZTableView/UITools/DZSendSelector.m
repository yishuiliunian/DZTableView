//
//  DZSendSelector.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-15.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZSendSelector.h"

void addArgumentToArray(NSMutableArray* array, id param)
{
    if (param) {
        [array addObject:param];
    }
    else
    {
        [array addObject:[NSNull null]];
    }
}

void (^SendSelectorToObjectInMainThreadWithParams)(SEL selector, id observer, NSArray* params) = ^(SEL selector, id observer, NSArray* params)
{
    if([observer respondsToSelector:selector])
    {
        NSMethodSignature* methodSignature = [[observer class] instanceMethodSignatureForSelector:selector];
        if(methodSignature)
        {
            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setSelector:selector];
            [invocation setTarget:observer];
            NSInteger count = [params count];
            for(int i = 2 ; i < count + 2; ++i)
            {
                id argument = [params objectAtIndex:i-2];
                if([argument isKindOfClass:[NSNull class]])
                {
                    continue;
                }
                else
                {
                    [invocation setArgument:&argument atIndex:i];
                }
            }
            [invocation retainArguments];
            if([NSThread isMainThread])
            {
                [invocation invoke];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [invocation invoke];
                });
            }
        }
    }
};
void SendSelectorToObjectInMainThread(SEL selector, id observer, id params)
{
    NSMutableArray* array = [NSMutableArray array];
    addArgumentToArray(array, params);
    SendSelectorToObjectInMainThreadWithParams(selector, observer, array);
    
};
void SendSelectorToObjectInMainThreadWithoutParams(SEL selecrot, id object)
{
    SendSelectorToObjectInMainThreadWithParams(selecrot,object,nil);
};


void SendSelectorToObjectInMainThreadWith2Params(SEL selector, id observer, id params1, id param2){
    
    NSMutableArray* array = [NSMutableArray array];
    addArgumentToArray(array, params1);
    addArgumentToArray(array, param2);
    SendSelectorToObjectInMainThreadWithParams(selector, observer, array);
    
};

void SendSelectorToObjectInMainThreadWith3Params(SEL selector, id observer , id param1, id param2, id param3)
{
    NSMutableArray* array = [NSMutableArray array];
    addArgumentToArray(array, param1);
    addArgumentToArray(array, param2);
    addArgumentToArray(array, param3);
    SendSelectorToObjectInMainThreadWithParams(selector,observer,array);
};