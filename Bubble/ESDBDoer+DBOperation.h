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

- (NSArray *)queryDBModel:(Class)clz statement:(NSString *)sql;

- (NSArray *)queryDBModel:(Class)clz;

- (BOOL)insertDBModel:(id)model;

- (BOOL)saveDBModel:(id)model;

- (BOOL)deleteDBModel:(id)model;

@end
