//
//  ESDBDoer+DBOperation.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ESDBDoer+DBOperation.h"
#import "ESDBDoer+TableManager.h"
#import "ESDBModelProtocol.h"
#import "Utilities.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation ESDBDoer (DBOperation)

- (BOOL)open
{
    int rslt = sqlite3_open_v2(self.filePath.UTF8String, &internalDB, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if(SQLITE_OK == rslt) {
        return YES;
    }else {
        DLog(@"failed to open db with errorcode = %d", rslt);
        return NO;
    }
}

- (BOOL)beginTransaction
{
    int rslt = sqlite3_exec(self->internalDB, "BEGIN TRANSACTION", NULL, NULL, NULL);
    if(SQLITE_OK == rslt) {
        return YES;
    }else {
        DLog(@"failed to begin transaction with errorcode = %d", rslt);
        return NO;
    }
}

- (BOOL)commit
{
    
    int rslt = sqlite3_exec(self->internalDB, "COMMIT", NULL, NULL, NULL);
    if(SQLITE_OK == rslt) {
        return YES;
    }else {
        DLog(@"failed to commit with errorcode = %d", rslt);
        return NO;
    }
}

- (BOOL)rollback
{
    int rslt = sqlite3_exec(self->internalDB, "ROLLBACK", NULL, NULL, NULL);
    if(SQLITE_OK == rslt) {
        return YES;
    }else {
        DLog(@"failed to rollback with errorcode = %d", rslt);
        return NO;
    }
}

- (BOOL)close
{
    int rslt = sqlite3_close_v2(self->internalDB);
    if(SQLITE_OK == rslt) {
        DLog(@"%@", @"Database Closed!");
        return YES;
    }else {
        DLog(@"failed to begin transaction with errorcode = %d", rslt);
        return NO;
    }
}

#pragma data operation
- (BOOL)execute:(NSString *)sql
{
    if(sqlite3_complete(sql.UTF8String) == 0) {
        DLog(@"incomplete sql");
        return NO;
    }
    
    int rslt = sqlite3_exec(self->internalDB, sql.UTF8String, NULL, NULL, NULL);
    
    if(rslt == SQLITE_OK) {
        DLog(@"execute '%@' success", sql);
        return YES;
    }else {
        int errCode = sqlite3_errcode(self->internalDB);
        DLog(@"execute '%@' failed with errorCode : %d", sql, errCode);
        return NO;
    }
}

- (NSArray *)queryDBModel:(Class)clz statement:(NSString *)sql
{
    if ([self validateClass:clz] == NO) {
        return nil;
    }
    
    return nil;
}

- (NSArray *)queryDBModel:(Class)clz;
{
    // TODO:
    if([self validateClass:clz] == NO) return nil;
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    // step 1: gen sql
    unsigned int varsCount = 0;
    Ivar *vars = [Utilities copyIvarListOfClass:clz outCount:&varsCount];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [clz tableName]];
    
    if([self open]) {
        sqlite3_stmt *st = nil;
        int rsCode = sqlite3_prepare_v2(self->internalDB, sql.UTF8String, (int)[sql lengthOfBytesUsingEncoding:NSUTF8StringEncoding], &st, NULL);
        
        if(rsCode == SQLITE_OK) {
            NSMutableDictionary *columnNameToIndex = nil;
            while (sqlite3_step(st) == SQLITE_ROW) {
                id m = [[clz alloc] init];
                
                if(columnNameToIndex == nil) {
                    columnNameToIndex = [[NSMutableDictionary alloc] init];
                    int columnCount = sqlite3_column_count(st);
                    
                    for(int i = 0; i < columnCount; i++) {
                        NSString *colName = [NSString stringWithUTF8String:sqlite3_column_name(st, i)];
                        
                        if(colName.length > 0) {
                            [columnNameToIndex setObject:@(i) forKey:colName];
                        }
                    }
                }
                
                for(int i = 0; i < varsCount; i++) {
                    Ivar v = vars[i];
                    
                    NSString *varName = [NSString stringWithUTF8String:ivar_getName(v)];
                    const char *varType = ivar_getTypeEncoding(v);
                    
                    NSString *columnName = [clz columnNameForIvar: varName];
                    NSString *dataType = [Utilities sqlite3DataTypeOfTypeEncoding:varType];
                    
                    int index = [[columnNameToIndex valueForKey:columnName] intValue];
                    if([dataType isEqualToString:@"INTEGER"]) {
                        int val = sqlite3_column_int(st, index);
                        [m setValue:@(val) forKey:varName];
                    }else if([dataType isEqualToString:@"FLOAT"]) {
                        double val = sqlite3_column_double(st, index);
                        
                        if(strcasecmp(varType, "@\"NSDate\"") == 0) {
                            NSDate *date = [NSDate dateWithTimeIntervalSince1970:val];
                            [m setValue:date forKey:varName];
                        }else {
                            [m setValue:@(val) forKey:varName];
                        }
                    }else if([dataType isEqualToString:@"TEXT"]) {
                        const char *val = (const char *)sqlite3_column_text(st, index);
                        int bytesCount = sqlite3_column_bytes(st, index);
                        if(strcasecmp(varType, "@\"NSArray\"") == 0 ||
                           strcasecmp(varType, "@\"NSMutableArray\"") == 0 ||
                           strcasecmp(varType, "@\"NSDictionary\"") == 0 ||
                           strcasecmp(varType, "@\"NSMutableDictionary\"") == 0 ) {
                            id obj = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:val length:bytesCount] options:NSJSONReadingMutableContainers error:NULL];
                            
                            [m setValue:obj forKey:varName];
                        }else {
                            NSString *str = [NSString stringWithUTF8String:val];
                            [m setValue:str forKey:varName];
                        }
                    }else if([dataType isEqualToString:@"BLOB"]) {
                        const void * val = sqlite3_column_blob(st, index);
                        int bytesCount = sqlite3_column_bytes(st, index);
                        
                        if(strcasecmp(varType, "@\"NSData\"") == 0) {
                            NSData *data = [NSData dataWithBytes:val length:bytesCount];
                            
                            [m setValue:data forKey:varName];
                        }else if(strcasecmp(varType, "@\"UIImage\"") == 0) {
                            UIImage *image = [UIImage imageWithData:[NSData dataWithBytes:val length:bytesCount]];
                            
                            [m setValue:image forKey:varName];
                        }
                    }else if([dataType isEqualToString:@"NULL"]) {
                        // TODO:
                    }
                    
                    
                    
                }
                
                [models addObject:m];
            }
            
            sqlite3_finalize(st);
        }else {
            DLog(@"Compile sql failed");
        }
        
        
        [self close];
    }

    
    free(vars);
    
    return models;
}

- (BOOL)saveDBModel:(id)model
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"REPLACE INTO %@(", [[model class] tableName]];
    
    unsigned int varsCount = 0;
    Ivar *vars = [Utilities copyIvarListOfClass:[model class] outCount:&varsCount];
    for(int i = 0; i < varsCount; i++) {
        Ivar v = vars[i];
        
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(v)];
        
        [sql appendFormat:@"%@, ", [[model class] columnNameForIvar: varName]];
    }
    
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 2, 2)];
    [sql appendString:@") VALUES("];
    
    for(int i = 0; i < varsCount; i++) {
        [sql appendString:@"?, "];
    }
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 2, 2)];
    [sql appendString:@");"];
    
    DLog(@"%@", sql);
    
    if ([self open]) {
        sqlite3_stmt *stmt = nil;
        
        // compile sql
        int rsCode = sqlite3_prepare_v2(self->internalDB, sql.UTF8String, (int)[sql lengthOfBytesUsingEncoding:NSUTF8StringEncoding], &stmt, NULL);
        if(rsCode == SQLITE_OK) {
            // bind value
            for(int i = 0; i < varsCount; i++) {
                Ivar v = vars[i];
                NSString *varName = [NSString stringWithUTF8String:ivar_getName(v)];
                const char *varType = ivar_getTypeEncoding(v);
                
                NSString *dataType = [Utilities sqlite3DataTypeOfTypeEncoding:varType];
                
                if([dataType isEqualToString:@"INTEGER"]) {
                    sqlite3_bind_int(stmt, i + 1, [[model valueForKey:varName] intValue]);
                }else if([dataType isEqualToString:@"FLOAT"]) {
                    if(strcasecmp(varType, "@\"NSDate\"") == 0) {
                        NSDate *date = (NSDate *)[model valueForKey:varName];
                        NSTimeInterval interval = [date timeIntervalSince1970];
                        
                        sqlite3_bind_double(stmt, i + 1, interval);
                    }else {
                        sqlite3_bind_double(stmt, i + 1, [[model valueForKey:varName] doubleValue]);
                    }
                }else if([dataType isEqualToString:@"TEXT"]) {
                    if(strcasecmp(varType, "@\"NSArray\"") == 0 ||
                       strcasecmp(varType, "@\"NSMutableArray\"") == 0 ||
                       strcasecmp(varType, "@\"NSDictionary\"") == 0 ||
                       strcasecmp(varType, "@\"NSMutableDictionary\"") == 0 ) {
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[model valueForKey:varName] options:NSJSONWritingPrettyPrinted error:NULL];
                        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        
                        sqlite3_bind_text(stmt, i + 1, str.UTF8String, (int)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding], NULL);
                    }else {
                        NSString *str = [model valueForKey:varName];
                        
                        sqlite3_bind_text(stmt, i + 1, str.UTF8String, (int)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding], NULL);
                    }
                }else if([dataType isEqualToString:@"BLOB"]) {
                    if(strcasecmp(varType, "@\"NSData\"") == 0) {
                        NSData *data = (NSData *)[model valueForKey:varName];
                        sqlite3_bind_blob(stmt, i + 1, data.bytes, (int)data.length, NULL);
                    }else if(strcasecmp(varType, "@\"UIImage\"") == 0) {
                        UIImage *image = (UIImage *)[model valueForKey:varName];
                        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
                        sqlite3_bind_blob(stmt, i + 1, data.bytes, (int)data.length, NULL);
                    }
                }else if([dataType isEqualToString:@"NULL"]) {
                    // TODO:
                }
            }
            
            if(sqlite3_step(stmt) == SQLITE_DONE) {
                DLog(@"save success");
            }else {
                DLog(@"failed to save");
            }
            
            sqlite3_finalize(stmt);
        }else {
            DLog(@"can't compile sql");
        }
        
        [self close];
    }
    
    free(vars);
    
    return NO;
}

- (BOOL)deleteDBModel:(id)model
{
    // TODO:
    NSString *primaryKey = [[model class] primaryKey];
    
    NSString *columnName = [[model class] columnNameForIvar:primaryKey];
    Ivar var = class_getInstanceVariable([model class], primaryKey.UTF8String);
    const char *varType = ivar_getTypeEncoding(var);
    NSString *dataType = [Utilities sqlite3DataTypeOfTypeEncoding:varType];
    
    
    NSString *sql = nil;
    
    if([dataType isEqualToString:@"TEXT"] || [dataType isEqualToString:@"BLOB"]) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@';", [[model class] tableName], columnName, [model valueForKey:primaryKey]];
    }else if([dataType isEqualToString:@"INTEGER"]) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%ld;", [[model class] tableName], columnName, (long)[[model valueForKey:primaryKey] integerValue]];
    }else if([dataType isEqualToString:@"FLOAT"]) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%f;", [[model class] tableName], columnName, [[model valueForKey:primaryKey] doubleValue]];
    }
    
    BOOL rslt = NO;
    
    if([self open] ) {
        rslt = [self execute:sql];
        
        [self close];
    }
    
    return rslt;
}

@end
