//
//  FacebookAdapter.h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"

@import FBAudienceNetwork;

@interface FacebookAdapter : AdMixerAdAdapter <FBAdViewDelegate, FBInterstitialAdDelegate>
{
    NSString * _placementID;
    FBAdView *_adView;
    FBInterstitialAd *_interstitialAd;
}

@end
