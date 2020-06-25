//
//  AdfitAdapter.m
//
//  Created by 원소정 on 18. 2. 19..
//

#import "AdfitAdapter.h"
#import "AXLog.h"

@implementation AdfitAdapter;

- (void)dealloc {
    _clientId = nil;
	[_adView release];
	[super dealloc];
}

- (NSString *)adapterName {
    return ADAPTER_ADFIT;
}

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig {
	self = [super initWithAdInfo:adInfo adConfig:adConfig];
	if(self) {
        _clientId = [self.keyInfo objectForKey:@"client_id"];
	}
	return self;
}

- (BOOL)loadAd {
    if(_clientId == nil) {
        AX_LOG(AXLogLevelDebug, @"Adfit - client id is empty.");
        return NO;
    }
    
    if(self.isInterstitial == 1)
        return NO;
    
	if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        _adView = [[AdFitBannerAdView alloc] initWithClientId:_clientId adUnitSize:@"320x50"];
        _adView.frame = self.baseView.bounds;
        _adView.rootViewController = self.baseViewController;
        _adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _adView.delegate = self;
        _adView.hidden = YES;
        [self.baseView addSubview:_adView];
	} else {
        return NO;
	}
	return YES;
}

- (void)start {
    if([self.adformat isEqualToString:ADFORMAT_BANNER] && self.isInterstitial == 0) {
        [_adView loadAd];
    }
}

- (void)stop {
    if(_adView) {
        _adView.delegate = nil;
        [_adView removeFromSuperview];
        [_adView release];
        _adView = nil;
    }
}

- (NSObject *)adObject {
	return _adView;
}

- (BOOL)canUseInterstitialAd {
    return NO;
}

#pragma mark - AdFitBannerAdViewDelegate

- (void)adViewDidReceiveAd:(AdFitBannerAdView *)bannerAdView {
    AX_LOG(AXLogLevelDebug, @"Adfit - adViewDidReceiveAd");
	_adView.hidden = NO;
	[self fireSucceededToReceiveAd];
}

- (void)adViewDidFailToReceiveAd:(AdFitBannerAdView *)bannerAdView error:(NSError *)error {
	AX_LOG(AXLogLevelDebug, @"Adfit - adViewDidFailToReceiveAd : %@", [error description]);
	[self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:[error description]]];
}

- (void)adViewDidClickAd:(AdFitBannerAdView *)bannerAdView {
    AX_LOG(AXLogLevelDebug, @"Adfit - adViewDidClickAd");
}

@end
