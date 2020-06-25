//
//  InmobiAdapter.m
//  AdMixerTest
//
//  Created by Eric Yeohoon Yoon on 13. 1. 28..
//
//

#import "InmobiAdapter.h"
#import "AXLog.h"

@implementation InmobiAdapter

- (void)dealloc {
    if(self.isBanner) {
        if(_adView)
            [_adView release];
        _adView = nil;
    }else {
        if( _interstitialAd)
            [_interstitialAd release];
        _interstitialAd = nil;
    }
    
	[super dealloc];
}

- (NSString *)adapterName {
	return AMA_INMOBI;
}

- (CGSize)adapterSize {
	return CGSizeMake(320, 50);
}

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig {
	self = [super initWithAdInfo:adInfo adConfig:adConfig];
	if(self) {
        [IMSdk setLogLevel:kIMSDKLogLevelDebug];
	}
	return self;
}

- (BOOL)loadAd {
	
	if(self.isBanner) {
        AXBannerSize adSize = (AXBannerSize)[[self.adConfig objectForKey:@"adSize"] intValue];
        
        switch (adSize) {
            case AXBannerSize_Default:
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    _adView = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, 320, 50) placementId:[self.appCode longLongValue]];
                else
                    _adView = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, 468, 60) placementId:[self.appCode longLongValue]];
                break;
            case AXBannerSize_IPhone:
                _adView = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, 320, 50) placementId:[self.appCode longLongValue]];
                break;
            case AXBannerSize_IPad_Small:
                _adView = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, 468, 60) placementId:[self.appCode longLongValue]];
                break;
            case AXBannerSize_IPad_Large:
                _adView = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, 728, 90) placementId:[self.appCode longLongValue]];
                break;
            default:
                _adView = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, 320, 50) placementId:[self.appCode longLongValue]];
                break;
        }
        
        _adView.delegate = self;
        [_adView shouldAutoRefresh:NO];
        
        _adView.hidden = YES;
        [self.baseView addSubview:_adView];
        CGPoint center = CGPointMake(self.baseView.center.x, _adView.center.y);
        _adView.center = center;
	} else {
        _interstitialAd = [[IMInterstitial alloc] initWithPlacementId:[self.appCode longLongValue]];
        _interstitialAd.delegate = self;
	}

	return YES;
}

- (void)start {
	if(self.isBanner) {
        [_adView load];
	} else {
        [_interstitialAd load];
	}
}

- (void)stop {
	if(self.isBanner) {
        if(_adView) {
            [_adView setDelegate:nil];
            [_adView setHidden:YES];
            [_adView removeFromSuperview];
            [_adView release];
            _adView = nil;
        }
	} else {
        if(_interstitialAd) {
            _interstitialAd.delegate = nil;
            [_interstitialAd release];
            _interstitialAd = nil;
        }
	}
}

- (NSObject *)adObject {
	return _adView;
}

#pragma mark - IMBannerDelegate

/*Indicates that the banner has received an ad. */
- (void)bannerDidFinishLoading:(IMBanner *)banner {
    AX_LOG(AXLogLevelDebug, @"Inmobi - bannerDidFinishLoading");
    _adView.hidden = NO;
    [self fireSucceededToReceiveAd];
}

/* Indicates that the banner has failed to receive an ad */
- (void)banner:(IMBanner *)banner didFailToLoadWithError:(IMRequestStatus *)error {
    AX_LOG(AXLogLevelDebug, @"Inmobi - didFailToLoadWithError");
    [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER_ERROR message:[error localizedDescription]]];
}

/* Indicates that the banner is going to present a screen. */
- (void)bannerWillPresentScreen:(IMBanner *)banner {
    AX_LOG(AXLogLevelDebug, @"Inmobi - bannerWillPresentScreen");
    if(self.isBanner)
        [self firePopUpScreen];
}

/* Indicates that the banner has presented a screen. */
- (void)bannerDidPresentScreen:(IMBanner *)banner {
    AX_LOG(AXLogLevelDebug, @"Inmobi - bannerDidPresentScreen");
}

/* Indicates that the banner is going to dismiss the presented screen. */
- (void)bannerWillDismissScreen:(IMBanner *)banner {
    AX_LOG(AXLogLevelDebug, @"Inmobi - bannerWillDismissScreen");
}

/* Indicates that the banner has dismissed a screen. */
- (void)bannerDidDismissScreen:(IMBanner *)banner {
    AX_LOG(AXLogLevelDebug, @"Inmobi - bannerDidDismissScreen");
    if(self.isBanner)
        [self fireDismissScreen];
}

/* Indicates that the user will leave the app. */
- (void)userWillLeaveApplicationFromBanner:(IMBanner *)banner {
    AX_LOG(AXLogLevelDebug, @"Inmobi - userWillLeaveApplicationFromBanner");
}

/* banner:didInteractWithParams: Indicates that the interstitial was interacted with. */
-(void)banner:(IMBanner *)banner didInteractWithParams:(NSDictionary *)params{
    AX_LOG(AXLogLevelDebug, @"Inmobi - bannerdidInteractWithParams");
}


-(void)bannerDidInteract:(IMBanner *)banner withParams:(NSDictionary *)dictionary {
    AX_LOG(AXLogLevelDebug, @"Inmobi - bannerDidInteract");
}

#pragma mark - IMInterstitialDelegate
/**
 * Notifies the delegate that the ad server has returned an ad. Assets are not yet available.
 * Please use interstitialDidFinishLoading: to receive a callback when assets are also available.
 */
-(void)interstitialDidReceiveAd:(IMInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Inmobi - interstitialDidReceiveAd");
}
/*Indicates that the interstitial has received an ad. */
- (void)interstitialDidFinishLoading:(IMInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Inmobi - interstitialDidFinishLoading");
    [self fireSucceededToReceiveAd];
    
    if(!self.isLoadOnly) {
        [_interstitialAd showFromViewController:self.baseViewController];
        [self fireDisplayedInterstitialAd];
    } else
        self.hasInterstitialAd = YES;
}

/* Indicates that the interstitial has failed to receive an ad */
- (void)interstitial:(IMInterstitial *)interstitial didFailToLoadWithError:(IMRequestStatus *)error {
    AX_LOG(AXLogLevelDebug, @"Inmobi - didFailToLoadWithError");
    [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER_ERROR message:[error localizedDescription]]];
}

/* Indicates that the interstitial has failed to present itself. */
- (void)interstitial:(IMInterstitial *)interstitial didFailToPresentWithError:(IMRequestStatus *)error {
    AX_LOG(AXLogLevelDebug, @"Inmobi - didFailToPresentWithError");
    [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER_ERROR message:[error localizedDescription]]];
}

/* indicates that the interstitial is going to present itself. */
- (void)interstitialWillPresent:(IMInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Inmobi - interstitialWillPresent");
}

/* Indicates that the interstitial has presented itself */
- (void)interstitialDidPresent:(IMInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Inmobi - interstitialDidPresent");
}

/* Indicates that the interstitial is going to dismiss itself. */
- (void)interstitialWillDismiss:(IMInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Inmobi - interstitialWillDismiss");
}

/* Indicates that the interstitial has dismissed itself. */
- (void)interstitialDidDismiss:(IMInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Inmobi - interstitialDidDismiss");
    [self fireOnClosedInterstitialAd];
}

/* Indicates that the user will leave the app. */
- (void)userWillLeaveApplicationFromInterstitial:(IMInterstitial *)interstitial {
    AX_LOG(AXLogLevelDebug, @"Inmobi - userWillLeaveApplicationFromInterstitial");
}

/* Indicates that a reward action is completed */
- (void)interstitial:(IMInterstitial *)interstitial rewardActionCompletedWithRewards:(NSDictionary *)rewards {
    AX_LOG(AXLogLevelDebug, @"Inmobi - rewardActionCompletedWithRewards");
}
/* interstitial:didInteractWithParams: Indicates that the interstitial was interacted with. */
- (void)interstitial:(IMInterstitial *)interstitial didInteractWithParams:(NSDictionary *)params {
    AX_LOG(AXLogLevelDebug, @"Inmobi - didInteractWithParams");
}

- (BOOL)canLoadOnly {
	if(!self.isBanner)
		return YES;
	return NO;
}

- (BOOL)displayInterstital {
	if(!self.hasInterstitialAd)
		return NO;
	self.hasInterstitialAd = NO;
	
    [_interstitialAd showFromViewController:self.baseViewController];
	[self fireDisplayedInterstitialAd];
	return YES;
}


@end
