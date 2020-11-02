//
//  ManAdapter.h

#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"
#import "ManBanner.h"

@interface ManAdapter : AdMixerAdAdapter <ManBannerDelegate, ManInterstitialDelegate>
{
    ManBanner * _adView;
    ManBanner * _interstitialAd;
    
    NSString * _publisherID;
    NSString * _mediaID;
    NSString * _sectionID;
    
    NSString * _appID;
    NSString * _appName;
    NSString * _storeURL;
    NSString * _userAgeLevel;
}

@end
