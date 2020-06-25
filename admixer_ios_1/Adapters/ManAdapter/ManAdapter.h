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
    ADBanner *_adView;
    ManInterstitial *_interstitialAd;
}

+ (void)setPublisherId:(NSString *)publisherId;
+ (void)setMediaId:(NSString *)mediaId;
+ (void)setBannerSectionId:(NSString *)sectionId;
+ (void)setInterstitialSectionId:(NSString *)sectionId;

@end
