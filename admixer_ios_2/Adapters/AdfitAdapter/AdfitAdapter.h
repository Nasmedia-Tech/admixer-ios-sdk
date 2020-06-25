//
//  AdfitAdapter.h

#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"
#import <AdFitSDK/AdFitSDK-Swift.h>

@interface AdfitAdapter : AdMixerAdAdapter<AdFitBannerAdViewDelegate> {
    NSString * _clientId;
	AdFitBannerAdView * _adView;
}

@end
