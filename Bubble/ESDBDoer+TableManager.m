//
//  ESDBDoer+TableManager.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ESDBDoer+TableManager.h"
#import "ESDBDoer+DBOperation.h"
#import <objc/runtime.h>

@implementation ESDBDoer (TableManager)

- (BOOL)validateClass:(Class)clz
{
    unsigned int pMethodCount = 0;
    Protocol *p = objc_getProtocol("ESDBModelProtocol");
    struct objc_method_description * methodDescriptions = protocol_copyMethodDescriptionList(p, YES, NO, &pMethodCount);
    
    for(unsigned int i = 0; i < pMethodCount; i++) {
        struct objc_method_description description = methodDescriptions[i];
        
        Method m = class_getClassMethod(clz, description.name);
        struct objc_method_description *desc = method_getDescription(m);
        
        if (strcmp(description.types, desc->types) != 0) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)registerDBModel:(Class<ESDBModelProtocol>)modelClass, ...
{
    if (modelClass) {
        
    }else {
        
    }
    
    va_list list;
    va_start(list, modelClass);
    Class c = nil;
    while ((c = va_arg(list, Class)) != nil) {
        
    }
    
    va_end(list);
    
    return YES;
}

- (void)createManageTable
{
    NSString *sql =
    @"CREATE TABLE IF NOT EXITS { \
    table_name TEXT NOT NULL PRIMARY KEY, \
    table_sign TEXT NOT NULL, \
    }";
    
    if([self open]) {
        [self execute:sql];
    }
    
    [self close];
}

@end
