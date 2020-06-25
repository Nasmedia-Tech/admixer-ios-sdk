//
//  AdamAdapter.h
//  AdMixerTest
//
//  Created by 정건국 on 12. 6. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//
// v2.4.0

#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"
#import "AdamAdView.h"
#import "AdamInterstitial.h"

@interface AdamAdapter : AdMixerAdAdapter<AdamAdViewDelegate, AdamInterstitialDelegate> {
	
	AdamAdView * _adView;
	AdamInterstitial * _interstitial;
}

@end
