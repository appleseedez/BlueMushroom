#import "EVAAppDelegate.h"
@implementation EVAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self setup];
    return YES;
}
- (void) setup{
	[self setupTheme];
	[self setupDataStore];
	[self setupLocationManager];
}
#define  API_BASE_URL @""
- (void) setupDataStore{
	NSError* addPersistentStoreError =nil;
	NSURL* managedObjectStorePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"EVA" ofType:@"momd"]];
	NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:managedObjectStorePath] mutableCopy];
	RKManagedObjectStore* managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
#define DATA_STORAGE_FILE @"EVA.sqlite"
	NSString* storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:DATA_STORAGE_FILE];
	[managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&addPersistentStoreError];
	[managedObjectStore createManagedObjectContexts];
	RKObjectManager* objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
	[objectManager setManagedObjectStore:managedObjectStore];
	[RKObjectManager setSharedManager:objectManager];
}

- (void) setupTheme{
		UIImage* backgroundImageOfBar = [[UIImage imageNamed:@"bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
		[[UINavigationBar appearance] setBackgroundImage:backgroundImageOfBar forBarMetrics:UIBarMetricsDefault];
		[[UITabBar appearance] setBackgroundImage:backgroundImageOfBar];
		[[UIToolbar appearance] setBackgroundImage:backgroundImageOfBar forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
	
}
- (void) setupLocationManager{
	
}
@end
