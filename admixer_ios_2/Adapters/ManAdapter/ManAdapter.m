//
//  ManAdapter.m
//  AdMixerTest
//
//  Created by 원소정 on 2015. 12. 10..
//
//

#import "ManAdapter.h"
#import "AXLog.h"

@implementation ManAdapter

- (void)dealloc {
    _publisherID = nil;
    _mediaID = nil;
    _sectionID = nil;
    [_adView release];
    [_interstitialAd release];
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
            _adView = [[ADBanner alloc] initWithFrame:CGRectMake(0, 0, self.baseView.frame.size.width, MAN_BANNER_AD_HEIGHT)];
            [_adView publisherID:_publisherID mediaID:_mediaID sectionID:_sectionID];
            _adView.delegate = self;
            _adView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            //광고 작동 세팅
            [_adView useReachMedia:NO];
            [_adView useGotoSafari:YES];
            
            //유저 정보 세팅
            _adView.userPositionAgree = @"0";
            
            _adView.hidden = YES;
            
            [self.baseView addSubview:_adView];
            
        }else {
            _interstitialAd = [ManInterstitial shareInstance];
            
            [_interstitialAd publisherID:_publisherID mediaID:_mediaID sectionID:_sectionID];
            _interstitialAd.delegate = self;
            _interstitialAd.userPositionAgree = @"0";
        }
    }else {
        return NO;
    }
    
    return YES;
}

- (void)start {
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            [_adView startBannerAd];
        } else {
            [_interstitialAd startInterstitial];
        }
    }
}

- (void)stop {
    if(_adView) {
        [_adView removeFromSuperview];
        [_adView stopBannerAd];
        _adView.delegate = nil;
        [_adView release];
        _adView = nil;
    }
    if(_interstitialAd) {
        _interstitialAd.delegate = nil;
        _interstitialAd = nil;
    }
}

- (NSObject *)adObject {
    return _adView;
}

- (BOOL)canLoadOnly {
    return NO;
}

#pragma ADBannerDelegate
- (void) adBannerClick:(ADBanner*)adBanner {
    // 배너 광고 클릭
    AX_LOG(AXLogLevelDebug, @"MAN - adBannerClick");
}
- (void) adBannerParsingEnd:(ADBanner*)adBanner {
    // 배너광고 파싱 완료
    AX_LOG(AXLogLevelDebug, @"MAN - adBannerParsingEnd");
}
-(void) didReceiveAd:(ADBanner*)adBanner chargedAdType:(BOOL)bChargedAdType {
    // 배너 광고의 수신 성공 및 유료/무료
    
    _adView.hidden = NO;
    
    NSString *chargedAdType = nil;
    if (bChargedAdType) {
        chargedAdType = @"유료";
    } else {
        chargedAdType = @"무료";
    }
    
    AX_LOG(AXLogLevelDebug, @"MAN - didReceiveAd (%@)", chargedAdType);
    [self fireSucceededToReceiveAd];
}
- (void) didFailReceiveAd:(ADBanner*)adBanner errorType:(NSInteger)errorType {
    // 배너 광고 수신 실패
    // errorTyped은 ManAdDefine.h 참조
    if(errorType != NewManAdSuccess) {
        AX_LOG(AXLogLevelDebug, @"MAN - didFailReceiveAd");
        
        NSString *errorMsg = @"";
        switch (errorType) {
            case NewManAdRequestError:
                errorMsg    = @"NewManAdRequestError (-1002)";
                break;
            case NewManAdParameterError:
                errorMsg    = @"NewManAdParameterError (-2002)";
                break;
            case NewManAdIDError:
                errorMsg    = @"NewManAdIDError (-3002)";
                break;
            case NewManAdNotError:
                errorMsg    = @"NewManAdNotError (-4002)";
                break;
            case NewManAdServerError:
                errorMsg    = @"NewManAdServerError (-5002)";
                break;
            case NewManAdNetworkError:
                errorMsg    = @"NewManAdNetworkError (-6002)";
                break;
            case NewManAdCreativeError:
                errorMsg    = @"NewManAdCreativeError (-9001)";
                break;
        }
        [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:errorMsg]];
    }
    
}
- (void) didCloseRandingPage:(ADBanner*)adBanner {
    // 배너광고 클릭시 나타났던 랜딩 페이지가 닫힐 경우 호출
    AX_LOG(AXLogLevelDebug, @"MAN - didCloseRandingPage");
}

#pragma mark ManInterstitialDelegate
-(void)didReceiveInterstitial {
    // 전면광고 수신 성공
    AX_LOG(AXLogLevelDebug, @"MAN - didReceiveInterstitial");
    [self fireSucceededToReceiveAd];
    [self fireDisplayedInterstitialAd];
}
-(void)didFailReceiveInterstitial :(NSInteger)errorType {
    // 전면광고 수신에러
    if(errorType != NewManAdSuccess) {
        AX_LOG(AXLogLevelDebug, @"MAN - didFailReceiveInterstitial");
        NSString *errorMsg = @"";
        switch (errorType) {
            case NewManAdRequestError:
                errorMsg    = @"NewManAdRequestError (-1002)";
                break;
            case NewManAdParameterError:
                errorMsg    = @"NewManAdParameterError (-2002)";
                break;
            case NewManAdIDError:
                errorMsg    = @"NewManAdIDError (-3002)";
                break;
            case NewManAdNotError:
                errorMsg    = @"NewManAdNotError (-4002)";
                break;
            case NewManAdServerError:
                errorMsg    = @"NewManAdServerError (-5002)";
                break;
            case NewManAdNetworkError:
                errorMsg    = @"NewManAdNetworkError (-6002)";
                break;
            case NewManAdCreativeError:
                errorMsg    = @"NewManAdCreativeError (-9001)";
                break;

        }
        [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:errorMsg]];
    }
}
-(void)didCloseInterstitial {
    // 전면광고 닫힘
    AX_LOG(AXLogLevelDebug, @"MAN - didCloseInterstitial");
    [self fireOnClosedInterstitialAd];
}

@end
