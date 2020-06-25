//
//  AdfitAdapter.m
//
//  Created by 원소정 on 18. 2. 19..
//

#import "AdfitAdapter.h"
#import "AXLog.h"

@implementation AdfitAdapter

- (void)dealloc {
	[_adView release];
	
	[super dealloc];
}

- (NSString *)adapterName {
	return AMA_ADFIT;
}

- (CGSize)adapterSize {
	return CGSizeMake(0, 48);
}

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig {
	self = [super initWithAdInfo:adInfo adConfig:adConfig];
	if(self) {
	}
	return self;
}

- (BOOL)loadAd {
	if(self.isBanner) {
        _adView = [[AdFitBannerAdView alloc] initWithClientId:self.appCode adUnitSize:@"320x50"];
        _adView.frame = self.baseView.bounds;
        _adView.refreshInterval = 0;
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
    if(self.isBanner) {
        [_adView loadAd];
    }
}

- (void)stop {
	if(self.isBanner) {
        if(_adView) {
            _adView.delegate = nil;
            [_adView removeFromSuperview];
            [_adView release];
            _adView = nil;
        }
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
	[self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER_ERROR message:[error description]]];
}

- (void)adViewDidClickAd:(AdFitBannerAdView *)bannerAdView {
    AX_LOG(AXLogLevelDebug, @"Adfit - adViewDidClickAd");
}

@end
