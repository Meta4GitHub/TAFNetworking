//
//  HHSpecialAPIManager.h
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/17.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#import "HHAPIManager.h"

typedef enum : NSUInteger {
    HHSpecialResultRawValue,
    HHSpecialResultAlertView,
    HHSpecialResultXXX
} HHSpecialResult;

@interface HHSpecialAPIConfiguration : HHDataAPIConfiguration

- (id)translateWithResultType:(HHSpecialResult)type sourceResult:(id)result;

@end

@interface HHSpecialAPIManager : HHAPIManager

- (NSNumber *)fetchNearLiveListWithUserId:(NSUInteger)userId isWomen:(BOOL)isWomen resultType:(HHSpecialResult)type completionHandler:(HHNetworkTaskCompletionHander)completionHandler;
@end
