//
//  ESDBDoer+TableManager.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ESDBDoer+TableManager.h"
#import "ESDBDoer+DBOperation.h"
#import "ESDBModelProtocol.h"
#import "ESBaseModel.h"
#import <objc/runtime.h>

@interface SqliteMaster : ESBaseModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tbl_name;
@property (nonatomic, assign) NSInteger rootpage;
@property (nonatomic, copy) NSString *sql;

@end

@implementation SqliteMaster

+ (NSString *)tableName
{
    return @"sqlite_master";
}

@end

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
    
    free(methodDescriptions);
    
    return YES;
}

- (BOOL)registerDBModel:(Class)modelClass, ...
{
    if(modelClass == nil) return NO;
    
    NSArray *sqliteMasters = [self allExistTable];
    
    if ([self open]) {
        
        NSArray * sqliteMaster = [sqliteMasters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tbl_name == %@", [modelClass tableName]]];
        NSString *sql = [self generateSQLForMode:modelClass existTable:sqliteMaster.firstObject];
        
        if (sql.length > 0) {
            [self execute:sql];
        }
        
        va_list list;
        va_start(list, modelClass);
        Class c = nil;
        while ((c = va_arg(list, Class)) != nil) {
            sql = [self generateSQLForMode:c existTable:[sqliteMasters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"tbl_name == %@", [c tableName]]].firstObject];
            if(sql.length > 0) {
                [self execute:sql];
            }
        }
        
        va_end(list);
        
        [self close];
    }
    
    return YES;
}

- (NSString *)generateSQLForMode:(Class)cls existTable:(SqliteMaster *)sm
{
    if(sm == nil) {
        return [cls createTableSQL];
    }else {
        NSString *oldCreateSql = [sm.sql stringByAppendingString:@";"];
        NSString *newCreateSql = [cls createTableSQL];
        
        NSMutableString *resultSql = [NSMutableString string];
        
        
        if ([oldCreateSql isEqualToString:newCreateSql]) {
            return nil;
        }
        
        NSArray *oldColumns = [self columnsInCreateSQL:oldCreateSql];
        NSArray *newColumns = [self columnsInCreateSQL:newCreateSql];
        
        NSString *tableName = [cls tableName];
        
        for(NSString *nc in newColumns) {
            BOOL isExists = NO;
            
            for(NSString *oc in oldColumns) {
                if ([self hasSamePrefix:oc with:nc]) {
                    isExists = YES;
                    break;
                }
            }
            
            if (!isExists) {
                [resultSql appendFormat:@"ALTER TABLE %@ ADD COLUMN %@;\n", tableName, nc];
            }
        }
        
        return resultSql;
    }
}

- (BOOL)hasSamePrefix:(NSString *)s1 with:(NSString *)s2
{
    NSUInteger idx = 0;
    
    while (1) {
        unichar c1 = [s1 characterAtIndex:idx];
        unichar c2 = [s2 characterAtIndex:idx];
        
        if(c1 == ' ' && c2 == ' ') {
            break;
        }
        
        if([s1 characterAtIndex:idx] != [s2 characterAtIndex:idx]) {
            return NO;
        }
        
        idx++;
    }
    
    if(idx == 0) return NO;
    
    return YES;
}

- (NSArray *)columnsInCreateSQL:(NSString *)sql
{
    NSRange leftBracketRange = [sql rangeOfString:@"("];
    NSRange rightBracketRange = [sql rangeOfString:@")" options:NSBackwardsSearch];
    
    NSString *columnsSQL = [sql substringWithRange:NSMakeRange(leftBracketRange.location + leftBracketRange.length, rightBracketRange.location - leftBracketRange.location - leftBracketRange.length)];
    
    DLog(@"%@ --> %@", sql, columnsSQL);
    
    NSArray *components = [columnsSQL componentsSeparatedByString:@","];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *s = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [result addObject:s];
    }];
    
    return result;
}

- (NSArray *)allExistTable
{
    return [self queryDBModel:[SqliteMaster class] statement:@"SELECT * FROM sqlite_master WHERE type='table';"];
}

@end
