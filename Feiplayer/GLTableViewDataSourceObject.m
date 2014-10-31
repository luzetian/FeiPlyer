//
//  ArrayDataSource.h
//  objc.io example project (issue #1)
//

#import "GLTableViewDataSourceObject.h"


@interface GLTableViewDataSourceObject ()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, copy) TableViewCellDeleteBlock cellDeleteBlock;
@end

@implementation GLTableViewDataSourceObject

- (id)init
{
    return nil;
}

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        NSAssert(aConfigureCellBlock, @"Table view config block nil");
        self.items = [anItems mutableCopy];
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
    cellDeleteBlock:(TableViewCellDeleteBlock)aDeleteBlock
{
    self = [super init];
    if (self) {
        NSAssert(aConfigureCellBlock, @"Table view config block nil");
        NSAssert(aDeleteBlock, @"Table view delete block nil");
        self.items = [anItems mutableCopy];
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
        self.cellDeleteBlock = [aDeleteBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[(NSUInteger) indexPath.row];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    if (self.configureCellBlock) {
        id item = [self itemAtIndexPath:indexPath];
        self.configureCellBlock(cell, item, indexPath);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.cellDeleteBlock) {
            id cell = [tableView cellForRowAtIndexPath:indexPath];
            id item = [self itemAtIndexPath:indexPath];
            self.cellDeleteBlock(cell,item,indexPath);
            [self.items removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        }
    }
}

@end
