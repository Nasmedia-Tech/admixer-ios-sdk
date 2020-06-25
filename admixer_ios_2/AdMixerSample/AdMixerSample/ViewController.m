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
#import "DawinClickAdapter.h"
#import "FacebookAdapter.h"
#import "ManAdapter.h"

#define MEDIA_KEY                       (@"your_media_key")
#define ADUNIT_ID_320X50                (@"your_adunit_id")
#define ADUNIT_ID_300X250               (@"your_adunit_id")
#define ADUNIT_ID_320X480_FULLSCREEN    (@"your_adunit_id")

@interface ViewController() {
    NSArray *adunits;
    IBOutlet UIButton *btnInterstitialAd;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    btnInterstitialAd.center = CGPointMake(self.view.center.x, btnInterstitialAd.center.y);
    
    // 로그레벨 설정
    [AdMixer setLogLevel:AXLogLevelDebug];
    
    // 필요한 adapter 등록
    [AdMixer registerAdapter:ADAPTER_ADFIT cls:[AdfitAdapter class]];
    [AdMixer registerAdapter:ADAPTER_ADMOB cls:[AdmobAdapter class]];
    [AdMixer registerAdapter:ADAPTER_CAULY cls:[CaulyAdapter class]];
    [AdMixer registerAdapter:ADAPTER_DAWIN_CLICK cls:[DawinClickAdapter class]];
    [AdMixer registerAdapter:ADAPTER_FACEBOOK cls:[FacebookAdapter class]];
    [AdMixer registerAdapter:ADAPTER_MAN cls:[ManAdapter class]];
	
    // AdMixer 초기화를 위해 반드시 광고호출 전에 앱에서 1회 호출해주셔야 합니다.
    // adunits 파라미터는 앱 내에서 사용할 모든 adunit_id를 배열형태로 넘겨주셔야 합니다.
    if(adunits == nil)
        adunits = [[NSArray alloc] initWithObjects:ADUNIT_ID_320X50, ADUNIT_ID_300X250, ADUNIT_ID_320X480_FULLSCREEN, nil];
    [AdMixer initWithMediaKey:MEDIA_KEY adunits:adunits];
    
    // COPPA(아동보호법) 관련 항목 설정값 - 선택사항
    [AdMixer setTagForChildDirectedTreatment:AX_TAG_FOR_CHILD_DIRECTED_TREATMENT_TRUE];

    // Admob 적용 시에 SDK 초기화 호출이 필요
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    
    // 일반배너 호출
    [self loadAdView];
}

- (void)loadAdView {
    /************************/
    /*** 일반배너 320*50 설정 ***/
    /************************/
    
    AdMixerInfo * adInfo1 = [[[AdMixerInfo alloc] init] autorelease];
    adInfo1.adunitID = ADUNIT_ID_320X50; // 해당 영역의 adunit id값을 설정
    [adInfo1 setMaxRetryCountInSlot:-1];
    
    // Admob AdInfo
    [adInfo1 setAdapterAdInfo:ADAPTER_ADMOB infoKey:@"adSize" withStringInfoValue:@"kGADAdSizeSmartBannerPortrait"];
    // Cauly AdInfo
    [adInfo1 setAdapterAdInfo:ADAPTER_CAULY infoKey:@"adSize" withStringInfoValue:@"CaulyAdSize_IPhone"];
    // Facebook AdInfo
    [adInfo1 setAdapterAdInfo:ADAPTER_FACEBOOK infoKey:@"adSize" withStringInfoValue:@"kFBAdSizeHeight50Banner"];
    
    _adView1 = [[AdMixerView alloc] initWithFrame:CGRectMake(0, 130, self.view.bounds.size.width, 50)];
    _adView1.center = CGPointMake(self.view.center.x, _adView1.center.y);
    _adView1.backgroundColor = [UIColor blackColor];
    _adView1.delegate = self;
    [self.view addSubview:_adView1];
    [_adView1 startWithAdInfo:adInfo1 baseViewController:self];
    
    /**************************/
    /*** 일반배너 300*250 설정 ***/
    /**************************/
    
    AdMixerInfo * adInfo2 = [[[AdMixerInfo alloc] init] autorelease];
    adInfo2.adunitID = ADUNIT_ID_300X250; // 해당 영역의 adunit id값을 설정
    [adInfo2 setMaxRetryCountInSlot:-1];
    
    // Admob AdInfo
    [adInfo2 setAdapterAdInfo:ADAPTER_ADMOB infoKey:@"adSize" withStringInfoValue:@"kGADAdSizeMediumRectangle"];
    
    _adView2 = [[AdMixerView alloc] initWithFrame:CGRectMake(0, 200, 300, 250)];
    _adView2.center = CGPointMake(self.view.center.x, _adView2.center.y);
    _adView2.backgroundColor = [UIColor blackColor];
    _adView2.delegate = self;
    [self.view addSubview:_adView2];
    [_adView2 startWithAdInfo:adInfo2 baseViewController:self];
    
}

- (IBAction)interstitialAdButtonAction:(id)sender {
    /**************************/
    /*** 전면배너 320*480 설정 ***/
    /**************************/
    
    if(_interstitialAd != nil) // 전면광고는 1회성 객체
        return;
    
	AdMixerInfo * adInfo = [[[AdMixerInfo alloc] init] autorelease];
    adInfo.adunitID = ADUNIT_ID_320X480_FULLSCREEN;
    
    /* 이 주석을 제거하시면 admixer 전면광고가 팝업형으로 노출됩니다. (admixer 네트워크만 사용가능)
    AdMixerInterstitialPopupOption *option = [[AdMixerInterstitialPopupOption alloc] init];
    [option setButton:@"광고를 그만볼래요" withButtonColor:[UIColor blackColor]];
    [option setButtonFrameColor:[UIColor grayColor]];
    [adInfo setInterstitialAdType:AdMixerInterstitialPopupType withInterstitialPopupOption:option];
    */
     
    _interstitialAd = [[AdMixerInterstitial alloc] init];
	_interstitialAd.delegate = self;
	[_interstitialAd startWithAdInfo:adInfo baseViewController:self];
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
    if(_interstitialAd != nil) {
        [_interstitialAd stop];
        _interstitialAd = nil;
    }
}

- (void)onClosedInterstitialAd:(AdMixerInterstitial *)intersitial {
	NSLog(@"onClosedInterstitialAd");
    if(_interstitialAd != nil) {
        [_interstitialAd stop];
        _interstitialAd = nil;
    }
}

- (void)dealloc {
    
    [btnInterstitialAd release];
    
    if(_adView1 != nil) {
        [_adView1 stop];
        [_adView1 removeFromSuperview];
        _adView1 = nil;
    }
    
    if(_adView2 != nil) {
        [_adView2 stop];
        [_adView2 removeFromSuperview];
        _adView2 = nil;
    }
    
    if(_interstitialAd != nil) {
        [_interstitialAd stop];
        _interstitialAd = nil;
    }
    
    [super dealloc];
}

@end
