//
//  ESBaseModel.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ESBaseModel.h"
#import <objc/runtime.h>

@implementation ESBaseModel
{
    NSInteger internalKey;
}

+ (NSString *)createTableSQL
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"CREATE TABLE IF NOT EXISTS %@ {", [self tableName]];
    
    unsigned int varCount = 0;
    Ivar *vars = class_copyIvarList(self, &varCount);
    
    for(int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        const char * varName = ivar_getName(var);
        const char * varType = ivar_getTypeEncoding(var);
        
    }
    
    free(vars);
    
    
    [sql appendString:@"};"];
    return sql;
}

+ (NSString *)tableName
{
    return NSStringFromClass(self);
}

+ (NSString *)primaryKey
{
    return @"internalKey";
}

+ (NSString *)modelSign
{
    return nil;
}

+ (NSString *)columnNameForIvar:(NSString *)ivarName
{
    if ([ivarName hasPrefix:@"_"]) {
        return [[self tableName] stringByAppendingString:ivarName];
    }else {
        return [NSString stringWithFormat:@"%@_%@", [self tableName], ivarName];
    }
}

@end
