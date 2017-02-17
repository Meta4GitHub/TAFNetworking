//
//  HHNormalAPIManager.h
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/17.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#import "HHAPIManager.h"

typedef enum : NSUInteger {
    HHNormalAPIError0,
    HHNormalAPIError1,
    HHNormalAPIError2
} HHNormalAPIError;

@interface HHNormalAPIManager : HHAPIManager

- (NSNumber *)fetchNearLiveListWithUserId:(NSUInteger)userId isWomen:(BOOL)isWomen completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
