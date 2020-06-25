//
//  ManAdapter.m

#import "ManAdapter.h"
#import "AXLog.h"

@implementation ManAdapter

- (void)dealloc {
    _publisherID = nil;
    _mediaID = nil;
    _sectionID = nil;
    [_adView release];
    
    _appID = nil;
    _appName = nil;
    _storeURL = nil;
    _userAgeLevel = nil;
    
    [super dealloc];
}

- (NSString *)adapterName {
    return ADAPTER_MAN;
}

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig {
    self = [super initWithAdInfo:adInfo adConfig:adConfig];
    if(self) {
        _publisherID = [self.keyInfo objectForKey:@"a_publisher"];
        _mediaID = [self.keyInfo objectForKey:@"a_media"];
        _sectionID = [self.keyInfo objectForKey:@"a_section"];
        
        _appID = @"";
        _appName = @"";
        _storeURL = @"";
        NSDictionary *adapterInfo = [self.adInfo getAdapterAdInfo:[self adapterName]];
        if(adapterInfo != nil) {
            _appID = (NSString *)[adapterInfo objectForKey:@"appID"];
            _appName = (NSString *)[adapterInfo objectForKey:@"appName"];
            _storeURL = (NSString *)[adapterInfo objectForKey:@"storeURL"];
        }
        
        _userAgeLevel = ([AdMixer getTagForChildDirectedTreatment] > 0)? @"0":@"1";
    }
    return self;
}

- (BOOL)loadAd {
    if(_publisherID == nil || _mediaID == nil || _sectionID == nil) {
        if(_publisherID == nil)
            AX_LOG(AXLogLevelDebug, @"Man - publisher id is empty.");
        if(_mediaID == nil)
            AX_LOG(AXLogLevelDebug, @"Man - media id is empty.");
        if(_sectionID == nil)
            AX_LOG(AXLogLevelDebug, @"Man - section id is empty.");
        return NO;
    }
    
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            _adView = [[ManBanner alloc] initWithFrame:CGRectMake(0, 0, self.baseView.frame.size.width, self.baseView.frame.size.height)];
            _adView.bannerDelegate = self;
            [_adView userAgeLevel:_userAgeLevel];
            
            [_adView appID:_appID appName:_appName storeURL:_storeURL];
            [_adView publisherID:_publisherID mediaID:_mediaID sectionID:_sectionID x:0 y:0 width:self.baseView.frame.size.width height:self.baseView.frame.size.height type:@"0"];
            
        }else {
            CGRect deviceFrame = [[UIScreen mainScreen] bounds];
            _interstitialAd = [[ManBanner alloc] initWithFrame:CGRectMake(0, 0, deviceFrame.size.width, deviceFrame.size.height)];
            _interstitialAd.interDelegate = self;
            [_interstitialAd userAgeLevel:_userAgeLevel];
            
            [_interstitialAd appID:_appID appName:_appName storeURL:_storeURL];
            [_interstitialAd publisherID:_publisherID mediaID:_mediaID sectionID:_sectionID viewType:@"0"];
        
        }
    }else {
        return NO;
    }
    
    return YES;
}

- (void)start {
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            [_adView startBanner];
        } else {
            [_interstitialAd startInterstitial];
        }
    }
}

- (void)stop {
    if(_adView) {
        _adView.bannerDelegate = nil;
        [_adView stopBanner];
        _adView = nil;
    }
    
    if(_interstitialAd) {
        _interstitialAd.interDelegate = nil;
        [_interstitialAd stopInterstitial];
        _interstitialAd = nil;
    }
}

- (NSObject *)adObject {
    return _adView;
}

- (BOOL)canLoadOnly {
    return NO;
}

#pragma - ManBannerDelegate, ManInterstitialDelegate
- (void)didFailReceiveAd:(ManBanner *)adBanner errorType:(NSInteger)errorType {
    NSString *errorMsg = @"";
    switch (errorType) {
        case NewManAdSuccess :
            errorMsg = @"NewManAdSuccess (0)";
            break;
        case NewManAdClick :
            errorMsg = @"NewManAdClick (201)";
            break;
        case NewManAdClose :
            errorMsg = @"NewManAdClose (202)";
        default :
            errorMsg = [NSString stringWithFormat:@"Error (%ld)", (long)errorType];
            break;
    }
    AX_LOG(AXLogLevelDebug, @"MAN - didFailReceiveAd (%@)", errorMsg);
    
    // 광고로딩 성공시
    if(errorType == NewManAdSuccess) {
        if(self.isInterstitial == 0) {
            [self.baseView addSubview:_adView];
            [self fireSucceededToReceiveAd];
        }else {
            [self.baseView addSubview:_interstitialAd];
            [self fireSucceededToReceiveAd];
            [self fireDisplayedInterstitialAd];
        }
    }
    
    // 광고로딩 실패시
    if(errorType < 0 || errorType > 400) {
        [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:errorMsg]];
    }
    
    // 전면배너 광고닫기시
    if(self.isInterstitial == 1 && errorType == NewManAdClose) {
        [self fireOnClosedInterstitialAd];
    }
    
}

- (void)didBlockReloadAd:(ManBanner *)adBanner {
    
}

@end
