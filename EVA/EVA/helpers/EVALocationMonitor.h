
#import <Foundation/Foundation.h>
#ifndef LOCATION_CHANGE_NOTIFICATION
#define LOCATION_CHANGE_NOTIFICATION @"locationChanged"
#endif
/*
  用于管理用户位置的LocationManager 单例
 */
@interface EVALocationMonitor : NSObject<CLLocationManagerDelegate>
@property(nonatomic) CLLocationManager* locationManager;
@property(nonatomic) CLLocation* currentLocation;
@property(nonatomic) CLLocation* lastLocation;
+ (EVALocationMonitor*) shared;
@end
