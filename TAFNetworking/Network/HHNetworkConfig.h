//
//  HHNetworkConfig.h
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/11.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#ifndef HHNetworkConfig_h
#define HHNetworkConfig_h

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HHService0,
    HHService1,
    HHService2
} HHServiceType;

#define ServiceCount 3
#define HHSwitchServiceNotification @"HHSwitchServiceNotification"

typedef enum : NSUInteger {
    HHServiceEnvironmentTest,
    HHServiceEnvironmentDevelop,
    HHServiceEnvironmentRelease
} HHServiceEnvironment;

#define BulidServiceEnvironment HHServiceEnvironmentRelease

typedef enum : NSUInteger {
    HHNetworkRequestTypeGet,
    HHNetworkRequestTypePost
} HHNetworkRequestType;

#define RequestTimeoutInterval 8

#endif
