//
//  MopubAdapter.h

#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"

@import MoPubSDKFramework;

@interface MopubAdapter : AdMixerAdAdapter <MPAdViewDelegate, MPInterstitialAdControllerDelegate> {
    NSString * _adunitID;
    MPAdView * _adView;
    MPInterstitialAdController * _interstitialAd;
}

@end
