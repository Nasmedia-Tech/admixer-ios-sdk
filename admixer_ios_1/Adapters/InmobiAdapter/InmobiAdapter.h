//
//  InmobiAdapter.h
//  AdMixerTest
//
//  Created by Eric Yeohoon Yoon on 13. 1. 28..
//
// v7.0.4

#import <UIKit/UIKit.h>
#import "AdMixerAdAdapter.h"
#import <InMobiSDK/InMobiSDK.h>

@interface InmobiAdapter : AdMixerAdAdapter<IMBannerDelegate, IMInterstitialDelegate>
{
	IMBanner * _adView;
	IMInterstitial * _interstitialAd;
}

@end
