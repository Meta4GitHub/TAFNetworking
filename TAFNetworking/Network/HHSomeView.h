//
//  HHSomeView.h
//  TAFNetworking
//
//  Created by 黑花白花 on 2017/2/18.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HHSomeView;
@protocol HHSomeViewTranslator <NSObject>

+ (HHSomeView *)translateSomeViewByResult:(id)result;

@end

@interface HHSomeView : UIView

@end
