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
#import "AdMixerCustomPopup.h"

@interface ViewController : UIViewController<AdMixerViewDelegate, AdMixerInterstitialDelegate, AdMixerCustomPopupDelegate> {
	
	AdMixerView * _adView;
	
}

- (IBAction)interstitialAdButtonAction:(id)sender;
- (IBAction)customPopupButtonAction:(id)sender;

@end
