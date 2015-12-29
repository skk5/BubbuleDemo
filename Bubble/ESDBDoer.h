//
//  ESDBDoer.h
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Macros.h"

@class ESBaseModel;
@protocol ESDBModelProtocol;

@interface ESDBDoer : NSObject
{
    @private
    sqlite3 *internalDB;
    
    NSMutableDictionary *cacheModelInfo;
}

+ (instancetype)DBDoerWithFilePath:(NSString *)dbFilePath createIfNotExists:(BOOL)create;

@property (nonatomic, assign) BOOL enableLog;
@property (nonatomic, copy, readonly) NSString *filePath;

@end
