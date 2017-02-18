//
//  HHSpecialAPIManager.m
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/17.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#import "HHSomeViewTranslator.h"

#import "HHSpecialAPIManager.h"

@implementation HHSpecialAPIConfiguration

- (id)translateWithResultType:(HHSpecialResult)type sourceResult:(id)result {
    
    NSArray *lives = result[@"lives"];
    NSMutableArray *liveList = [NSMutableArray array];
    for (NSDictionary *live in lives) {
        
        NSString *liveDescription = [NSString stringWithFormat:@"%@ 正在 %@ 直播, 观看人数: %ld", live[@"name"], live[@"city"], [live[@"online_users"] integerValue]];
        [liveList addObject:liveDescription];
    }
    
    switch (type) {
        case HHSpecialResultRawValue: return liveList;
        case HHSpecialResultXXX: return [HHSomeViewTranslator translateSomeViewByResult:liveList];
        case HHSpecialResultAlertView: return ({
            
            UIAlertView *alertView;
            if ([liveList count] > 0) {
                NSString *message = [liveList firstObject];
                alertView = [[UIAlertView alloc] initWithTitle:@"SpecialRequest" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            }
            alertView;
        });
    }
}

@end

@implementation HHSpecialAPIManager

- (NSNumber *)fetchNearLiveListWithUserId:(NSUInteger)userId isWomen:(BOOL)isWomen resultType:(HHSpecialResult)type completionHandler:(HHNetworkTaskCompletionHander)completionHandler {
    
    HHSpecialAPIConfiguration *config = [HHSpecialAPIConfiguration new];
    config.urlPath = @"http://116.211.167.106/api/live/aggregation";
    config.requestType = HHNetworkRequestTypeGet;
    config.requestParameters = @{@"uid" : @(userId),
                                 @"interest" : @(isWomen)};
    return [self dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
        
        if (!error) {
            
            NSArray *lives = result[@"lives"];
            if (lives.count == 0) {
                error = HHError(HHNoDataErrorNotice, HHNetworkTaskErrorNoData);
            } else {
                result = [config translateWithResultType:type sourceResult:result];
            }
        }
        
        completionHandler ? completionHandler(error, result) : nil;
    }];
}

@end
