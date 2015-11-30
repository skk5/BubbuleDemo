//
//  ESDBDoer+DBOperation.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ESDBDoer+DBOperation.h"
#import <objc/runtime.h>

@implementation ESDBDoer (DBOperation)

- (BOOL)open
{
    int rslt = sqlite3_open_v2(self.filePath.UTF8String, &self->internalDB, 0, NULL);
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
        return YES;
    }else {
        DLog(@"failed to begin transaction with errorcode = %d", rslt);
        return NO;
    }
}

#pragma data operation
- (BOOL)execute:(NSString *)sql
{
    int rslt = sqlite3_exec(self->internalDB, sql.UTF8String, NULL, NULL, NULL);
    
    if(rslt == SQLITE_OK) {
        DLog(@"execute '%@' failed", sql);
        return YES;
    }else {
        DLog(@"execute '%@' success", sql);
        return NO;
    }
}

- (NSArray *)queryDBModel:(Class<ESDBModelProtocol>)clz with:(NSDictionary *)conditions
{
    // TODO:
    
    // step 1: gen sql
    unsigned int varsCount = 0;
    Ivar *vars = class_copyIvarList(clz, &varsCount);
    NSMutableString *sql = [[NSMutableString alloc] init];
//    [sql appendFormat:@"SELECT * FROM %@", ];
    
    
    
    
    // step 2: fetch data
    // step 3: convert to model
    
    
    return nil;
}

- (BOOL)saveDBModel:(id<ESDBModelProtocol>)model
{
    // TODO:
    return NO;
}

- (BOOL)deleteDBModel:(id<ESDBModelProtocol>)model
{
    // TODO:
    return NO;
}

@end
