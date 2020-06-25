//
//  ManAdapter.h
//  AdMixerTest
//
//  Created by 원소정 on 2015. 12. 10..
//
// v0.2_20161128

#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"
#import "ADBanner.h"
#import "ManInterstitial.h"

@interface ManAdapter : AdMixerAdAdapter <ADBannerDelegate, ManInterstitialDelegate>
{
    NSString * _publisherID;
    NSString * _mediaID;
    NSString * _sectionID;
    ADBanner *_adView;
    ManInterstitial *_interstitialAd;
}

@end
