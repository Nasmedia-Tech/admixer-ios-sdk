//
//  ManBreakAdInterstitial.h
//  ManAdView
//
//  Created by 배 선기 on 2015. 11. 2..
//  Copyright © 2015년 MezzoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManAdDefine.h"

@protocol ManBreakAdInterstitialDelegate;

@interface ManBreakAdInterstitial : UIView {
}

/* 전달받는 뷰컨트롤러의 객체
 */
@property (nonatomic, assign) id<ManBreakAdInterstitialDelegate>delegate;

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


/* 디폴트 이미지
 */
@property (nonatomic, retain) UIImage *defaultImage;

/* 디폴트 클릭
 */
@property (nonatomic, copy) NSString *defaultClickUrl;


/* 광고가 사라질때 애니메이션을 보여주며 사라질지 결정.
 bShowEndAnimation  기본값은 "NO"
 */
@property (nonatomic, assign) BOOL bShowEndAnimation;

/* 광고 버튼을 보여줄지 결정
 bShowButtons  기본값은 "YES"
 */
@property (nonatomic, assign) BOOL bShowButtons;

/* 클로즈 버튼을 보여줄지 여부 결정
 */
@property (nonatomic, assign) BOOL bShowCloseButtons;


// MAN SDK 사이트에서 발급받은 appID, windowID 입력
//- (void)applicationID:(NSString*)manAppID adWindowID:(NSString*)adWindowID;

// MAN SDK 사이트에서 발급받은 publisher ID, media ID, section ID 입력
- (void)publisherID:(NSString*)publisherID mediaID:(NSString*)mediaID sectionID:(NSString*)sectionID;


// 리치미디어 사용 여부
-(void)useReachMedia:(BOOL)useFlag;

// 랜딩페이지 사파리로 띄울지 여부
-(void)useGotoSafari:(BOOL)useFlag;

/* 중간광고를 시작한다
 */
- (void)startBreakAd;

// XML 파싱 응답.
- (void)responseBreakAdInfo:(NSMutableDictionary*)parseInfoDict;

/* SDK 버전 반환
 */
- (NSString*)getSdkVersion;


@end


@protocol ManBreakAdInterstitialDelegate <NSObject>

@optional
/* 광고창이 사라질때 호출된다.
 bLeftSwipe : 왼쪽으로 손동작인지, 오른쪽으로 손동작인지 구별한다.
 */
- (void)didSwipeBreakAd:(BOOL)bLeftSwipe;

/* 닫기 버튼 클릭했을때 호출된다
 */
- (void)didCloseBreakAd;

/* 웹광고 클릭 했을때 호출 된다
 */
- (void)didClickBreakAd;

/* 광고 정보 요청이 실패 했을때 호출된다.
 */
- (void)didFailBreakAd;

/* 광고 웹페이지 로딩이 완료 되었을때 호출된다
 */
- (void)didWebLoadBreakAd;

/* 광고 웹페이지 로딩이 실패 했을때 호출된다
 */
- (void)didFailWebLoadBreakAd;

/* 모달뷰로 뜬 랜딩페이지가 닫힐때 호출된다
 */
- (void)didCloseRandingPage:(ManBreakAdInterstitial*)manAd;

@end
