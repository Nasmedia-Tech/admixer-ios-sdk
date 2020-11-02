//
//  AdMixerInterstitial.h
//  AdMixer
//
//  Created by admixer on 12. 6. 13..
//  Copyright (c) 2012년 nasmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdMixer.h"
#import "AdMixerInfo.h"

@class AdMixerInterstitial;

@protocol AdMixerInterstitialDelegate <NSObject>

- (void)onSucceededToReceiveInterstitalAd:(AdMixerInterstitial *)interstitial;
- (void)onFailedToReceiveInterstitialAd:(AdMixerInterstitial *)interstitial error:(AXError *)error;
- (void)onClosedInterstitialAd:(AdMixerInterstitial *)interstitial;

@optional
- (void)onDisplayedInterstitialAd:(AdMixerInterstitial *)interstitial;
- (void)onClickedPopupButton:(AdMixerInterstitial *)interstitial;
@end


@interface AdMixerInterstitial : NSObject

@property (nonatomic, assign) id<AdMixerInterstitialDelegate> delegate;
@property (nonatomic, assign) BOOL autoClose;
@property (nonatomic, readonly) BOOL isLoadOnly;

- (void)startWithAdInfo:(AdMixerInfo *)adInfo baseViewController:(UIViewController *)viewController;
- (void)loadWithAdInfo:(AdMixerInfo *)adInfo baseViewController:(UIViewController *)viewController;
- (BOOL)displayAd;
- (void)stop;
- (void)close;
- (NSString *)loadingAdapterName;
- (NSString *)currentAdapterName;
- (NSString *)lastError;

@end
