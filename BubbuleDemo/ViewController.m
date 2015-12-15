//
//  ViewController.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ViewController.h"
#import "../Bubble/Macros.h"
#import "../Bubble/ESDBDoer.h"
#import "ESDBDoer+DBOperation.h"
#import "ESDBDoer+TableManager.h"
#import "ESBaseModel.h"

@interface TestModel: ESBaseModel

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy)   NSString *name;

@end

@implementation TestModel

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ESDBDoer *doer = [ESDBDoer DBDoerWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"test.db"] createIfNotExists:YES];
    
    [doer registerDBModel:[TestModel class], nil];
    
    TestModel *tm = [[TestModel alloc] init];
    
    tm.age = 11;
    tm.name = @"Tom";
    [doer saveDBModel:tm];
    
    time_t beginTime;
    time(&beginTime);
    NSArray *allTestModel = [doer queryDBModel:[TestModel class]];
    time_t endTime;
    time(&endTime);
    
    printf("%ld\n", endTime - beginTime);
    
    NSLog(@"allTestModel: %@", allTestModel);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
