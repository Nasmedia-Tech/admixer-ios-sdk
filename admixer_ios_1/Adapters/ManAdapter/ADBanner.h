//
//  ADBanner.h
//  ADBanner
//
//  Created by MezzoMedia on 13. 2. 1..
//  Copyright (c) 2013년 MezzoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManAdDefine.h"

@protocol ADBannerDelegate;

/* 배너 광고
 */
@interface ADBanner : UIView {
}

/* 전달받는 뷰컨트롤러의 객체
 */
@property (nonatomic, assign) id<ADBannerDelegate>delegate;

/* 광고를 사용하는 유저의 성별 정보.
 남성: @"1"
 여성: @"2"
 */
@property (nonatomic, copy) NSString *gender;

/* 광고를 사용하는 유저의 나이 정보.
 age : @"20"
 */
@property (nonatomic, copy) NSString *age;

/* 광고를 사용하는 유저의 매체ID
 userId : @"userId"
 */
@property (nonatomic, copy) NSString *userId;

/* 광고를 사용하는 유저의 매체ID
 userEmail : @"user@mezzomedia.co.kr"
 */
@property (nonatomic, copy) NSString *userEmail;

/* 광고를 사용하는 유저의 위치정보 제공 동의여부
 활용 미동의 : @"0"
 활용 동의 : @"1"
 */
@property (nonatomic, copy) NSString *userPositionAgree;


// MAN SDK 사이트에서 발급받은 publisher ID, media ID, section ID 입력
- (void)publisherID:(NSString*)publisherID mediaID:(NSString*)mediaID sectionID:(NSString*)sectionID;

// 리치미디어 사용 여부
-(void)useReachMedia:(BOOL)useFlag;

// 랜딩페이지 사파리로 띄울지 여부
-(void)useGotoSafari:(BOOL)useFlag;

/* 배너광고를 요청한다. (광고가 보이게 될 경우)
 */
- (void)startBannerAd;

/* 배너광고를 중지한다. (광고가 안보이게 될 경우)
 */
- (void)stopBannerAd;

/* SDK 버전 반환
 */
- (NSString*)getSdkVersion;

@end


/* 배너 프로토콜
 */
@protocol ADBannerDelegate <NSObject>

@optional

/* 배너 클릭에 따른 이벤트를 통보.
 */
- (void)adBannerClick:(ADBanner*)adBanner;

/* 광고 노출 준비가 되었음을 통보.
 */
- (void)adBannerParsingEnd:(ADBanner*)adBanner;

/* 광고 수신 성공
 chargedAdType 유료광고 인지 무료광고 인지 구별
 YES 이면 유료 광고, NO 이면 무료 광고.
 */
- (void)didReceiveAd:(ADBanner*)adBanner chargedAdType:(BOOL)bChargedAdType;

/* 배너 광고 수신 에러
 */
- (void)didFailReceiveAd:(ADBanner*)adBanner errorType:(NSInteger)errorType;

/* 배너 광고 클릭시 나타났던 랜딩 페이지가 닫힐 경우
 */
- (void)didCloseRandingPage:(ADBanner*)adBanner;

/* 배너 부정 재요청 (지정된 시간 이내에 재요청이 발생함)
 */
- (void)didBlockReloadAd:(ADBanner*)adBanner;

@end
