//
//  Goody.h
//  EVA
//
//  Created by Pharaoh on 13-5-15.
//  Copyright (c) 2013年 365iCar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Goody : NSManagedObject

@property (nonatomic, retain) NSString * dirt;
@property (nonatomic, retain) NSDecimalNumber * distance;
@property (nonatomic, retain) NSDate * distanceUpdateTime;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * oid;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSString * thumbnail;

@end
