//
//  WeatherInfo.m
//  TestForNSURLSession
//
//  Created by new on 16/10/12.
//  Copyright © 2016年 new. All rights reserved.
//

#import "WeatherInfo.h"
#import "MJExtension.h"

@implementation WeatherInfo

@synthesize city;
@synthesize cityid;
@synthesize img1;
@synthesize img2;
@synthesize ptime;
@synthesize temp1;
@synthesize temp2;
@synthesize weather;

+ (WeatherInfo *)initWeathInfoWithDictionary:(NSDictionary *)dic {
//    // 替换属性
//    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//        return @{@"city":@"city_Name"};
//    }];    
    WeatherInfo *weatherInfo = [self mj_objectWithKeyValues:dic];
    return weatherInfo;
}


@end
