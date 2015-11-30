//
//  Macros.h
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#ifdef DEBUG
#define DLog(fmt, ...) do{ NSLog((@"%d line in %@: " fmt), __LINE__, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], ##__VA_ARGS__); }while(0);
#else
#define DLog(...)
#endif

#endif /* Macros_h */
