//
//  ViewController.m
//  AdMixerSample
//
//  Created by 정건국 on 12. 7. 1..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AdfitAdapter.h"
#import "AdmobAdapter.h"
#import "CaulyAdapter.h"
#import "TAdAdapter.h"
#import "InmobiAdapter.h"
#import "IAdAdapter.h"
#import "FacebookAdapter.h"
#import "ManAdapter.h"

#define ADMIXER_KEY     (@"YOUR_ADMIXER_KEY")

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[AdMixer registerUserAdAdapterNameWithAppCode:AMA_ADFIT cls:[AdfitAdapter class] appCode:@"adam_app_code"];
	[AdMixer registerUserAdAdapterNameWithAppCode:AMA_ADMOB cls:[AdmobAdapter class] appCode:@"admob_app_code"];
	[AdMixer registerUserAdAdapterNameWithAppCode:AMA_CAULY cls:[CaulyAdapter class] appCode:@"cauly_app_code"];
	[AdMixer registerUserAdAdapterNameWithAppCode:AMA_TAD cls:[TAdAdapter class] appCode:@"tad_app_code"];
	[AdMixer registerUserAdAdapterNameWithAppCode:AMA_INMOBI cls:[InmobiAdapter class] appCode:nil];
    [AdMixer registerUserAdAdapterNameWithAppCode:AMA_IAD cls:[IAdAdapter class] appCode:@"iad_app_code"];
    [AdMixer registerUserAdAdapterNameWithAppCode:AMA_FACEBOOK cls:[FacebookAdapter class] appCode:@"facebook_app_code"];
    [AdMixer registerUserAdAdapterNameWithAppCode:AMA_MAN cls:[ManAdapter class] appCode:@"man_app_code"];
    
    [GADMobileAds configureWithApplicationID:@"admob_app_id"];
    
    [IMSdk initWithAccountID:@"inmobi_account_id"];
    
    [ManAdapter setPublisherId:@"man_publisher_id"];
    [ManAdapter setMediaId:@"man_media_id"];
    [ManAdapter setBannerSectionId:@"man_banner_section_id"];
    [ManAdapter setInterstitialSectionId:@"man_interstitial_section_id"];
    
	[AdMixer setLogLevel:AXLogLevelDebug];
	
	AdMixerInfo * adInfo = [[[AdMixerInfo alloc] init] autorelease];
	adInfo.axKey = ADMIXER_KEY;
	adInfo.rtbVerticalAlign = AdMixerRTBVAlignCenter;
	
	_adView = [[AdMixerView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
	_adView.delegate = self;
	_adView.adSize = AXBannerSize_Default;
	[self.view addSubview:_adView];
	[_adView startWithAdInfo:adInfo baseViewController:self];
	
	[[AdMixerCustomPopup sharedInstance] startCustomPopupWithAxKey:adInfo.axKey viewController:self];
	[AdMixerCustomPopup sharedInstance].delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	
	[_adView stop];
	[_adView release];
	_adView = nil;
	
	[[AdMixerCustomPopup sharedInstance] stopCustomPopup];
}

- (IBAction)interstitialAdButtonAction:(id)sender {

	AdMixerInfo * adInfo = [[[AdMixerInfo alloc] init] autorelease];
	adInfo.axKey = ADMIXER_KEY;
	
	AdMixerInterstitial * interstitial = [[AdMixerInterstitial alloc] init];
	interstitial.delegate = self;
	[interstitial startWithAdInfo:adInfo baseViewController:self];
	[interstitial release];
}

- (IBAction)customPopupButtonAction:(id)sender {
	[[AdMixerCustomPopup sharedInstance] checkCustomPopupPage:@"test" viewController:self];
}

#pragma mark - AdMixerViewDelegate

- (void)onSucceededToReceiveAd:(AdMixerView *)adView {
	NSLog(@"onSucceededToReceiveAd");
}

- (void)onFailedToReceiveAd:(AdMixerView *)adView error:(AXError *)error {
	NSLog(@"onFailedToReceiveAd : %@", error.errorMsg);
}

#pragma mark - AdMixerInterstitialDelegate

- (void)onSucceededToReceiveInterstitalAd:(AdMixerInterstitial *)intersitial {
	NSLog(@"onSucceededToReceiveInterstitalAd");
}

- (void)onFailedToReceiveInterstitialAd:(AdMixerInterstitial *)intersitial error:(AXError *)error {
	NSLog(@"onFailedToReceiveInterstitialAd : %@", error.errorMsg);
}

- (void)onClosedInterstitialAd:(AdMixerInterstitial *)intersitial {
	NSLog(@"onClosedInterstitialAd");
}

#pragma mark - AdMixerCustomPopupDelegate

- (void)onStartedCustomPopup {
	NSLog(@"onStartedCustomPopup");
}

- (void)onWillShowCustomPopup:(NSString *)pageName {
	NSLog(@"onWillShowCustomPopup : %@", pageName);
}

- (void)onShowCustomPopup:(NSString *)pageName {
	NSLog(@"onShowCustomPopup : %@", pageName);
}

- (void)onWillCloseCustomPopup:(NSString *)pageName {
	NSLog(@"onWillCloseCustomPopup : %@", pageName);
}

- (void)onCloseCustomPopup:(NSString *)pageName {
	NSLog(@"onCloseCustomPopup : %@", pageName);
}

- (void)onHasNoCustomPopup {
	NSLog(@"onHasNoCustomPopup");
}


@end
