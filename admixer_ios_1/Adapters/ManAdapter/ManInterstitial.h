//
//  ManInterstitial.h
//  ManAdView
//
//  Created by mezzomedia on 13. 8. 16..
//  Copyright (c) 2013년 MezzoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ManAdDefine.h"

@protocol ManInterstitialDelegate;

/* 전면광고
 */
@interface ManInterstitial : NSObject

/* 전달받는 뷰컨트롤러의 객체
 */
@property (nonatomic, assign) id<ManInterstitialDelegate>delegate;

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

/*
 광고 view style 
 @"0" 전체화면
 @"2" 사이즈만
 @"3" 사이즈와 팝업
*/
@property (nonatomic, copy) NSString *viewType;

// MAN SDK 사이트에서 발급받은 publisher ID, media ID, section ID 입력
- (void)publisherID:(NSString*)publisherID mediaID:(NSString*)mediaID sectionID:(NSString*)sectionID;


/* 전면광고 객체생성
 */
+ (ManInterstitial*)shareInstance;

/* 전면광고를 요청한다.
 */
- (void)startInterstitial;

/* SDK 버전 반환
 */
- (NSString*)getSdkVersion;

@end


/* 전면광고 프로토콜
 */
@protocol ManInterstitialDelegate <NSObject>

@optional

/* 전면 광고 수신 성공
 */
- (void)didReceiveInterstitial;

/* 전면 광고 수신 에러
 */
- (void)didFailReceiveInterstitial:(NSInteger)errorType;

/* 전면 광고 닫기
 */
- (void)didCloseInterstitial;

@end
