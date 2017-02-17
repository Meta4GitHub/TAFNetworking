//
//  HHSomeViewTranslator.m
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/17.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#import "HHSomeViewTranslator.h"

@implementation HHSomeViewTranslator

- (UIAlertView *)translateResult:(id)result {
    
    if ([result isKindOfClass:[NSArray class]] && [result count] > 0) {
        
        NSString *message = [result firstObject];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SpecialRequest" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        return alertView;
    }
    return nil;
}

@end
