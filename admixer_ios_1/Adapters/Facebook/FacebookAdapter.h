//
//  FacebookAdapter.h
//  AdMixerTest
//
//  Created by 원소정 on 2015. 1. 28..
//
// v4.21.0

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"

@import FBAudienceNetwork;

@interface FacebookAdapter : AdMixerAdAdapter <FBAdViewDelegate, FBInterstitialAdDelegate>
{
    FBAdView *_adView;
    FBInterstitialAd *_interstitialAd;
}

@end
