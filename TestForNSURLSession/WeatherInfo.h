//
//  WeatherInfo.h
//  TestForNSURLSession
//
//  Created by new on 16/10/12.
//  Copyright © 2016年 new. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfo : NSObject

@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *cityid;
@property (nonatomic, strong)NSString *img1;
@property (nonatomic, strong)NSString *img2;
@property (nonatomic, strong)NSString *ptime;
@property (nonatomic, strong)NSString *temp1;
@property (nonatomic, strong)NSString *temp2;
@property (nonatomic, strong)NSString *weather;

+ (WeatherInfo *)initWeathInfoWithDictionary:(NSDictionary *)dic;

@end
