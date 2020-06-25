//
//  AdMixerAdAdapter.h
//  AdMixer
//
//  Created by admixer on 12. 6. 17..
//  Copyright (c) 2012년 nasmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdMixer.h"
#import "AdMixerInfo.h"

@class AdMixerAdAdapter;

@protocol AdMixerAdAdapterDelegate <NSObject>

- (void)succeededToReceiveAdWithAdapter:(AdMixerAdAdapter *)adapter;
- (void)failedToReceiveAdWithAdapter:(AdMixerAdAdapter *)adapter error:(AXError *)error;
- (void)poppedUpScreenWithAdapter:(AdMixerAdAdapter *)adapter;
- (void)dismissedScreenWithAdapter:(AdMixerAdAdapter *)adapter;
- (void)displayedInterstitialAd:(AdMixerAdAdapter *)adapter;
- (void)closedInterstitialAd:(AdMixerAdAdapter *)adapter;
- (void)clickedPopupButton:(AdMixerAdAdapter *)adapter;

@end

@interface AdMixerAdAdapter : NSObject

@property (nonatomic, retain) NSString *adformat;
@property (nonatomic, assign) int isInterstitial;
@property (nonatomic, retain) AdMixerInfo * adInfo;
@property (nonatomic, retain) NSDictionary * adConfig;
@property (nonatomic, retain) NSDictionary * keyInfo;
@property (nonatomic, retain) AdMixerInterstitialPopupOption *interstitialPopupOption;

@property (nonatomic, assign) id<AdMixerAdAdapterDelegate> delegate;
@property (nonatomic, retain) UIViewController * baseViewController;
@property (nonatomic, retain) UIView * baseView;
@property (nonatomic, assign) BOOL isResultFired;
@property (nonatomic, assign) BOOL isDisplayedInterstitial;
@property (nonatomic, assign) BOOL isClosedInterstitial;

@property (nonatomic, assign) BOOL isLoadOnly;
@property (nonatomic, assign) BOOL hasInterstitialAd;

- (NSString *)adapterName;

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig;

- (BOOL)loadAd;

- (void)start;

- (void)stop;

- (NSObject *)adObject;

- (BOOL)supportSuccessiveLoading;

- (BOOL)successiveLoadResult;

- (void)fireSucceededToReceiveAd;
- (void)fireFailedToReceiveAdWithError:(AXError *)error;
- (void)firePopUpScreen;
- (void)fireDismissScreen;
- (void)fireDisplayedInterstitialAd;
- (void)fireOnClosedInterstitialAd;
- (void)fireOnClickedPopupButton;   // 전면

- (BOOL)canUseInterstitialAd;
- (BOOL)canLoadOnly;
- (BOOL)canCloseInterstitial;
- (BOOL)canUseInterstitialPopupType;
- (BOOL)displayInterstital;

- (NSString *)getAdRequestTime;

@end
