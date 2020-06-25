//
//  ManAdDefine.h
//  ManAdDefine
//
//  Created by MezzoMedia on 13. 2. 1..
//  Copyright (c) 2013년 MezzoMedia. All rights reserved.
//

#ifndef ManAdDefine_h
#define ManAdDefine_h

// S-Plus 띠배너 실사이즈
#define MAN_BANNER_AD_WIDTH    320.0f
#define MAN_BANNER_AD_HEIGHT    50.0f
#define MAN_BANNER_RATIO (MAN_BANNER_AD_WIDTH / MAN_BANNER_AD_HEIGHT)

/* 광고 수신 에러 1.0
 */
//typedef enum {
//    
//    ManAdSuccess            = 0,           // 성공
//    ManAdNetworkError       = -100,        // 네트워크 에러
//    ManAdServerError        = -200,        // 광고 서버 에러
//    ManAdApiTypeError       = -300,        // API Type 에러
//    ManAdAppIDError         = -400,        // App ID값 에러
//    ManAdWindowIDError      = -500,        // Window ID값 에러
//    ManAdNotNormalIDError   = -600,        // 해당 ID값이 정상적이지 않음
//    ManAdNotExistAd         = -700,        // 해당 ID의 광고가 존재하지 않음
//    ManAdCreativeError      = -900         // 광고물 요청 실패
//    
//} ManAdErrorType;

/* 광고 수신 에러 2.0
*/
typedef enum {
    
    NewManAdSuccess            = 0,            // 성공
    NewManAdRequestError       = -1002,        // 잘못된 광고 요청
    NewManAdParameterError     = -2002,        // 잘못된 파라메터 전달
    NewManAdIDError            = -3002,        // 광고 솔루션에서 발급 한 사업자/미디어/섹션 코드 미존재
    NewManAdNotError           = -4002,        // 광고 없음 (No Ads)
    NewManAdServerError        = -5002,        // 광고서버 에러
    NewManAdNetworkError       = -6002,        // 네트워크 에러
    NewManAdCreativeError      = -9001         // 광고물 요청 실패
    
} NewManAdErrorType;

/* 동영상 광고 모드
 */
typedef enum {
    
    MODE_NORMAL,
    MODE_WIDE,
    MODE_STRETCH,
    MODE_ORIGNAL
    
} MOVIE_SCREEN_MODE;
#endif
