//
//  CaulyAdapter.h
//  AdMixerTest
//
//  Created by Eric Yeohoon Yoon on 12. 9. 10..
//
// v3.1.0

#import "AdMixerAdAdapter.h"
#import "CaulyAdView.h"
#import "CaulyInterstitialAd.h"

@interface CaulyAdapter : AdMixerAdAdapter<CaulyAdViewDelegate, CaulyInterstitialAdDelegate>
{
    NSString * _appCode;
    CaulyAdView *_adView;
    CaulyInterstitialAd * _interstitialAd;
}

@end
