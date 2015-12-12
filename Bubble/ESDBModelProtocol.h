//
//  ESDBModelProtocol.h
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ESDBModelProtocol <NSObject>

@required
// sql statement for create table.
+ (NSString *)createTableSQL;

// s
+ (NSString *)columnNameForIvar:(NSString *)ivarName;

// table name.
+ (NSString *)tableName;

// primary key.
+ (NSString *)primaryKey;

// sign for table of model.
+ (NSString *)modelSign;

@end
