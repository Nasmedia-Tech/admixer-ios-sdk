//
//  FacebookAdapter.m

#import "FacebookAdapter.h"
#import "AXLog.h"

@implementation FacebookAdapter

- (void)dealloc {
    _placementID = nil;
    [_interstitialAd release];
    [_adView release];
    
    [super dealloc];
}

- (NSString *)adapterName {
    return ADAPTER_FACEBOOK;
}

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig {
    self = [super initWithAdInfo:adInfo adConfig:adConfig];
    if(self) {
        _placementID = [self.keyInfo objectForKey:@"placement_id"];
        
        BOOL isChildDirected = ([AdMixer getTagForChildDirectedTreatment] > 0)? YES : NO;
        [FBAdSettings setMixedAudience:isChildDirected];
    }
    return self;
}

- (BOOL)loadAd {
    if(_placementID == nil) {
        AX_LOG(AXLogLevelDebug, @"Facebook - placement id is empty.");
        return NO;
    }
    
    NSDictionary *adapterInfo = [self.adInfo getAdapterAdInfo:[self adapterName]];
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            FBAdSize fAdSize = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? kFBAdSizeHeight50Banner : kFBAdSizeHeight90Banner;
            if(adapterInfo != nil) {
                NSString * adSize = (NSString *)[adapterInfo objectForKey:@"adSize"];
                
                if([adSize isEqualToString:@"kFBAdSizeHeight50Banner"]) {
                    fAdSize = kFBAdSizeHeight50Banner;
                }else if([adSize isEqualToString:@"kFBAdSizeHeight90Banner"]) {
                    fAdSize = kFBAdSizeHeight90Banner;
                }else if([adSize isEqualToString:@"kFBAdSizeHeight250Rectangle"]) {
                    fAdSize = kFBAdSizeHeight250Rectangle;
                }
            }
            
            _adView = [[FBAdView alloc] initWithPlacementID:_placementID adSize:fAdSize rootViewController:self.baseViewController];
            _adView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            _adView.delegate = self;
            _adView.hidden = YES;
            CGRect frame = self.baseView.bounds;
            _adView.frame = frame;
            [self.baseView addSubview:_adView];
        }else {
            _interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:_placementID];
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
        [_interstitialAd release];
        _interstitialAd = nil;
    }
}

- (NSObject *)adObject {
    return _adView;
}

# pragma mark - FBAdViewDelegate

- (void)adViewDidLoad:(FBAdView *)adView {
    AX_LOG(AXLogLevelDebug, @"Facebook - adViewDidLoad");
    _adView.hidden = NO;
    [self fireSucceededToReceiveAd];
}

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error {
    AX_LOG(AXLogLevelDebug, @"Facebook - didFailWithError");
    [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:[error description]]];
}

- (void)adViewWillLogImpression:(FBAdView *)adView {
    AX_LOG(AXLogLevelDebug, @"Facebook - adViewWillLogImpression");
}

- (void)adViewDidClick:(FBAdView *)adView {
    AX_LOG(AXLogLevelDebug, @"Facebook - adViewDidClick");
}

- (void)adViewDidFinishHandlingClick:(FBAdView *)adView {
    AX_LOG(AXLogLevelDebug, @"Facebook - adViewDidFinishHandlingClick");
}

# pragma mark - FBInterstitialAdDelegate

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd {
    AX_LOG(AXLogLevelDebug, @"Facebook - interstitialAdDidLoad");
    [self fireSucceededToReceiveAd];
    
    if(!self.isLoadOnly) {
        [_interstitialAd showAdFromRootViewController:self.baseViewController];
        [self fireDisplayedInterstitialAd];
    } else
        self.hasInterstitialAd = YES;
}

- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    AX_LOG(AXLogLevelDebug, @"Facebook - didFailWithError");
    [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:[error description]]];
}

- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd {
}

- (void)interstitialAdWillClose:(FBInterstitialAd *)interstitialAd {
    AX_LOG(AXLogLevelDebug, @"Facebook - interstitialAdWillClose");
}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd {
    AX_LOG(AXLogLevelDebug, @"Facebook - interstitialAdDidClose");
    [self fireOnClosedInterstitialAd];
}

- (BOOL)canLoadOnly {
    return YES;
}

- (BOOL)displayInterstital {
    if(!self.hasInterstitialAd)
        return NO;
    self.hasInterstitialAd = NO;
    [_interstitialAd showAdFromRootViewController:self.baseViewController];
    [self fireDisplayedInterstitialAd];
    return YES;
}

@end
