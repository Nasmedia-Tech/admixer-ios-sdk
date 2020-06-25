//
//  TAdAdapter.m
//  AdMixerTest
//
//  Created by 정건국 on 12. 6. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "TAdAdapter.h"
#import "AXLog.h"

@interface TAdAdapter(Private)

- (void)delayedFail;

@end

@implementation TAdAdapter

- (void)dealloc {
	[_adView release];
	[_tadCore release];
	
	[super dealloc];
}

- (NSString *)adapterName {
	return AMA_TAD;
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

- (BOOL)supportSuccessiveLoading {
	return YES;
}

- (BOOL)successiveLoadResult {
	return NO;
}

- (BOOL)loadAd {
	if(self.isBanner) {
        CGRect frame = self.baseView.bounds;
        _adView = [[UIView alloc] initWithFrame:frame];
        _adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _adView.backgroundColor = [UIColor clearColor];
        _adView.hidden = YES;
        [self.baseView addSubview:_adView];
	} else {
	}
	return YES;
}

- (void)start {
	if(self.isBanner)
		_tadCore = [[TadCore alloc] initWithSeedView:_adView delegate:self];
	else
        _tadCore = [[TadCore alloc] initWithSeedView:self.baseViewController.view delegate:self];

	[_tadCore setClientID:self.appCode];

	if(self.isBanner) {
        _tadCore.seedController = self.baseViewController;
        _tadCore.seedViewController = self.baseViewController;
        _tadCore.seedView = _adView;
        [_tadCore setSlotNo:TadSlotBanner];
	} else {
        [_tadCore setSeedController:self.baseViewController];
        [_tadCore setSeedViewController:self.baseViewController];
        [_tadCore setSeedView:self.baseViewController.view];
        [_tadCore setAutoCloseAfterLeaveApplication:NO];
        [_tadCore setSlotNo:TadSlotInterstitial];
	}

    [_tadCore setUseBackFillColor:YES];
    [_tadCore setOffset:CGPointMake(0.0f, 0.0f)];

	_tadCore.delegate = self;
	[_tadCore setIsTest:self.adInfo.isTestMode];
	[_tadCore setOffset:CGPointMake(0, 0)];
    [_tadCore setAutoRefresh:@"0"];
	[_tadCore setLogMode:self.adInfo.isTestMode];
	[_tadCore getAdvertisement];

}

- (void)stop {

	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	if(_tadCore) {
        _tadCore.delegate = nil;
		[_tadCore destroyAd];
        [_tadCore stopAd];
		[_tadCore release];
		_tadCore = nil;
	}
	
	if(self.isBanner) {
		if(_adView) {
			[_adView removeFromSuperview];
			[_adView release];
			_adView = nil;
		}
	}
}

- (NSObject *)adObject {
	return _adView;
}


#pragma mark - TadDelegate

- (void)tadOnAdWillLoad:(TadCore *)tadCore {
}

- (void)tadOnAdLoaded:(TadCore *)tadCore {
    AX_LOG(AXLogLevelDebug, @"Tad - tadOnAdLoaded");
	if(!self.isResultFired) {
		_adView.hidden = NO;
		[self fireSucceededToReceiveAd];

		if(!self.isBanner) {
			if(!self.isLoadOnly) {
				[_tadCore showAd];

				[self fireDisplayedInterstitialAd];
			} else
				self.hasInterstitialAd = YES;
		}
	}
}

- (void)tadOnAdClicked:(TadCore *)tadCore {
}

- (void)tadOnAdTouchDown:(TadCore *)tadCore {
}

- (void)tadOnAdClosed:(TadCore *)tadCore {
    AX_LOG(AXLogLevelDebug, @"Tad - tadOnAdClosed");
}

- (void)tadCore:(TadCore *)tadCore tadOnAdFailed:(TadErrorCode)errorCode {
    AX_LOG(AXLogLevelDebug, @"Tad - tadOnAdFailed");
	[self performSelector:@selector(delayedFail:) withObject:[NSNumber numberWithInt:(int)errorCode] afterDelay:0.01];
}

- (void)tadOnAdDidDismissModal:(TadCore *)tadCore {
    AX_LOG(AXLogLevelDebug, @"Tad - tadOnAdDidDismissModal");
	[self fireOnClosedInterstitialAd];
}


#pragma mark - Private

- (void)delayedFail:(NSNumber *)code {
	TadErrorCode errorCode = (TadErrorCode)[code intValue];
	
	if(!self.isResultFired) {
		NSString * errorMsg;
		switch(errorCode) {
			case NO_AD:
				errorMsg = @"<Tad Error> 광고 서버에서 송출 가능한 광고가 없는 경우 10초후에 재요청을 합니다.";
				break;
			case CLIENTID_DENIED_ERROR:
				errorMsg = @"<Tad Error> 지정한 Client ID가 유효하지 않은 경우";
				break;
			case INVAILD_SLOT_NUMBER:
				errorMsg = @"<Tad Error> 지정한 슬롯 번호가 유효하지 않은 경우";
				break;
			case CONNECTION_ERROR:
				errorMsg = @"<Tad Error> 네트워크 연결이 가능하지 않은 경우";
				break;
			case NETWORK_ERROR:
				errorMsg = @"<Tad Error> 광고의 수신 및 로딩 과정에서 네트워크 오류가 발생한 경우";
				break;
			case RECEIVE_AD_ERROR:
				errorMsg = @"Tad Error 광고를 수신하는 과정에서 에러가 발생한 경우";
				break;
			case LOAD_ERROR:
				errorMsg = @"<Tad Error> SDK에서 허용하는 시간 내에 광고를 재요청한 경우";
				break;
			case SHOW_ERROR:
				errorMsg = @"<Tad Error> 노출할 광고가 없는 경우";
				break;
			case INTERNAL_ERROR:
				errorMsg = @"<Tad Error> 광고의 수신 및 로딩 과정에서 내부적으로 오류가 발생한 경우";
				break;
			default:
				errorMsg = @"<Tad Error> Unknown Error";
				break;
		}
		[self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER_ERROR message:errorMsg]];
	}
}

- (BOOL)canLoadOnly {
	if(!self.isBanner)
		return YES;
	return NO;
}

- (BOOL)canCloseInterstitial {
    return YES;
}

- (BOOL)displayInterstital {
	if(!self.hasInterstitialAd)
		return NO;
	
	self.hasInterstitialAd = NO;
    [_tadCore showAd];
	[self fireDisplayedInterstitialAd];
	return YES;
}


@end
