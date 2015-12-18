//
//  Utilities.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/12/10.
//  Copyright © 2015年 Ewing. All rights reserved.
//


#import "Utilities.h"
#import <objc/objc.h>

static const int integerCount = 11;
static const char * integerTypes[integerCount] = {"c", "i", "s", "l", "q", "C", "I", "S", "L", "Q", "B"};

static const int floatCount = 5;
static const char * floatTypes[floatCount] = {"f", "d", "@\"NSDate\"", "@\"NSNumber\"", "@\"NSValue\""};

static const int textCount = 7;
static const char * textTypes[textCount] = {"*", "@\"NSString\"", "@\"NSMutableString\"", "@\"NSArray\"", "@\"NSMutableArray\"", "@\"NSDictionary\"", "@\"NSMutableDictionary\""};

static const int blobCount = 2;
static const char * blobTypes[blobCount] = {"@\"UIImage\"", "@\"NSData\""};

@implementation Utilities

+ (NSString *)sqlite3DataTypeOfTypeEncoding:(const char *)te
{
    /*
     * sqlite3 type: INTEGER/FLOAT/TEXT/BLOB/NULL
     */
    
    /*
     * Objectvie-C type encodings:
     * Code            Meaning
     * c               A char
     * i               An int
     * s               A short
     * l               A long l is treated as a 32-bit quantity on 64-bit programs.
     * q               A long long
     * C               An unsigned char
     * I               An unsigned int
     * S               An unsigned short
     * L               An unsigned long
     * Q               An unsigned long long
     * f               A float
     * d               A double
     * B               A C++ bool or a C99 _Bool
     * v               A void
     * *               A character string (char *)
     * @               An object (whether statically typed or typed id)
     * #               A class object (Class)
     * :               A method selector (SEL)
     * [array type]    An array
     * {name=type...}  A structure
     * (name=type...)  A union
     * bnum            A bit field of num bits
     * ^type           A pointer to type
     * ?               An unknown type (among other things, this code is used for function pointers)
     */
    
    if (strcasecmp(te, "NSNull") == 0) {
        return @"NULL";
    }
    
    //integer
    for(int i = 0; i < integerCount; i++) {
        if(strcasecmp(te, integerTypes[i]) == 0) {
            return @"INTEGER";
        }
    }
    
    //float
    for(int i = 0; i < floatCount; i++) {
        if(strcasecmp(te, floatTypes[i]) == 0) {
            return @"FLOAT";
        }
    }
    
    //text
    for(int i = 0; i < textCount; i++) {
        if(strcasecmp(te, textTypes[i]) == 0) {
            return @"TEXT";
        }
    }
    
    //blob
    for(int i = 0; i < blobCount; i++) {
        if(strcasecmp(te, blobTypes[i]) == 0) {
            return @"BLOB";
        }
    }
    
    
    return nil;
}


+ (Ivar *)copyIvarListOfClass:(Class)cls outCount:(unsigned int *)count
{
    Ivar *result = NULL;
    int offset = 0;
    
    while (cls != [NSObject class]) {
        unsigned int varCount = 0;
        Ivar *vars = class_copyIvarList(cls, &varCount);

        if(varCount > 0) {
            result = realloc(result, sizeof(Ivar) * (varCount + offset));
            assert(result != NULL);
            
            memcpy(result + offset, vars, sizeof(Ivar) * varCount);
            
            offset += varCount;
        }
        
        free(vars);
        
        cls = [cls superclass];
    }
    
    *count = offset;
    
    return result;
}
@end
