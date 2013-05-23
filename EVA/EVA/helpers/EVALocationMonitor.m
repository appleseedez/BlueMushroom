/*
  使用通知机制来告诉使用本manager的controller 位置信息更新了.
  原本还想采用block回调的方式. 但是面临一个问题是block无法方便地同时更新2个以上的观察者.必须编程实现(block数组)
 */
#import "EVALocationMonitor.h"

static EVALocationMonitor* _instance;
@implementation EVALocationMonitor
+ (void)initialize{
    NSAssert(self==[EVALocationMonitor class], @"EVALocationManager是单例对象不能被继承");
    _instance = [EVALocationMonitor new];
}
+ (EVALocationMonitor *)shared{
    return _instance;
}
@synthesize locationManager = _locationManager;
-(CLLocationManager *)locationManager{
    if (nil == _locationManager) {
        _locationManager = [CLLocationManager new];
    }
    return _locationManager;
}

- (id)init{
    if (self = [super init]) {
        self.locationManager.delegate = self;
    }
    return  self;
}
#pragma mark - 定位服务代理

/*
 for ios5 由于ios5 还是使用的这个方法. 所以做了个转发
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	NSArray* locations;
	if (oldLocation != nil) {
		locations = @[oldLocation,newLocation];
	}else{
		locations = @[newLocation];
	}
    
	[self locationManager:manager didUpdateLocations:locations];
}
/*
 for ios6
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
	NSAssert([locations count]>=1, @"获取当前位置失败了");
	self.currentLocation = [locations lastObject];
	self.lastLocation = [locations objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_CHANGE_NOTIFICATION object:self];
}
@end
