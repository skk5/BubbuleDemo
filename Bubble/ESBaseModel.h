//
//  ESBaseModel.h
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESDBModelProtocol.h"

@interface ESBaseModel : NSObject <ESDBModelProtocol>

@property (nonatomic, assign) NSInteger defaultKey;

@end
