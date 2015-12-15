//
//  ESDBDoer+DBOperation.h
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ESDBDoer.h"

@protocol ESDBModelProtocol;

@interface ESDBDoer (DBOperation)

// * basic operation
- (BOOL)open;

- (BOOL)beginTransaction;

- (BOOL)commit;

- (BOOL)rollback;

- (BOOL)close;

// * data operation
- (BOOL)execute:(NSString *)sql;
//
//- (BOOL)executeSave:(NSString *)sql withProcess:(BOOL(^)(sqlite3_stmt *stmt, int rsltCode))inputBlock;
//
//- (BOOL)executeQuery:(NSString *)sql withProcess:(void(^)(sqlite3_stmt *stmt, int rsltCode))outputBlock;

- (NSArray *)queryDBModel:(Class)clz;

- (BOOL)saveDBModel:(id)model;

- (BOOL)deleteDBModel:(id)model;

@end
