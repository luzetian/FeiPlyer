//
//  GLMediaLibrary.m
//  VLC For IOS
//
//  Created by lynd on 14-4-25.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLMediaLibrary.h"
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define LIBARAY_NAME @"MediaDataBase"
@interface GLMediaLibrary()
@property(nonatomic,strong)NSManagedObjectModel *managedObjectModel;
@property(nonatomic,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end
@implementation GLMediaLibrary

#pragma mark Info
- (NSInteger) numberOfSections
{
    return _fetchedResultsController.sections.count;
}

- (NSInteger) numberOfItemsInSection: (NSInteger) section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = _fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (NSInteger) numberOfEntities
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:_entityName inManagedObjectContext:_managedObjectContext]];
    [request setIncludesSubentities:YES];
    NSError __autoreleasing *error;
    NSUInteger count = [_managedObjectContext countForFetchRequest:request error:&error];
    if(count == NSNotFound)
    {
        NSLog(@"Error: Could not count entities %@", error.localizedFailureReason);
        return 0;
    }
    
    return count;
}

# pragma mark Management
- (BOOL) save
{
    NSError __autoreleasing *error;
    BOOL success;
    if (!(success = [_managedObjectContext save:&error]))
        NSLog(@"Error saving context: %@", error.localizedFailureReason);
    return success;
}

- (BOOL) clearDataWithEntityName:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return NO;
    }
    if (fetchedObjects == nil) {
        return YES;
    }
    
    for (NSManagedObject *entry in fetchedObjects){
        [_managedObjectContext deleteObject:entry];
    }
    return [self save];
}

- (BOOL) deleteObject: (NSManagedObject *) object atEntity:(NSString *)entityName
{
    if (object == nil || ![entityName length]) {
        return NO;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count]) {
        [_managedObjectContext.undoManager beginUndoGrouping];
        [_managedObjectContext deleteObject:object];
        [_managedObjectContext.undoManager endUndoGrouping];
        [_managedObjectContext.undoManager setActionName:@"Delete"];
    }
    return [self save];
}

- (NSManagedObject *) newObjectWithEntityName:(NSString *)entityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    return object;
}

- (id)fetchItemsAtPredicate:(NSPredicate *)predicate andEntityName:(NSString *)entityName sortingBy:(NSString *)storAttribute
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
   
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:storAttribute
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"数据库没有这个数据");
        return nil;
    }
    return fetchedObjects;
}

#pragma mark Init
+ (id)sharedMediaLibrary
{
    static id shareObject = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareObject = [[[self class]alloc]init];
    });
    return shareObject;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinator];
    if (persistentStoreCoordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.undoManager = [[NSUndoManager alloc] init];
        _managedObjectContext.undoManager.levelsOfUndo = 999;
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSString *path = [self databasePath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    NSError *error;
    NSNumber *yes = @YES;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : yes,
                              NSInferMappingModelAutomaticallyOption : yes};
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSString *)databasePath
{
    int directory = NSLibraryDirectory;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *directoryPath = paths[0];
    NSString *databasePath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",LIBARAY_NAME]];
    return databasePath;
}

@end
