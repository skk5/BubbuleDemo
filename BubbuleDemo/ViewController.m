//
//  ViewController.m
//  BubbuleDemo
//
//  Created by shenkuikui on 15/11/28.
//  Copyright © 2015年 Ewing. All rights reserved.
//

#import "ViewController.h"
#import "Bubble.h"

@interface TestModel: ESBaseModel

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy)   NSString *name;

@end

@implementation TestModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld\t%@: %ld\n", (long)self.defaultKey, _name, _age];
}

@end

@interface TestModel2 : ESBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *hobby;
@property (nonatomic, copy) NSString *familyName;
@property (nonatomic, assign) int    weight;

@end

@implementation TestModel2

@end

@interface ViewController ()
{
    ESDBDoer *doer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    doer = [ESDBDoer DBDoerWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"test.db"] createIfNotExists:YES];
    
    NSLog(@"db file path : %@", doer.filePath);
    
    [doer registerDBModel:[TestModel class], [TestModel2 class], nil];
    
    TestModel *tm = [[TestModel alloc] init];
    
    tm.age = 11;
    tm.name = @"Tom";
    [doer saveDBModels:@[tm]];
    
    TestModel2 *t2 = [[TestModel2 alloc] init];
    t2.name = @"t-2";
    t2.hobby = @"basketball";
    [doer saveDBModels:@[t2]];
    

    NSArray *allTestModel = [doer queryDBModel:[TestModel class]];
    NSLog(@"allTestModel: %@", allTestModel);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    TestModel *tm = [[TestModel alloc] init];
    
    tm.age = arc4random() % 40;
    tm.name = @"Tom";
    [doer insertDBModels:@[tm]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
