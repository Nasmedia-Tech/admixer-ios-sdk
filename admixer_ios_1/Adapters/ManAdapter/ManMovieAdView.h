//
//  ManMovieAdView.h
//  ManAdView
//
//  Created by mezzomedia on 2014. 5. 28..
//  Copyright (c) 2014년 MezzoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManAdDefine.h"

@protocol ManMovieAdViewDelegate;

@interface ManMovieAdView : UIView

/* 전달받는 뷰컨트롤러의 객체
 */
@property (nonatomic, assign) id<ManMovieAdViewDelegate>delegate;

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

/* m_vcode
 m_vcode : @"AfreecaBj"
 */
@property (nonatomic, copy) NSString *m_vcode;

/*
 버튼 UI 타입 설정
 uiType : @"A"(Default), @"B"
 */
@property (nonatomic, copy) NSString *uiType;

/* 동영상 카테고리 Code 정보
 categoryCD : @"a_cate" @"gv_cate" @"m_cate"
 */
@property (nonatomic, copy) NSString *categoryCD;

// 랜딩페이지 사파리로 띄울지 여부 - (YES : 사파리사용, NO : 모달뷰사용)
-(void)useGotoSafari:(BOOL)useFlag;

// MAN SDK 사이트에서 발급받은 publisher ID, media ID, section ID 입력
- (void)publisherID:(NSString*)publisherID mediaID:(NSString*)mediaID sectionID:(NSString*)sectionID;


/* 동영상 광고를 요청한다.
 */
- (void)startMovieAd;

/* 동영상 광고를 중지한다.
 */
- (void)stopMovieAd;

/* 동영상 플레이 사이즈 변경
 */
- (void)setScreenMode:(MOVIE_SCREEN_MODE)movieScreenMode;

/* iOS 버전이 7.0 이상일때만 ViewController의 edgesForExtendedLayout를 알려준다
 */
- (void)setEdgesForExtendedLayout:(UIRectEdge)edgesForExtendedLayout NS_AVAILABLE_IOS(7_0);


#pragma mark for Mezzo

/* 동영상광고 미디어 URL 요청 - (요청시 responseMovieAdURL딜리게이트 메소드로 콜백)
 */
- (void)requestMovieAdURL;

/* 동영상광고 시청을 요청함 (미디어를 크롬캐스트로 출력시 사용)
 */
- (void)requestDidMovieAd;

/* SDK 버전 반환
 */
- (NSString*)getSdkVersion;

@end


/* 동영상 광고 프로토콜
*/
@protocol ManMovieAdViewDelegate <NSObject>

@optional

/* 동영상 광고 정보 수신 성공
 */
- (void)didReceiveMovieAd:(ManMovieAdView*)manMovieAd;

/* 동영상 광고 정보 수신 에러
 */
- (void)didFailReceiveMovieAd:(ManMovieAdView*)manMovieAd errorType:(NSInteger)errorType;

/* 동영상 광고 종료
 */
- (void)didFinishMovieAd:(ManMovieAdView*)manMovieAd;

/* 동영상 광고 종료 (동영상 광고 플래이 도중 종료됨)
 */
- (void)didStopMovieAd:(ManMovieAdView*)manMovieAd;

/* 동영상 광고 스킵
 */
- (void)didSkipMovieAd:(ManMovieAdView*)manMovieAd;

/* 동영상 광고 없음
 */
- (void)didNotExistMovieAd:(ManMovieAdView*)manMovieAd;

/* 동영상 광고 클릭
 */
- (void)didClickMovieAd:(ManMovieAdView*)manMovieAd;

/* 랜딩페이지 클로즈버튼 클릭
 */
- (void)didCloseRandingPage:(ManMovieAdView*)manMovieAd;

/* 동영상 광고 URL 전달
 */
- (void)responseMovieAdURL:(ManMovieAdView*)manMovieAd movieAdURL:(NSString*)movieAdURL;

@end