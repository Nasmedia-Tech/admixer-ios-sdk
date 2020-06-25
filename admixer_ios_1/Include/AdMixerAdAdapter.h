//
//  AdMixerAdAdapter.h
//  AdMixer
//
//  Created by 정건국 on 12. 6. 17..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
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
- (void)displayedHalfAd:(AdMixerAdAdapter *)adapter;
- (void)closedHalfAd:(AdMixerAdAdapter *)adapter;
- (void)clickedHalfAdPopupButton:(AdMixerAdAdapter *)adapter;

@end

@interface AdMixerAdAdapter : NSObject

@property (nonatomic, retain) AdMixerInfo * adInfo;
@property (nonatomic, retain) NSDictionary * adConfig;
@property (nonatomic, retain) NSString * appCode;
@property (nonatomic, retain) AdMixerInterstitialPopupOption *interstitialPopupOption;
@property (nonatomic, retain) AdMixerHalfAdPopupOption *halfAdPopupOption;

@property (nonatomic, assign) id<AdMixerAdAdapterDelegate> delegate;
@property (nonatomic, retain) UIViewController * baseViewController;
@property (nonatomic, retain) UIView * baseView;
@property (nonatomic, assign) BOOL isBanner;
@property (nonatomic, retain) NSString * adShape;
@property (nonatomic, assign) BOOL isResultFired;
@property (nonatomic, assign) BOOL isDisplayedInterstitial;
@property (nonatomic, assign) BOOL isClosedInterstitial;
@property (nonatomic, assign) BOOL isDisplayedHalfAd;
@property (nonatomic, assign) BOOL isClosedHalfAd;

@property (nonatomic, assign) BOOL isLoadOnly;
@property (nonatomic, assign) BOOL hasInterstitialAd;
@property (nonatomic, assign) BOOL hasHalfAd;

- (NSString *)adapterName;

- (CGSize)adapterSize;

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
- (void)fireDisplayedHalfAd;
- (void)fireOnClosedHalfAd;
- (void)fireOnClickedHalfAdPopupButton; // 하프

- (BOOL)canLoadOnly:(BOOL)isBanner;
- (BOOL)canCloseInterstitial;
- (BOOL)canUseInterstitialPopupType;
- (BOOL)displayInterstital;
- (BOOL)canUseHalfAd;
- (BOOL)canCloseHalfAd;
- (BOOL)canUseHalfAdPopupType;
- (BOOL)displayHalfAd;

- (NSString *)getAdRequestTime;

@end
