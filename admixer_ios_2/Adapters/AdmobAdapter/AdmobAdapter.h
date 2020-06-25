//
//  AdmobAdapter.h

#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AdmobAdapter : AdMixerAdAdapter<GADBannerViewDelegate, GADInterstitialDelegate> {
	NSString * _adunitID;
    GADInterstitial * _interstitial;
    GADBannerView * _adView;
	GADRequestError * _error;
	
}

@end
