//
//  ESCondition.h
//  BubbuleDemo
//
//  Created by Ewing on 15/12/14.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESCondition : NSObject

@property (nonatomic, copy) NSString *varName;
@property (nonatomic, copy) NSString *operation;
@property (nonatomic, strong) id varValue;

@end
