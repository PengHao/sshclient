//
//  UIApplication+KeyUIEvent.m
//  Vim
//
//  Created by peng hao on 2017/6/19.
//
//

#import "UIApplication+KeyUIEvent.h"
#import "NSObject+Runtime.h"
#import "KeyboardEventManager.h"
#import <objc/runtime.h>
#import <stdlib.h>

typedef
struct  {
    Class isa  OBJC_ISA_AVAILABILITY;
    
    //#if !__OBJC2__
    Class super_class                                        ;
    const char *name                                         ;
    long version                                             ;
    long info                                                ;
    long instance_size                                       ;
    struct objc_ivar_list *ivars                             ;
    struct objc_method_list **methodLists                    ;
    struct objc_cache *cache                                 ;
    struct objc_protocol_list *protocols                     ;
    //#endif
    
} objc_class2;


@implementation UIApplication (KeyUIEvent)

+(void) load {
    [super load];
    SEL sel = NSSelectorFromString(@"handleKeyHIDEvent:");
    [UIApplication swizzleMethod:sel withMethod:@selector(myHandleKeyHIDEvent:)];
}

- (void) runt:(UIEvent *) event {
    unsigned int outCount = 0;
    Class cls = [event class];
    objc_class2 cls2;
    memcpy(&cls2, (__bridge const void *)(cls), sizeof(objc_class2));
    Ivar *ivarList = class_copyIvarList([event class], &outCount);
    NSLog(@"ivars:");
    for (int i = 0; i < outCount; ++i) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSLog(@"%@ = %@", ivarName, object_getIvar(event, ivar));
        
    }
    NSLog(@"properties:");
    objc_property_t *propertyList = class_copyPropertyList([event class], &outCount);
    for (int i = 0; i < outCount; ++i) {
        objc_property_t property = propertyList[i];
        NSString *ivarName = [NSString stringWithUTF8String:property_getName(property)];
        NSLog(@"%@", ivarName);
    }
    
}

-(void) myHandleKeyHIDEvent:(UIEvent *) event{
//    https://wenku.baidu.com/view/1bfb5345b307e87101f696de.html
//    [self runt:event];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *eventString = [NSString stringWithFormat:@"%@", event];
    [eventString enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        if ([line rangeOfString:@":"].location!= NSNotFound) {
            NSArray *array = [line componentsSeparatedByString:@":"];
            NSString *key = [array objectAtIndex:0];
            NSString *value = [array objectAtIndex:1];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [dic setObject:value forKey:key];
        }
    }];
    NSString *type = [dic objectForKey:@"EventType"];
    if ([type isEqualToString:@"Keyboard"]) {
        NSString *usageStr = [dic objectForKey:@"Usage"];
        NSString *downStr = [dic objectForKey:@"Down"];
        
        NSInteger usage = [usageStr integerValue];
        BOOL isPressDown = [downStr isEqualToString:@"1"];
        [[KeyboardEventManager sharedKeyboardEventManager] handleKey:usage isPressDown:isPressDown];
    }
    
    [self myHandleKeyHIDEvent: event];
}



@end
