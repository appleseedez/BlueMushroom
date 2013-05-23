#import "EVAAppDelegate.h"
#import "Goody.h"
@implementation EVAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self setup];
    return YES;
}
- (void) setup{
	[self setupTheme];
	[self setupDataStore];
    [self setupMapping];
	[self setupLocationManager];
}
#define  API_BASE_URL @"https://api.mongolab.com/api/1/databases/yangche-geo/collections"
#define DATA_STORAGE_FILE @"EVA.sqlite"
// 创建create managedObjectStore
- (RKManagedObjectStore *)createObjectStore {
    NSURL* managedObjectStorePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"EVA" ofType:@"momd"]];
	NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:managedObjectStorePath] mutableCopy];
	RKManagedObjectStore* managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    return managedObjectStore;
}

- (void)configObjectStore:(RKManagedObjectStore *)managedObjectStore {
    NSString* storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:DATA_STORAGE_FILE];
    NSError* addPersistentStoreError =nil;
	[managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&addPersistentStoreError];
	[managedObjectStore createManagedObjectContexts];
}

- (void) setupDataStore{
	RKManagedObjectStore *managedObjectStore = [self createObjectStore];
	[self configObjectStore:managedObjectStore];
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

- (void) setupMapping{
    
    // 通过映射coredata数据表和json数据 达到自动将JSON的数据转换为 可以存储的coredata实体
    // GET: API_ROOT/services
    [self mappingResponseForEntity:@"Goody" pathPattern:@"services" ByMapping:@{
	 @"_id.$oid":@"oid",
	 @"name": @"name",
	 @"price":@"price",
	 @"thumb":@"thumbnail",
	 @"location":@"location"} identificationAttributes:@[@"oid"] keyPath:nil];
}

- (RKEntityMapping *)setupMappingForEntity:(NSString *)entityName mapping:(NSDictionary *)mapping identificationArributes:(NSArray *)identificationArributes {
    RKEntityMapping* entityMapping = [RKEntityMapping mappingForEntityForName:entityName inManagedObjectStore:[RKManagedObjectStore defaultStore]];
	[entityMapping addAttributeMappingsFromDictionary:mapping];
	// 将oid和name作为主键
    if (identificationArributes) {
        entityMapping.identificationAttributes=identificationArributes;
    }
    return entityMapping;
}

- (void)addResponseDescriptorForPathPattern:(NSString *)pathPattern entityMapping:(RKEntityMapping *)entityMapping keyPath:(NSString *)keyPath {
    RKResponseDescriptor* responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping pathPattern:pathPattern keyPath:keyPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
	[[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
}

- (void) mappingResponseForEntity:(NSString*) entityName pathPattern:(NSString*) pathPattern ByMapping:(NSDictionary*) mapping identificationAttributes:(NSArray*) identificationArributes keyPath:(NSString*) keyPath{
    
    RKEntityMapping *entityMapping;
    entityMapping = [self setupMappingForEntity:entityName mapping:mapping identificationArributes:identificationArributes];
	[self addResponseDescriptorForPathPattern:pathPattern entityMapping:entityMapping keyPath:keyPath];
}

@end
