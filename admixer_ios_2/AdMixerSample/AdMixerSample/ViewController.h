//
//  ViewController.h
//  AdMixerSample
//
//  Created by 정건국 on 12. 7. 1..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

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
