//
//  ViewController.h
//  AdMixerSample

#import <UIKit/UIKit.h>
#import "AdMixerView.h"
#import "AdMixerInterstitial.h"

@interface ViewController : UIViewController<AdMixerViewDelegate, AdMixerInterstitialDelegate> {
	
	AdMixerView * _adView1;
    AdMixerView * _adView2;
    AdMixerInterstitial * _interstitialAd;
}

- (IBAction)interstitialAdButtonAction:(id)sender;

@end
