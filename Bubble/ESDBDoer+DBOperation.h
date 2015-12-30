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

// if useTransaction is YES, return is 0 or models.count; otherwise, return successful insertion count.
- (NSInteger)insertDBModels:(NSArray *)models;

- (NSInteger)saveDBModels:(NSArray *)models;

- (NSInteger)deleteDBModels:(NSArray *)models;

@end
