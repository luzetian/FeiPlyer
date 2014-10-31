//
//  ArrayDataSource.h
//  objc.io example project (issue #1)
//

#import <Foundation/Foundation.h>
typedef void (^TableViewCellConfigureBlock)(id cell, id item,NSIndexPath *indexPath);
typedef void (^TableViewCellDeleteBlock)(id cell, id item,NSIndexPath *indexPath);
/**
 
 这个必须使用指定的初始化方法,不然永远返回Nil,无法创建成功
 当前版本只适用于只有1个section情况下
 
 */
@interface GLTableViewDataSourceObject : NSObject <UITableViewDataSource>

/**
 *  这个方法将返回一个通过anItems数据初始化后的table view 代理对象,参数aConfigureCellBlock \
 *  是配置cell的关键.
 *
 *  @param anItems             配置TableView的数据源
 *  @param aCellIdentifier     Cell Identifier
 *  @param aConfigureCellBlock 配置Cell的Block
 *
 *  @return Table View的代理对象
 */
- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

/**
 *  增加一个处理UITableViewCellEditingStyleDelete的block
 *
 *  @param anItems             配置TableView的数据源
 *  @param aCellIdentifier     Cell Identifier
 *  @param aConfigureCellBlock 配置Cell的Block
 *  @param aDeleteBlock        处理删除cell的block
 *
 *  @return Table View的代理对象
 */

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
    cellDeleteBlock:(TableViewCellDeleteBlock)aDeleteBlock;

/**
 *  获取indexpath指定cell的数据
 *
 *  @param indexPath 索引
 *
 *  @return indexpath指定cell的数据
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
@end
