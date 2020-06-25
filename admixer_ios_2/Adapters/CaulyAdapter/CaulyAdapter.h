//
//  CaulyAdapter.h

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
