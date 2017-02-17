//
//  HHSpecialAPIManager.h
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/17.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#import "HHAPIManager.h"

@protocol HHTranslator <NSObject>

- (UIAlertView *)translateResult:(id)result;

@end

@interface HHSpecialAPIManager : HHAPIManager

- (NSNumber *)fetchNearLiveListWithUserId:(NSUInteger)userId isWomen:(BOOL)isWomen translator:(id<HHTranslator>)translator completionHandler:(HHNetworkTaskCompletionHander)completionHandler;

@end
