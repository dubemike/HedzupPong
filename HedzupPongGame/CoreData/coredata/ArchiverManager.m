 //  ArchiverManager.m
//  tweetLine
//
//  Created by Michael Dubeon 2011/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ArchiverManager.h"
#import "PRPBasicDataModel.h"
#import "globalConstants.h"

/*
 
 The manager does the saving to the database, dont referebce it directly, instead use mediator to save and fetch the data.
 
                VER: 1.0
 */
 
@implementation ArchiverManager

@synthesize dataModel;
  
 
#pragma mark- setup

- (void)dealloc {
     
    NSLog(@"ARCHIVE MANAGER RELEASED");
     
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AppInSleep" object:nil];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"saveContext" object:nil];

    [super dealloc];
}

-(id) init{
    
    [super init];
    
    PRPLog(@"[%@ %@]",CLS_STR,CMD_STR);
    dataModel = [[PRPBasicDataModel alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performSaveOnActiveContext) name:@"AppInSleep" object:nil];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performSaveOnActiveContextBeforeTerminate) name:@"saveContext" object:nil];
    
    return self;   
}

-(NSManagedObjectModel*) getManagedObjectModel{
    
    return dataModel.managedObjectModel;
}


-(NSManagedObjectContext*) getManagedObjectContext 
{
    return dataModel.mainContext;
}


#pragma mark saving to the Database

-(void) performSaveOnActiveContext
{
    
    if(![NSThread isMainThread]){

      //  NSLog(@"Not the main thread performSaveOnActiveContext...");
        
        [self performSelector:@selector(performSaveOnActiveContext) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO]; 
        
    }else {
        
         @synchronized(self){
            
            NSError *error = nil;
            
            CFShow(@"Perfroming Context Save Before Sleep");
            
            // Save the context.
            if ([dataModel.mainContext hasChanges]  && ![dataModel.mainContext save:&error]) {
                
                NSLog(@"performSaveOnActiveContext ERROR %@, %@", error, [error userInfo]);
                
                
            }
            
             
        }   
    }


}

 
-(void) performSaveOnActiveContextBeforeTerminate
{
    
    if(![NSThread isMainThread]){
       // NSLog(@"Not the main thread performSaveOnActiveContextBeforeTerminate...");
        
        [self performSelector:@selector(performSaveOnActiveContext) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    }else {
        
        //Can do some other important things here to context!!!
        @synchronized(self){
            
            NSError *error = nil;
            
            CFShow(@"Perfroming Context Save performSaveOnActiveContext MANUAL");
            
            [dataModel.persistentStoreCoordinator lock];
            // Save the context.
            if ([dataModel.mainContext hasChanges]  && ![dataModel.mainContext save:&error]) {
                
                NSLog(@"performSaveOnActiveContext ERROR %@, %@", error, [error userInfo]);
                
                [dataModel.persistentStoreCoordinator unlock];
                
            }
            
            [dataModel.persistentStoreCoordinator unlock];
            
        }
    }
    
 
    
}
 
 
@end

@implementation NSManagedObject (EasyFetching)

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;
{
    return [self respondsToSelector:@selector(entityInManagedObjectContext:)] ?
    [self performSelector:@selector(entityInManagedObjectContext:) withObject:context] :
    [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
}

 

+ (NSArray *)findAllObjectsInContext:(NSManagedObjectContext *)context;
{
    @synchronized(self){

    NSEntityDescription *entity = [self entityDescriptionInContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
   
        if (error != nil)
    {
        //handle errors
        NSLog(@"findAllObjectsInContext error %@",error);
    }
    return results;
    }
}
@end


@implementation NSManagedObject (safeSetValuesKeysWithDictionary)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    @synchronized(self){

    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
        id value = [keyedValues objectForKey:attribute];
      
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
            // Don't attempt to set nil, or you'll overwite values in self that aren't present in keyedValues
//            NSLog(@"Whoops NULL Found in safeset %@", attribute);
            continue;
        }
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [value stringValue];
        } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithInteger:[value  integerValue]];
        } else if ((attributeType == NSFloatAttributeType) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithDouble:[value doubleValue]];
        }
        [self setValue:value forKey:attribute];
    }
}

}

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter
{   
    @synchronized(self){

    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
     
        id value = [keyedValues objectForKey:attribute];
      
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [value stringValue];
            
        } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithInteger:[value integerValue]];
        } else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithDouble:[value doubleValue]];
        } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) && (dateFormatter != nil)) {
             value = [dateFormatter dateFromString:value];
        }
        [self setValue:value forKey:attribute];
    }
    
}
}
@end
 


 
