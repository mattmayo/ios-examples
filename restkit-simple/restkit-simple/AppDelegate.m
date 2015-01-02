#import "AppDelegate.h"

#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Configure your base HTTP url and create an RestKit object manager
    NSURL *baseUrl = [NSURL URLWithString:@"http://vimeo.com"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseUrl];
    
    // Initialize a RestKit managed object store with the main bundled xcdatamodeld model
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    // associate the managed object store with the restkit object manager so that HTTP request response will be automatically stored in the persistent store
    [objectManager setManagedObjectStore:managedObjectStore];
    
    // Configure mapping that is used to map a json document from the API to the main bundled model stored locally
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Movie" inManagedObjectStore:managedObjectStore];
    [entityMapping addAttributeMappingsFromDictionary:@{
                                                        @"duration" : @"duration",
                                                        @"embed_privacy" : @"embedPrivacy",
                                                        @"height" : @"height",
                                                        @"mobile_url" : @"mobileUrl",
                                                        @"id" : @"movieId",
                                                        @"description" : @"movieDescription",
                                                        @"stats_number_of_comments" : @"statsNumberOfComments",
                                                        @"stats_number_of_likes" : @"statsNumberOfLikes",
                                                        @"stats_number_of_plays" : @"statsNumberOfPlays",
                                                        @"tags" : @"tags",
                                                        @"thumbnail_large" : @"thumbnailLarge",
                                                        @"thumbnail_medium" : @"thumbnailMedium",
                                                        @"thumbnail_small" : @"thumbnailSmall",
                                                        @"title" : @"title",
                                                        @"upload_date" : @"uploadDate",
                                                        @"url" : @"url",
                                                        @"user_id" : @"userId",
                                                        @"user_name" : @"userName",
                                                        @"user_portrait_huge" : @"userPortraitHuge",
                                                        @"user_portrait_large" : @"userPortraitLarge",
                                                        @"user_portrait_medium" : @"userPortraitMedium",
                                                        @"user_portrait_small" : @"userPortraitSmall",
                                                        @"user_url" : @"userUrl",
                                                        @"width" : @"width"
                                                        }];
    
    // Register our mappings with the object manager for HTTP requests
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/api/v2/channel/staffpicks/videos.json"
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    // Setup persistent data store
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"restkit-simple.sqlite"];
    NSLog(@"Store path: %@", storePath);
    NSError *error = nil;
    NSPersistentStore *nsPersistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                                                       fromSeedDatabaseAtPath:nil
                                                                            withConfiguration:nil
                                                                                      options:nil
                                                                                        error:&error];
    NSAssert(nsPersistentStore, @"Failed to add persistent store with error: %@", error);
    [managedObjectStore createManagedObjectContexts];
    
    // Configure cache to use in-memory cache
    [managedObjectStore setManagedObjectCache:[[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:[managedObjectStore persistentStoreManagedObjectContext]]];
    
    return YES;
}

@end
