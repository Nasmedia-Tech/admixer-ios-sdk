//
//  SmaatoAdapter.m

#import "SmaatoAdapter.h"
#import "AXLog.h"

@implementation SmaatoAdapter

- (void)dealloc {
    _adspaceID = nil;
    [_adView release];
    [_interstitialAd release];
    [super dealloc];
}

- (NSString *)adapterName {
    return ADAPTER_SMAATO;
}

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig {
    self = [super initWithAdInfo:adInfo adConfig:adConfig];
    if(self) {
        _adspaceID = [self.keyInfo objectForKey:@"adspace_id"];
    }
    SmaatoSDK.gpsEnabled = NO;
    
    return self;
}

- (BOOL)loadAd {
    if(_adspaceID == nil) {
        AX_LOG(AXLogLevelDebug, @"Smaato - adspace id is empty.");
        return NO;
    }
    
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            _adView = [[SMABannerView alloc] initWithFrame:self.baseView.bounds];
            _adView.delegate = self;
            _adView.hidden = YES;
            _adView.autoreloadInterval = kSMABannerAutoreloadIntervalDisabled;
            [self.baseView addSubview:_adView];
            
        }else {
            
        }
    }else {
        return NO;
    }
    
    return YES;
}

- (void)start {
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            NSDictionary *adapterInfo = [self.adInfo getAdapterAdInfo:[self adapterName]];
            SMABannerAdSize * kSMAAdSize = kSMABannerAdSizeXXLarge_320x50;
            if(adapterInfo != nil) {
                NSString * adSize = (NSString *)[adapterInfo objectForKey:@"adSize"];
                
                if([adSize isEqualToString:@"kSMABannerAdSizeXXLarge_320x50"]) {
                    kSMAAdSize = kSMABannerAdSizeXXLarge_320x50;
                }else if([adSize isEqualToString:@"kSMABannerAdSizeMediumRectangle_300x250"]) {
                    kSMAAdSize = kSMABannerAdSizeMediumRectangle_300x250;
                }else if([adSize isEqualToString:@"kSMABannerAdSizeLeaderboard_728x90"]) {
                    kSMAAdSize = kSMABannerAdSizeLeaderboard_728x90;
                }else if([adSize isEqualToString:@"kSMABannerAdSizeSkyscraper_120x600"]) {
                    kSMAAdSize = kSMABannerAdSizeSkyscraper_120x600;
                }
            }
            [_adView loadWithAdSpaceId:_adspaceID adSize:kSMAAdSize];
        } else {
            [SmaatoSDK loadInterstitialForAdSpaceId:_adspaceID delegate:self];
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
        [_interstitialAd release];
        _interstitialAd = nil;
    }
}

- (NSObject *)adObject {
    return _adView;
}

# pragma mark - SMABannerViewDelegate
- (UIViewController *)presentingViewControllerForBannerView:(SMABannerView *)bannerView {
    return self.baseViewController;
}
- (void)bannerViewDidLoad:(SMABannerView *)bannerView {
    AX_LOG(AXLogLevelDebug, @"Smaato - bannerViewDidLoad");
    _adView.hidden = NO;
    [self fireSucceededToReceiveAd];
}
- (void)bannerView:(SMABannerView *)bannerView didFailWithError:(NSError *)error {
    AX_LOG(AXLogLevelDebug, @"Smaato - didFailWithError");
    [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:[error description]]];
}
- (void)bannerViewDidTTLExpire:(SMABannerView *)bannerView {
    AX_LOG(AXLogLevelDebug, @"Smaato - bannerViewDidTTLExpire");
}

# pragma mark - SMAInterstitialDelegate
- (void)interstitialDidLoad:(SMAInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Smaato - interstitialDidLoad");
    _interstitialAd = [interstitial retain];
    [self fireSucceededToReceiveAd];
    
    [_interstitialAd showFromViewController:self.baseViewController];
    [self fireDisplayedInterstitialAd];
}
- (void)interstitial:(SMAInterstitial *)interstitial didFailWithError:(NSError *)error {
    AX_LOG(AXLogLevelDebug, @"Smaato - didFailWithError");
}
- (void)interstitialDidClick:(SMAInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Smaato - interstitialDidClick");
}
- (void)interstitialWillAppear:(SMAInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Smaato - interstitialWillAppear");
}
- (void)interstitialWillDisappear:(SMAInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Smaato - interstitialWillDisappear");
}
- (void)interstitialDidDisappear:(SMAInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Smaato - interstitialDidDisappear");
    [self fireOnClosedInterstitialAd];
}
- (void)interstitialDidTTLExpire:(SMAInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Smaato - interstitialDidTTLExpire");
}

- (BOOL)canLoadOnly {
    return NO;
}
@end
