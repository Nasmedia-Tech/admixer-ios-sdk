//
//  AdfitAdapter.h
//
//  Created by 원소정 on 18. 2. 19..
//
// v3.0.0

#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"
#import <AdFitSDK/AdFitSDK-Swift.h>

@interface AdfitAdapter : AdMixerAdAdapter<AdFitBannerAdViewDelegate> {
	AdFitBannerAdView * _adView;
}

@end
