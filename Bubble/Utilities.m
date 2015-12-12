//
//  Utilities.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/12/10.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "Utilities.h"

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
    static const char * integerTypes[] = {"c", "i", "s", "l", "q", "C", "I", "S", "L", "Q", "B"};
    static const char * floatTypes[] = {"f", "d"};
    
    
    
    return nil;
}

@end
