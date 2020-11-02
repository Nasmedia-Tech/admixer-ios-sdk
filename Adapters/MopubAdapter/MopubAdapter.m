//
//  MopubAdapter.m

#import "MopubAdapter.h"
#import "AXLog.h"

@implementation MopubAdapter

- (void)dealloc {
    _adunitID = nil;
    [_interstitialAd release];
    [_adView release];
    
    [super dealloc];
}

- (NSString *)adapterName {
    return ADAPTER_MOPUB;
}

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig {
    self = [super initWithAdInfo:adInfo adConfig:adConfig];
    if(self) {
        _adunitID = [self.keyInfo objectForKey:@"adunit_id"];
    }
    return self;
}

- (BOOL)loadAd {
    if(_adunitID == nil) {
        AX_LOG(AXLogLevelDebug, @"Mopub - adunit id is empty.");
        return NO;
    }
    
    NSDictionary *adapterInfo = [self.adInfo getAdapterAdInfo:[self adapterName]];
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
             CGSize kMPAdSize = kMPPresetMaxAdSizeMatchFrame;
            if(adapterInfo != nil) {
                NSString * adSize = (NSString *)[adapterInfo objectForKey:@"adSize"];
                
                if([adSize isEqualToString:@"kMPPresetMaxAdSizeMatchFrame"]) {
                    kMPAdSize = kMPPresetMaxAdSizeMatchFrame;
                }else if([adSize isEqualToString:@"kMPPresetMaxAdSize50Height"]) {
                    kMPAdSize = kMPPresetMaxAdSize50Height;
                }else if([adSize isEqualToString:@"kMPPresetMaxAdSize90Height"]) {
                    kMPAdSize = kMPPresetMaxAdSize90Height;
                }else if([adSize isEqualToString:@"kMPPresetMaxAdSize250Height"]) {
                    kMPAdSize = kMPPresetMaxAdSize250Height;
                }else if([adSize isEqualToString:@"kMPPresetMaxAdSize280Height"]) {
                    kMPAdSize = kMPPresetMaxAdSize280Height;
                }
            }
            
            _adView = [[MPAdView alloc] initWithAdUnitId:_adunitID];
            _adView.delegate = self;
            _adView.frame = self.baseView.bounds;
            _adView.hidden = YES;
            _adView.maxAdSize = kMPAdSize;
            [self.baseView addSubview:_adView];
        
        }else {
            _interstitialAd = [MPInterstitialAdController interstitialAdControllerForAdUnitId:_adunitID];
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
            [_adView loadAd];
        } else {
            [_interstitialAd loadAd];
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
        [MPInterstitialAdController removeSharedInterstitialAdController:_interstitialAd];
        _interstitialAd = nil;
    }
}

- (NSObject *)adObject {
    return _adView;
}

# pragma mark - MPAdViewDelegate
- (UIViewController *)viewControllerForPresentingModalView {
    return self.baseViewController;
}
- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize {
    AX_LOG(AXLogLevelDebug, @"Mopub - adViewDidLoadAd");
    _adView.hidden = NO;
    [self fireSucceededToReceiveAd];
}
- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error {
    AX_LOG(AXLogLevelDebug, @"Mopub - didFailToLoadAdWithError");
    [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:[error description]]];
}
- (void)willPresentModalViewForAd:(MPAdView *)view {
    AX_LOG(AXLogLevelDebug, @"Mopub - willPresentModalViewForAd");
}
- (void)didDismissModalViewForAd:(MPAdView *)view {
    AX_LOG(AXLogLevelDebug, @"Mopub - didDismissModalViewForAd");
}
- (void)willLeaveApplicationFromAd:(MPAdView *)view {
    AX_LOG(AXLogLevelDebug, @"Mopub - willLeaveApplicationFromAd");
}

# pragma mark - MPInterstitialAdControllerDelegate
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Mopub - interstitialDidLoadAd");
    [self fireSucceededToReceiveAd];
    self.hasInterstitialAd = YES;
    
    if(!self.isLoadOnly) {
        [self displayInterstital];
    }
}
- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
                          withError:(NSError *)error {
    AX_LOG(AXLogLevelDebug, @"Mopub - interstitialDidFailToLoadAd");
    [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:[error description]]];
}
- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Mopub - interstitialWillAppear");
}
- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Mopub - interstitialDidDisappear");
    [self fireOnClosedInterstitialAd];
}
- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Mopub - interstitialDidExpire");
}
- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Mopub - interstitialDidReceiveTapEvent");
}
- (void)mopubAd:(id<MPMoPubAd>)ad didTrackImpressionWithImpressionData:(MPImpressionData * _Nullable)impressionData {
    AX_LOG(AXLogLevelDebug, @"Mopub - didTrackImpressionWithImpressionData");
}

- (BOOL)canLoadOnly {
    return YES;
}
- (BOOL)displayInterstital {
    if(!self.hasInterstitialAd)
        return NO;

    self.hasInterstitialAd = NO;
    if(_interstitialAd.ready) {
        [_interstitialAd showFromViewController:self.baseViewController];
        [self fireDisplayedInterstitialAd];
        return YES;
    }else {
        return NO;
    }
}
@end
