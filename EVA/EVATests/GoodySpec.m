#import "Kiwi.h"
#import <RestKit/Testing.h>
#import "EVAGoodyListViewController.h"
#import "EVALocationMonitor.h"
#import "Goody.h"
SPEC_BEGIN(GoodySpec)
describe(@"测试启动完成后", ^{
    beforeAll(^{
        //
    });
    it(@"RKManagedObjectStore 存在", ^{
        [[[RKManagedObjectStore defaultStore] shouldNot] equal:nil];
    });
    it(@"RKObjectManager 对象存在", ^{
        RKObjectManager* objectManager = [RKObjectManager sharedManager];
        [[objectManager shouldNot] equal:nil];
    });
    it(@"ManagedObjectContexts 存在", ^{
        [[[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext] shouldNot] equal:nil];
    });
    
    afterAll(^{
    });
});
describe(@"服务列表测试", ^{
    __block EVAGoodyListViewController* goodyListViewController = nil;
//    __block RKMapping* goodyMapping = nil;
    __block RKManagedObjectStore* managedObjectStoreForTest = nil;
    beforeAll(^{
        UIStoryboard* goodyStoryboard = [UIStoryboard storyboardWithName:@"GoodyViews" bundle:nil];
        goodyListViewController = [goodyStoryboard instantiateViewControllerWithIdentifier:@"goody list"];
        [goodyListViewController view]; // 调用loadViews
        managedObjectStoreForTest =[RKTestFactory managedObjectStore ];
    });

    it(@"fetchResultController存在", ^{
        [goodyListViewController viewDidLoad];
        [[goodyListViewController fetchedResultsController] shouldNotBeNil];
    });
    it(@"获取当前位置", ^{
        // 针对CLLocationManager的测试目前只能使用mock的方式
        // 直接测试总是失败
//        CLLocation* mockLocation = [[CLLocation alloc] initWithLatitude:30.66074 longitude:104.06326999999999];
//        
//        [[EVALocationMonitor shared] locationManager:[[EVALocationMonitor shared] locationManager] didUpdateToLocation:mockLocation fromLocation:mockLocation];
//        [[[EVALocationMonitor shared] currentLocation] shouldNotBeNil];
//        [[theValue([[EVALocationMonitor shared] currentLocation] == mockLocation) should] beYes];
    });
    it(@"Goody 的映射测试", ^{
        // RestKit 的测试TMD麻烦了
//       goodyMapping = [RKEntityMapping mappingForEntityForName:@"Goody" inManagedObjectStore:managedObjectStoreForTest];
//        RKMappingTest* mappingTest = [RKMappingTest testForMapping:goodyMapping sourceObject:nil destinationObject:nil];
//        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:nil destinationKeyPath:nil]];
    });
    it(@"从服务器获取数据,获取数据地址", ^{
        
    });
    it(@"初次定位，没有位置信息时，展示距离信息", ^{
        
    });
    it(@"更新服务与用户的距离", ^{
        
    });
    it(@"更新最后刷新时间", ^{
        
    });
    afterAll(^{
        goodyListViewController = nil;
//        goodyMapping = nil;
        managedObjectStoreForTest = nil;
    });
});

SPEC_END
