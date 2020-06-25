//
//  AdMixerView.h
//  AdMixer
//
//  Created by admixer on 12. 6. 13..
//  Copyright (c) 2012년 nasmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMixer.h"
#import "AdMixerInfo.h"
#import "AXError.h"

@class AdMixerView;

@protocol AdMixerViewDelegate <NSObject>

- (void)onSucceededToReceiveAd:(AdMixerView *)adView;
- (void)onFailedToReceiveAd:(AdMixerView *)adView error:(AXError *)error;

@optional
- (void)onClickedAd:(AdMixerView *)adView adapterName:(NSString *)adapterName;

@end

@interface AdMixerView : UIView

@property (nonatomic, assign) id<AdMixerViewDelegate> delegate;

- (void)startWithAdInfo:(AdMixerInfo *)adInfo baseViewController:(UIViewController *)viewController;
- (void)stop;
- (NSString *)loadingAdapterName;
- (NSString *)currentAdapterName;
- (NSString *)lastError;

@end
