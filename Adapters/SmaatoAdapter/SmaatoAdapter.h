//
//  SmaatoAdapter.h

#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"

@import SmaatoSDKBanner;
@import SmaatoSDKInterstitial;

@interface SmaatoAdapter : AdMixerAdAdapter <SMABannerViewDelegate, SMAInterstitialDelegate> {
    NSString * _adspaceID;
    SMABannerView * _adView;
    SMAInterstitial * _interstitialAd;
}

@end
