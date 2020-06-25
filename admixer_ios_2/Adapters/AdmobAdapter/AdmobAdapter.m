//
//  AdmobAdapter.m
//  AdMixerTest
//
//  Created by 정건국 on 12. 6. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "AdmobAdapter.h"
#import "AXLog.h"

@interface AdmobAdapter(Private)

- (void)delayedFail;

@end

@implementation AdmobAdapter

static NSArray * g_testDevices = nil;

- (void)dealloc {
    _adunitID = nil;
	[_adView release];
	[_interstitial release];
	
	[super dealloc];
}

+ (void)registerTestDevices:(NSArray *)devices {
	[devices retain];
	[g_testDevices release];
    g_testDevices = devices;
    
}

- (NSString *)adapterName {
	return ADAPTER_ADMOB;
}

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig {
	self = [super initWithAdInfo:adInfo adConfig:adConfig];
	if(self) {
        _adunitID = [self.keyInfo objectForKey:@"adunit_id"];
	}
    [GADMobileAds.sharedInstance.requestConfiguration tagForChildDirectedTreatment:[AdMixer getTagForChildDirectedTreatment]];
    return self;
}

- (BOOL)loadAd {
    if(_adunitID == nil) {
        AX_LOG(AXLogLevelDebug, @"Admob - adunit id is empty.");
        return NO;
    }
    
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            
            NSDictionary *adapterInfo = [self.adInfo getAdapterAdInfo:[self adapterName]];
            
            GADAdSize gAdSize = kGADAdSizeBanner;
            if(adapterInfo != nil) {
                NSString * adSize = (NSString *)[adapterInfo objectForKey:@"adSize"];
                
                if([adSize isEqualToString:@"kGADAdSizeBanner"]) {
                    gAdSize = kGADAdSizeBanner;
                }else if([adSize isEqualToString:@"kGADAdSizeLargeBanner"]) {
                    gAdSize = kGADAdSizeLargeBanner;
                }else if([adSize isEqualToString:@"kGADAdSizeMediumRectangle"]) {
                    gAdSize = kGADAdSizeMediumRectangle;
                }else if([adSize isEqualToString:@"kGADAdSizeFullBanner"]) {
                    gAdSize = kGADAdSizeFullBanner;
                }else if([adSize isEqualToString:@"kGADAdSizeLeaderboard"]) {
                    gAdSize = kGADAdSizeLeaderboard;
                }else if([adSize isEqualToString:@"kGADAdSizeSmartBannerLandscape"]) {
                    gAdSize = kGADAdSizeSmartBannerLandscape;
                }else if([adSize isEqualToString:@"kGADAdSizeSmartBannerPortrait"]) {
                    gAdSize = kGADAdSizeSmartBannerPortrait;
                }
            }
        
            _adView = [[GADBannerView alloc] initWithAdSize:gAdSize];
            _adView.adUnitID = _adunitID;
            _adView.delegate = self;
            _adView.rootViewController = self.baseViewController;
            _adView.hidden = YES;
            
            [self.baseView addSubview:_adView];
        } else {
            _interstitial = [[GADInterstitial alloc] initWithAdUnitID:_adunitID];
            _interstitial.delegate = self;
        }
    }else {
        return NO;
    }
	
	return YES;
}

- (void)start {
	GADRequest * request = [GADRequest request];
    request.testDevices = g_testDevices;
    request.requestAgent = @"AdMixer";
	
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            [_adView loadRequest:request];
        } else {
            [_interstitial loadRequest:request];
        }
    }
}

- (void)stop {
    if(_adView) {
        _adView.delegate = nil;
        [_adView removeFromSuperview];
        [_adView release];
        _adView = nil;
    }
    if(_interstitial) {
        _interstitial.delegate = nil;
        [_interstitial release];
        _interstitial = nil;
    }
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedFail) object:nil];
}

- (NSObject *)adObject {
	return _adView;
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    AX_LOG(AXLogLevelDebug, @"Admob - adViewDidReceiveAd");
	_adView.hidden = NO;
	[self fireSucceededToReceiveAd];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
	[error retain];
	[_error release];
	_error = error;
	[self performSelector:@selector(delayedFail) withObject:nil afterDelay:0.01];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    AX_LOG(AXLogLevelDebug, @"Admob - adViewWillPresentScreen");
    [self firePopUpScreen];
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    AX_LOG(AXLogLevelDebug, @"Admob - adViewWillDismissScreen");
    [self fireDismissScreen];
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    AX_LOG(AXLogLevelDebug, @"Admob - adViewDidDismissScreen");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    AX_LOG(AXLogLevelDebug, @"Admob - adViewWillLeaveApplication");
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    AX_LOG(AXLogLevelDebug, @"Admob - interstitialDidReceiveAd");
	
    [self fireSucceededToReceiveAd];
    
	if(!self.isLoadOnly) {
        [_interstitial presentFromRootViewController:self.baseViewController];
        
        [self fireDisplayedInterstitialAd];
        
	} else
		self.hasInterstitialAd = YES;
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
	[error retain];
	[_error release];
	_error = error;
	[self performSelector:@selector(delayedFail) withObject:nil afterDelay:0.01];
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    AX_LOG(AXLogLevelDebug, @"Admob - interstitialWillPresentScreen");
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    AX_LOG(AXLogLevelDebug, @"Admob - interstitialWillDismissScreen");
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    AX_LOG(AXLogLevelDebug, @"Admob - interstitialDidDismissScreen");
	[self fireOnClosedInterstitialAd];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    AX_LOG(AXLogLevelDebug, @"Admob - interstitialWillLeaveApplication");
}


#pragma mark - Private

- (void)delayedFail {
    AX_LOG(AXLogLevelDebug, @"Admob - didFailToReceiveAdWithError");
	[self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:[_error description]]];
}

- (BOOL)canLoadOnly {
    return YES;
}

- (BOOL)displayInterstital {
	if(!self.hasInterstitialAd)
		return NO;

	self.hasInterstitialAd = NO;
    [_interstitial presentFromRootViewController:self.baseViewController];
	[self fireDisplayedInterstitialAd];
	return YES;
}



@end
