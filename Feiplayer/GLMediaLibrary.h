//
//  GLMediaLibrary.h
//  VLC For IOS
//
//  Created by lynd on 14-4-25.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface GLMediaLibrary : NSObject

@property (nonatomic, readonly) NSInteger numberOfEntities;
@property (nonatomic, readonly) NSInteger numberOfSections;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSString *defaultSortAttribute;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

+ (id)sharedMediaLibrary;

/*!
 *  数据库查询
 *
 *  @param predicate     通过谓词在数据库中查询
 *  @param entityName    实例名称
 *  @param storAttribute 排序方式
 *
 *  @return 查询结果
 *
 *  @since 1.0
 */
- (id)fetchItemsAtPredicate:(NSPredicate *)predicate andEntityName:(NSString *)entityName sortingBy:(NSString *)storAttribute;

/*!
 *  插入一个新实体到数据库
 *
 *  @param entity 实体名称
 *
 *  @return 创建成功的实体
 *
 *  @since 1.0
 */
- (NSManagedObject *) newObjectWithEntityName:(NSString *)entity;

/*!
 *  清除一个实体的所有数据项
 *
 *  @param entityName 实体名称
 *
 *  @return 清除是否成功
 *
 *  @since 1.0
 */
- (BOOL) clearDataWithEntityName:(NSString *)entityName;

/*!
 *  从数据库中删除一个实体的数据项
 *
 *  @param object     要删除的数据项
 *  @param entityName 实体名称
 *
 *  @return 删除是否成功
 *
 *  @since 1.0
 */
- (BOOL) deleteObject: (NSManagedObject *) object atEntity:(NSString *)entityName;

/*!
 *  保存数据
 *
 *  @return 保存操作是否成功
 *
 *  @since 1.0
 */
- (BOOL) save;

@end
