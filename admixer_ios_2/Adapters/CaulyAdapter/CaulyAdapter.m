//
//  CaulyAdapter.m

#import "CaulyAdapter.h"
#import "AXLog.h"
#import "CaulyAdSetting.h"

@implementation CaulyAdapter

- (NSString *)adapterName {
    return ADAPTER_CAULY;
}

- (void)dealloc {
    _appCode = nil;
    if(_adView) {
        [_adView release];
        _adView = nil;
    }
    if( _interstitialAd) {
        [_interstitialAd release];
        _interstitialAd = nil;
    }
	[super dealloc];
}

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig {
	self = [super initWithAdInfo:adInfo adConfig:adConfig];
	if(self) {
        _appCode = [self.keyInfo objectForKey:@"app_code"];
        
        [CaulyAdSetting setLogLevel:CaulyLogLevelAll];
        CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
        adSetting.animType = CaulyAnimNone;
        adSetting.useDynamicReloadTime = NO;
        adSetting.reloadTime = CaulyReloadTime_120;
        adSetting.appCode = _appCode;
        
        NSDictionary *adapterInfo = [self.adInfo getAdapterAdInfo:[self adapterName]];
        
        if(adapterInfo != nil) {
            if(self.isInterstitial == 0) {
                NSString * adSize = (NSString *)[adapterInfo objectForKey:@"adSize"];
                
                if([adSize isEqualToString:@"CaulyAdSize_IPhone"]) {
                    adSetting.adSize = CaulyAdSize_IPhone;
                }else if([adSize isEqualToString:@"CaulyAdSize_IPadSmall"]) {
                    adSetting.adSize = CaulyAdSize_IPadSmall;
                }else if([adSize isEqualToString:@"CaulyAdSize_IPadLarge"]) {
                    adSetting.adSize = CaulyAdSize_IPadLarge;
                }else {
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                        adSetting.adSize = CaulyAdSize_IPhone;
                    else
                        adSetting.adSize = CaulyAdSize_IPadLarge;
                }
            }
        }
	}
	return self;
}

- (BOOL)loadAd {
    if(_appCode == nil) {
        AX_LOG(AXLogLevelDebug, @"Cauly - app code is empty.");
        return NO;
    }
    
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            _adView = [[CaulyAdView alloc] initWithParentViewController:self.baseViewController];
            [self.baseView addSubview:_adView];
            _adView.delegate = self;
            _adView.hidden = YES;
        }
        else {
            _interstitialAd = [[CaulyInterstitialAd alloc] initWithParentViewController:self.baseViewController];
            _interstitialAd.delegate = self;
        }
    }else {
        return NO;
    }
    
	return YES;
}

- (void)start {
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            [_adView startBannerAdRequest];
        } else {
            [_interstitialAd startInterstitialAdRequest];
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
    if(_interstitialAd) {
        _interstitialAd.delegate = nil;
        [_interstitialAd release];
        _interstitialAd = nil;
    }
}

- (NSObject *)adObject {
	return _adView;
}

#pragma mark - CaulyAdViewDelegate
- (void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd {
    if(isChargeableAd) {
        AX_LOG(AXLogLevelDebug, @"Cauly - didReceiveAd");
        _adView.hidden = NO;
        [self fireSucceededToReceiveAd];
    }
    else {
        if([_appCode isEqualToString:@"CAULY"]) {
            AX_LOG(AXLogLevelDebug, @"Cauly - didReceiveAd");
            _adView.hidden = NO;
            [self fireSucceededToReceiveAd];
        }else {
            AX_LOG(AXLogLevelDebug, @"Cauly - FreeAd");
            [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:@"Free Ad!"]];
        }
    }
}

- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    AX_LOG(AXLogLevelDebug, @"Cauly - didFailToReceiveAd : %@", [errorMsg description]);
	[self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:[errorMsg description]]];
}

- (void)willShowLandingView:(CaulyAdView *)adView {
    AX_LOG(AXLogLevelDebug, @"Cauly - willShowLandingView");
    if(self.isInterstitial == 0)
        [self firePopUpScreen];
}

- (void)didCloseLandingView:(CaulyAdView *)adView {
    AX_LOG(AXLogLevelDebug, @"Cauly - didCloseLandingView");
    if(self.isInterstitial == 0)
        [self fireDismissScreen];
}

#pragma mark - CaulyInterstitialAdDelegate

- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd{
    if(isChargeableAd) {
        AX_LOG(AXLogLevelDebug, @"Cauly - didReceiveInterstitialAd");
        [self fireSucceededToReceiveAd];
		if(!self.isLoadOnly) {
			[interstitialAd show];
			[self fireDisplayedInterstitialAd];
		} else
			self.hasInterstitialAd = YES;
    }
    else {
        if( [_appCode isEqualToString:@"CAULY"]) {
            AX_LOG(AXLogLevelDebug, @"Cauly - didReceiveInterstitialAd");
            [self fireSucceededToReceiveAd];
			if(!self.isLoadOnly) {
				[interstitialAd show];
				[self fireDisplayedInterstitialAd];
			} else
				self.hasInterstitialAd = YES;
        }
        else {
            AX_LOG(AXLogLevelDebug, @"Cauly - FreeInterstitialAd");
            [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:@"Free Ad!"]];
        }
    }
}

- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
	AX_LOG(AXLogLevelDebug, @"Cauly - didCloseInterstitialAd");
	[self fireOnClosedInterstitialAd];
}

- (void)willShowInterstitialAd:(CaulyInterstitialAd *)interstitalAd {
	AX_LOG(AXLogLevelDebug, @"Cauly - willShowInterstitialAd");
}

- (void)didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitalAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    AX_LOG(AXLogLevelDebug, @"Cauly - didFailToReceiveInterstitialAd");
	[self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:[errorMsg description]]];
}

- (BOOL)canLoadOnly {
    return YES;
}

- (BOOL)displayInterstital {
	if(!self.hasInterstitialAd)
		return NO;
	self.hasInterstitialAd = NO;
	[_interstitialAd show];
	[self fireDisplayedInterstitialAd];
	return YES;
}

@end
