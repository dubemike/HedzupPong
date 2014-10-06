//
//  ArchiverManager.h
//  tweetLine
//
//  Created by Michael Dubeon 2011/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <AppKit/AppKit.h> 

@class PRPBasicDataModel;

@interface ArchiverManager : NSResponder
{
 
}
  
 
//important
  @property (readonly, retain) IBOutlet PRPBasicDataModel *dataModel;



//database
 //getters  here
-(NSManagedObjectModel*) getManagedObjectModel;
-(NSManagedObjectContext*) getManagedObjectContext;


 
-(void) performSaveOnActiveContext;
-(void) performSaveOnActiveContextBeforeTerminate;

@end

@interface NSManagedObject (EasyFetching)

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;
+ (NSArray *)findAllObjectsInContext:(NSManagedObjectContext *)context;

@end

@interface NSManagedObject (safeSetValuesKeysWithDictionary)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues;
- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;

@end


/*
 Persistent store coordinator
 This is the bridge or the connection between the physical file that stores our data and our application. This bridge will be responsible for managing different object contexts.
 
 Managed object model
 This is the same concept as a schema in a database. This could represent the tables in a database or the different types of managed objects we can create in our database.
 
 Managed object context
 This is the bridge between the programmer and the managed object model. Using the managed object context, you can insert a new row into a new table, read rows from a certain table, and so on. (Actually, Core Data doesn’t use the concept of a “table,” but I’m using the term here because it’s familiar and will help you under- stand how Core Data works.)
 
 Managed object
 This is similar to a row in a table. We insert managed objects into the managed object context and save the context. This way, we create a new row in a table in our database.
 Entity
 Is the same as a table in a database
 
 Attribute
 Defines a column in the entity
 Entities will later become objects (managed objects) when we generate the code based on our object model.

*/