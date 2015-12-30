//
//  ESBaseModel.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ESBaseModel.h"
#import "Utilities.h"
#import "Macros.h"

@implementation ESBaseModel

+ (NSString *)createTableSQL
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"CREATE TABLE IF NOT EXISTS %@(", [self tableName]];
    
    unsigned int varCount = 0;
    Ivar *vars = [Utilities copyIvarListOfClass:self outCount:&varCount];
    
    BOOL hasPrimaryKey = NO;
    
    for(int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        
        NSString * varName = [NSString stringWithUTF8String:ivar_getName(var)];
        const char *varType = ivar_getTypeEncoding(var);
        
        NSString *columnName = [self columnNameForIvar:varName];
        NSString *dataType = [Utilities sqlite3DataTypeOfTypeEncoding:varType];
        
        if ([varName isEqualToString:[self primaryKey]]) {
            hasPrimaryKey = YES;
            if ([dataType isEqualToString:@"INTEGER"]) {
                [sql appendFormat:@"%@ %@ NOT NULL PRIMARY KEY AUTOINCREMENT,", columnName, dataType];
            }else {
                [sql appendFormat:@"%@ %@ NOT NULL PRIMARY KEY,", columnName, dataType];
            }
        }else {
            [sql appendFormat:@"%@ %@,", columnName, dataType];
        }
    }
    
    if (!hasPrimaryKey) {
        [sql appendFormat:@"defaultKey INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"];
    }
    
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];
    
    free(vars);
    
    
    [sql appendString:@");"];
    
    return sql;
}

+ (NSString *)tableName
{
    return NSStringFromClass(self);
}

+ (NSString *)primaryKey
{
    return @"_defaultKey";
}

+ (NSString *)columnNameForIvar:(NSString *)ivarName
{
    if([ivarName hasPrefix:@"_"]) {
        return [ivarName substringFromIndex:1];
    }else {
        return ivarName;
    }
}

// defense
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"value: %@, key: %@", value, key);
}

@end
