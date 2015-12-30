# BubbuleDemo
## Description
To help you manage database, provides basic db operations, and you can do more yourself.

## Usage
copy files under `Bubble` folder to your project, add libsqlite3.0.dylib or libsqlite3.0.tbd, and import `Bubble.h` header file to your source code.

An `ESDBDoer` represents a db, you could create it with a file path:

    ESDBDoer *doer = [ESDBDoer DBDoerWithFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"test.db"] createIfNotExists:YES];

A model inherits from `ESBaseMode` represents a table in db:

    @interface TestModel: ESBaseModel
    
    @property (nonatomic, assign) NSInteger age;
    @property (nonatomic, copy)   NSString *name;
    
    @end
Then register this model class to doer, the doer will creates or alters  table for this class:

    [doer registerDBModel:[TestModel class], nil];

You could modify data like this:

    TestModel *tm = [[TestModel alloc] init];
    
    tm.age = 11;
    tm.name = @"Tom";
    [doer saveDBModels:@[tm]];
    
DB operations includes `insert/save/delete/query`.

### To be improved.
