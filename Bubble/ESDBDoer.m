//
//  ESDBDoer.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ESDBDoer.h"

@interface ESDBDoer ()

@property (nonatomic, copy) NSString *filePath;

@end

@implementation ESDBDoer

// if dbfilePath is @":memory:", it is a in-memory database, and will be freed after closed.
+ (instancetype)DBDoerWithFilePath:(NSString *)dbFilePath createIfNotExists:(BOOL)create
{
    NSAssert([dbFilePath lastPathComponent].length > 0, @"db file path is not correct");
    
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:dbFilePath];
    
    if(!exists && !create) {
        return nil;
    }else {
        ESDBDoer *doer = [[ESDBDoer alloc] init];
        
        if (!exists && create) {
            NSString *fileDirectory = [dbFilePath stringByDeletingLastPathComponent];
            if(![[NSFileManager defaultManager] fileExistsAtPath:fileDirectory]) {
                if(![[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil]) {
                    DLog(@"Can't create directory for db file");
                    return nil;
                }
            }
            
            if(![[NSFileManager defaultManager] createFileAtPath:dbFilePath contents:nil attributes:nil]) {
                DLog(@"Can't create db file");
                return nil;
            }
        }
        
        doer.filePath = dbFilePath;
        
        return doer;
    }
    
    return nil;
}

@end
