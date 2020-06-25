//
//  AdMixerInfo.h
//  AdMixer
//
//  Created by admixer on 12. 6. 25..
//  Copyright (c) 2012년 nasmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdMixerInterstitialPopupOption.h"

typedef enum {
    AdMixerInterstitialBasicType,
    AdMixerInterstitialPopupType
} AdMixerInterstitialAdType;

@interface AdMixerInfo : NSObject

@property (nonatomic, retain) NSString * adunitID;
@property (nonatomic, retain, readonly) NSMutableDictionary * adapterAdInfo;
@property (nonatomic, assign) int maxRetryCountInSlot;

/** for interstitial only **/
@property (nonatomic, assign) int interstitialTimeout;
@property (nonatomic, readonly) AdMixerInterstitialAdType interstitialAdType;
@property (nonatomic, retain, readonly) AdMixerInterstitialPopupOption *interstitialPopupOption;
@property (nonatomic, assign) BOOL backgroundAlpha;
- (void)setInterstitialAdType:(AdMixerInterstitialAdType)adType withInterstitialPopupOption:(AdMixerInterstitialPopupOption *)adOption;

/** Adapter adInfo Setting **/
- (void)setAdapterAdInfo:(NSString *)adapterName infoKey:(NSString *)infoKey withIntInfoValue:(int)infoValue;
- (void)setAdapterAdInfo:(NSString *)adapterName infoKey:(NSString *)infoKey withBoolInfoValue:(BOOL)infoValue;
- (void)setAdapterAdInfo:(NSString *)adapterName infoKey:(NSString *)infoKey withStringInfoValue:(NSString *)infoValue;
- (void)setAdapterAdInfo:(NSString *)adapterName infoKey:(NSString *)infoKey withStringInfoValue:(NSString *)infoValue withStringInfoValue2:(NSString *)infoValue2;
- (NSDictionary *)getAdapterAdInfo:(NSString *)adapterName;

@end
