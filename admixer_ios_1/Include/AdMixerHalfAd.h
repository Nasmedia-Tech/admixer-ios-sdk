//
//  AdMixerHalfAd.h
//  AdMixer
//
//  Created by 원소정 on 2017. 1. 16..
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdMixer.h"
#import "AdMixerInfo.h"

@class AdMixerHalfAd;

@protocol AdMixerHalfAdDelegate <NSObject>

- (void)onSucceededToReceiveHalfAd:(AdMixerHalfAd *)halfAd;
- (void)onFailedToReceiveHalfAd:(AdMixerHalfAd *)halfAd error:(AXError *)error;
- (void)onClosedHalfAd:(AdMixerHalfAd *)halfAd;

@optional
- (void)onDisplayedHalfAd:(AdMixerHalfAd *)halfAd;
- (void)onClickedHalfAdPopupButton:(AdMixerHalfAd *)halfad;
@end

@interface AdMixerHalfAd : NSObject

@property (nonatomic, assign) id<AdMixerHalfAdDelegate> delegate;
@property (nonatomic, assign) BOOL autoClose;

- (void)startWithAdInfo:(AdMixerInfo *)adInfo baseViewController:(UIViewController *)viewController;
- (void)loadWithAdInfo:(AdMixerInfo *)adInfo baseViewController:(UIViewController *)viewController;
- (BOOL)displayAd;
- (void)stop;
- (void)close;

@end
