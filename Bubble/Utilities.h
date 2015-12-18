//
//  Utilities.h
//  BubbuleDemo
//
//  Created by shenkuikui on 15/12/10.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface Utilities : NSObject

+ (NSString *)sqlite3DataTypeOfTypeEncoding:(const char *)te;

+ (Ivar *)copyIvarListOfClass:(Class)cls outCount:(unsigned int *)count;

@end
