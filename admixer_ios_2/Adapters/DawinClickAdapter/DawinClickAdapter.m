//
//  TAdAdapter.m
//  AdMixerTest
//
//  Created by 정건국 on 12. 6. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "DawinClickAdapter.h"
#import "AXLog.h"

@interface DawinClickAdapter(Private)

- (void)delayedFail;

@end

@implementation DawinClickAdapter

- (void)dealloc {
	[_adView release];
	[_tadCore release];
	
	[super dealloc];
}

- (NSString *)adapterName {
	return ADAPTER_DAWIN_CLICK;
}

- (id)initWithAdInfo:(AdMixerInfo *)adInfo adConfig:(NSDictionary *)adConfig {
	self = [super initWithAdInfo:adInfo adConfig:adConfig];
	if(self) {
        _clientId = [self.keyInfo objectForKey:@"client_id"];
	}
	return self;
}


- (BOOL)loadAd {
    if(_clientId == nil) {
        AX_LOG(AXLogLevelDebug, @"DawinClick - client id is empty.");
        return NO;
    }
    
	//if(self.isInterstitial == 1)
    //    return NO;
    
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            CGRect frame = self.baseView.bounds;
            _adView = [[UIView alloc] initWithFrame:frame];
            _adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _adView.backgroundColor = [UIColor clearColor];
            _adView.hidden = YES;
            [self.baseView addSubview:_adView];
        }
	} else {
        return NO;
	}
	return YES;
}

- (void)start {
    if([self.adformat isEqualToString:ADFORMAT_BANNER]) {
        if(self.isInterstitial == 0) {
            _tadCore = [[TadCore alloc] initWithSeedView:_adView delegate:self];
            [_tadCore setSlotNo:TadSlotBanner];
            [_tadCore setOffset:CGPointMake(0.0f, 0.0f)];
            [_tadCore setAutoRefresh:@"0"];
        } else {
            _tadCore = [[TadCore alloc] initWithSeedView:self.baseViewController.view delegate:self];
            [_tadCore setAutoCloseAfterLeaveApplication:NO];
            [_tadCore setSlotNo:TadSlotInterstitial];
        }
        
        [_tadCore setClientID:_clientId];
        [_tadCore setSeedViewController:self.baseViewController];
        [_tadCore setUseBackFillColor:YES];
        
        _tadCore.delegate = self;
        [_tadCore setLogMode:YES];
        [_tadCore getAdvertisement];
    }
}

- (void)stop {

	//[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	if(_tadCore) {
        if(_adView) {
            [_tadCore stopAd];
            [_tadCore destroyAd];
        }
        _tadCore.delegate = nil;
		//[_tadCore release];
		_tadCore = nil;
	}
	
    if(_adView) {
        [_adView removeFromSuperview];
        [_adView release];
        _adView = nil;
    }

}

- (NSObject *)adObject {
	return _adView;
}

- (BOOL)supportSuccessiveLoading {
    return YES;
}

- (BOOL)successiveLoadResult {
    return NO;
}

#pragma mark - TadDelegate

- (void)tadOnAdWillLoad:(TadCore *)tadCore {
}

- (void)tadOnAdLoaded:(TadCore *)tadCore {
    AX_LOG(AXLogLevelDebug, @"Tad - tadOnAdLoaded");
	if(!self.isResultFired) {
		_adView.hidden = NO;
		[self fireSucceededToReceiveAd];

		if(self.isInterstitial == 1) {
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
    AX_LOG(AXLogLevelDebug, @"DawinClick - tadOnAdClosed");
}

- (void)tadCore:(TadCore *)tadCore tadOnAdFailed:(TadErrorCode)errorCode {
    AX_LOG(AXLogLevelDebug, @"DawinClick - tadOnAdFailed");
    [self delayedFail:[NSNumber numberWithInt:(int)errorCode]];
	//[self performSelector:@selector(delayedFail:) withObject:[NSNumber numberWithInt:(int)errorCode] afterDelay:0.01];
}

- (void)tadOnAdDidDismissModal:(TadCore *)tadCore {
    if(self.isResultFired && self.isDisplayedInterstitial) {
        AX_LOG(AXLogLevelDebug, @"DawinClick - tadOnAdDidDismissModal");
        [self fireOnClosedInterstitialAd];
    }
}


#pragma mark - Private

- (void)delayedFail:(NSNumber *)code {
	TadErrorCode errorCode = (TadErrorCode)[code intValue];
	
	if(!self.isResultFired) {
		NSString * errorMsg;
		switch(errorCode) {
			case NO_AD:
				errorMsg = @"NO_AD";
				break;
            case MISSING_REQUIRED_PARAMETER_ERROR:
                errorMsg = @"MISSING_REQUIRED_PARAMETER_ERROR";
                break;
            case INVAILD_PARAMETER_ERROR:
                errorMsg = @"INVAILD_PARAMETER_ERROR";
                break;
            case UNSUPPORTED_DEVICE_ERROR:
                errorMsg = @"UNSUPPORTED_DEVICE_ERROR";
                break;
			case CLIENTID_DENIED_ERROR:
				errorMsg = @"CLIENTID_DENIED_ERROR";
				break;
			case INVAILD_SLOT_NUMBER:
				errorMsg = @"INVAILD_SLOT_NUMBER";
				break;
			case CONNECTION_ERROR:
				errorMsg = @"CONNECTION_ERROR";
				break;
			case NETWORK_ERROR:
				errorMsg = @"NETWORK_ERROR";
				break;
			case RECEIVE_AD_ERROR:
				errorMsg = @"RECEIVE_AD_ERROR";
				break;
			case LOAD_ERROR:
				errorMsg = @"LOAD_ERROR";
				break;
			case SHOW_ERROR:
				errorMsg = @"SHOW_ERROR";
				break;
			case INTERNAL_ERROR:
				errorMsg = @"INTERNAL_ERROR";
				break;
            case ALREADY_SHOWN:
                errorMsg = @"ALREADY_SHOWN";
                break;
            case NOT_INLINE_SHOW:
                errorMsg = @"NOT_INLINE_SHOW";
                break;
			default:
				errorMsg = @"Unknown Error";
				break;
		}
		[self fireFailedToReceiveAdWithError:[AXError errorWithCode:AX_ERR_ADAPTER message:errorMsg]];
	}
}

- (BOOL)canLoadOnly {
    return YES;
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
