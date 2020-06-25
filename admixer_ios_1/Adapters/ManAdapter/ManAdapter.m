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

static NSString *_publisherId            = @"";
static NSString *_mediaId                = @"";
static NSString *_bannerSectionId        = @"";
static NSString *_interstitialSectionId  = @"";

// Man의 Publisher ID값을 세팅한다.
+ (void)setPublisherId:(NSString *)publisherId {
    _publisherId = publisherId;
}
// Man의 Media ID값을 세팅한다.
+ (void)setMediaId:(NSString *)mediaId {
    _mediaId = mediaId;
}
// Man의 띠배너 Section ID값을 세팅한다.
+ (void)setBannerSectionId:(NSString *)sectionId {
    _bannerSectionId = sectionId;
}
// Man의 전면배너 Section ID값을 세팅한다.
+ (void)setInterstitialSectionId:(NSString *)sectionId {
    _interstitialSectionId = sectionId;
}

- (void)dealloc {

    [_adView release];
    
    [super dealloc];
}

- (NSString *)adapterName {
    return AMA_MAN;
}

- (CGSize)adapterSize {
    return CGSizeMake(0, 50);
}

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig {
    self = [super initWithAdInfo:adInfo adConfig:adConfig];
    if(self) {
    }
    return self;
}

- (BOOL)loadAd {
    if(self.isBanner) {
        _adView = [[ADBanner alloc] initWithFrame:CGRectMake(0, 0, self.baseView.frame.size.width, MAN_BANNER_AD_HEIGHT)];
        AX_LOG(AXLogLevelDebug, @"publisher ID : %@, media ID : %@, section ID : %@", _publisherId, _mediaId, _bannerSectionId);
        [_adView publisherID:_publisherId mediaID:_mediaId sectionID:_bannerSectionId];
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
        
        [_interstitialAd publisherID:_publisherId mediaID:_mediaId sectionID:_interstitialSectionId];
        _interstitialAd.delegate = self;
        _interstitialAd.userPositionAgree = @"0";
    }
    
    return YES;
}

- (void)start {
    if(self.isBanner) {
        [_adView startBannerAd];
    } else {
        [_interstitialAd startInterstitial];
    }
}

- (void)stop {
    if(self.isBanner) {
        if(_adView) {
            [_adView removeFromSuperview];
            [_adView stopBannerAd];
            _adView.delegate = nil;
            [_adView release];
            _adView = nil;
        }
    } else {
        if(_interstitialAd) {
            _interstitialAd.delegate = nil;
            _interstitialAd = nil;
        }
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
        [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER_ERROR message:errorMsg]];
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
        [self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER_ERROR message:errorMsg]];
    }
}
-(void)didCloseInterstitial {
    // 전면광고 닫힘
    AX_LOG(AXLogLevelDebug, @"MAN - didCloseInterstitial");
    [self fireOnClosedInterstitialAd];
}

@end
