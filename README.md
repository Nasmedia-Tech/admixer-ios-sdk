# 문의사항 관련
- 문의사항은 https://partner.admixer.co.kr/ 사이트를 통해 1:1 문의로 연락 주시기 바랍니다.

# AdMixerSample

- Admixer Android SDK Sample Project   
- Current Admixer SDK Version 2.1.0 / date. 2020.05.06

## AdMixer SDK Version


| AdNetwork | Version | Check Date | compatible | Link
|---|:---:|:---:|:---:|:---:|
| `AdMixer` | 2.1.0 | 2020.05.06 | O | [Link](https://github.com/Nasmedia-Tech/admixer-ios-sdk/archive/refs/heads/master.zip) |



## Step 1. 개요

* 본 문서는 AdMixer iOS SDK를 프로젝트에 적용하기 위한 문서입니다.
* AdMixer는 광고 플랫폼을 통합하여 배너 및 전면광고를 표시하는 기능을 제공합니다.

* 각각의 라이브러리는 해당 사이트에서 최신버전을 받아 라이브러리를 교체하여 사용하실 수 있습니다. (제공되는 AdMixerSDK의 light버전은 Ad Network사의 SDK를 포함하고 있지 않으나, full버전은 lipo를 통해 simulator용과 release용을 합친 Ad Network 사의 SDK가 포함되어 있습니다.)

* __AdMixer 퍼블리셔 사이트를 통해 미디어에 대한 정보를 등록하여 media key를 발급 받으셔야 합니다.
미디어 하위에는 광고단위인 adunit을 생성해야 하며, adunit 생성 시 선택하신 사이즈와 fullscreen 여부에 맞게
광고 객체의 종류와 영역 사이즈를 설정하셔야 합니다.
Fullscreen 값을 미설정하시면 banner객체로, 설정하시면 interstitial 객체로 사용이 가능합니다.__

* AdMixer는 적용할 광고 플랫폼을 AdMixer 사이트를 통해 손쉽게 변경하실 수 있으며 각 광고 별 노출 비율 및 세부 설정 또한 사이트를 통해 변경하실 수 있습니다.

* ‘Admixer’ 네트워크를 이용하시면 서버 연동된 다수의 dsp로부터 다양한 광고를 수신 받을 수 있습니다. 이용에 참고 부탁드립니다.

* 띠배너와 전면배너 이외의 타 애드네트워크 광고를 추가하고자 하는 경우, 해당 애드네트워크 SDK 가이드를 참고하여 적용해 주시기 바랍니다.


## Step 2. SDK 구성

* Include : AdMixer iOS SDK를 control하기 위한 라이브러리 및 해당 header 파일
  - libAdMixer.a(AdMixer라이브러리,디바이스빌드전용)
  - AdMixer.h
  - AdMixerAdAdapter.h
  - AdMixerInfo.h
  - AdMixerInterstitial.h
  - AdMixerInterstitialPopupOption.h
  - AdMixerView.h
  - AXError.h
  - AXLog.h

* libAdMixer_Combo.a
  - AdMixer 라이브러리로 디바이스/시뮬레이터 공용
  - libAdMixer.a 파일과 유사하나 시뮬레이터 빌드에서도 동작합니다.
  - 이 라이브러리를 사용하시려면 Include의 libAdMixer.a 파일 대신 이 파일을 프로젝트에 포함하시면 됩니다.
  - 이 라이브러리로 빌드 시에는 앱의 크기가 1~2MB 정도 커질 수 있습니다.

* AdMixerSample: AdMixer iOS SDK 사용 예제


## Step 3. Project Setting

1. Admixer_ios_x.y.z.zip을 풉니다.
2. Include 폴더를 프로젝트에 추가합니다. (AdMixer 라이브러리 추가)
3. Adapters 폴더를 프로젝트에 추가합니다. (Adapter 추가)
4. __iOS 9 업데이트에 따른 추가 설정__
  - 프로젝트 설정의 Build Settings에서 Enable Bitcode를 NO로 설정해야 합니다.
  - __ATS(App Transport Security) 처리__ : iOS9부터 애플 보안 정책에 따라 암호화 되지 않은 HTTP 통신이 차단되어 광고에 영향을 줄 수 있습니다. 따라서 프로젝트 내ㅐ에 프로젝트명-info.plist 파일에 아래 내용을 추가해주시기 바랍니다.
    1) NSAppTransportSecurity (Type: Dictionary) 항목을 생성
    2) 하위에 NSAllowsArbitraryLoads (Type: Boolean) 아이템을 생성하여 YES로 설정합니다. 해당 설정을 통해 앱 내 모든 HTTP 통신을 허용할 수 있습니다. (For iOS 9 and Later)

    ```
    <key>NSAppTransportSecurity</key>
    <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
    </dict>
    ```

5. __2017년 iOS 10 업데이트에 따른 ATS 추가 설정__
  - __ATS(App Transport Security) 처리__
  : 2017년부터 ATS를 활성화하도록 보안이 강화되었습니다. 따라서, 기존 설정에 추가적인 옵션값이 필요합니다.
  (단, Ad Network에 따라 HTTPS 지원현황에 차이가 있을 수 있으므로, 반드시 각 Ad Network 가이드 내 ATS 설정값을 확인바랍니다.)
    1) 기존 설정대로 NSAllowsArbitraryLoads 아이템을 YES로 설정합니다. (For iOS 9 and Later)
    2) NSAllowsArbitraryLoadsForMedia (Type: Boolean) 아이템을 생성하여 YES로 설정합니다. (For iOS10)
    3) NSAllowsArbitraryLoadsInWebContent (Type: Boolean) 아이템을 생성하여 YES로 설정합니다.
    (admixer 배너 사용 시 권장하는 설정값이나, 웹뷰에서만 HTTP를 허용하는 값이므로 사용하시는 Ad Network에 따른 설정이 필요한 부분입니다.)

    ```
    <key>NSAppTransportSecurity</key>
    <dict>
      <key>NSAllowsArbitraryLoads</key> (해당값만설정시, 앱심사요청과정에서ATS 비활성사유를입력하셔야합니다.)
      <true/>
      <key>NSAllowsArbitraryLoadsForMedia</key> (optional)
      <true/>
      <key>NSAllowsArbitraryLoadsInWebContent</key> (optional)
      <true/>
    </dict>
    ```

* 다음 Framework가 포함되어 있는지 확인하시기 바랍니다.

![필요한 설정](https://github.com/Nasmedia-Tech/admixer-ios-sdk/blob/master/images/import.PNG)

##### (자세한 사항은 샘플 프로젝트 소스코드를 참조하십시오.)

## Step 4. 모바일 광고 초기화

- AdMixer 객체를 통해 반드시 1회 초기화 호출이 필요합니다.
- AdMixer 객체를 통해 필요한 adapter들을 등록해야 합니다.

```objc
-(BOOL)application(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {

  // 로그 레벨 설정
  [AdMixersetLogLevel:AXLogLevelDebug];

  // AdMixer 초기화를 위해 반드시 광고호출 전에 앱에서 1회 호출해주셔야 합니다.
  // adunits 파라미터는 앱 내에서 사용할 모든 adunit id를 배열형태로 넘겨주셔야 합니다.
  [AdMixerinitWithMediaKey:mediaKeyadunits:adunits];

  // COPPA(아동보호법) 관련 항목 설정값 - 선택사항
  [AdMixersetTagForChildDirectedTreatment:AX_TAG_FOR_CHILD_DIRECTED_TREATMENT_TRUE];


}
```

## Step 5. Banner 광고 추가 예제 - 광고 뷰 추가

- Banner 광고를 위해서는 AdMixerViewDelegate 구현하셔야 합니다.
- Banner 광고를 담는 AdMixerView가 필요합니다.

```objc
@interface ViewController : UIViewController<AdMixerViewDelegate, AdMixerInterstitialDelegate> {
  AdMixerView * _adView;
}
```
- 광고정보를 관리하는 객체(AdMixerInfo)를 생성하고, adunitID필드를 발급받은 adunitid로 채웁니다.
- 광고영역의 사이즈는 반드시 생성하신 adunit에 맞게 설정하시기 바랍니다.

```objc
- (void) viewDidLoad {
  [super viewDidLoad];

  AdMixerInfo* adInfo= [[[AdMixerInfoalloc] init] autorelease];
  adInfo.adunitID= @“my_adunit_id";//adunitid값을설정합니다.

  _adView= [[AdMixerViewalloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
  _adView.center= CGPointMake(self.view.center.x, _adView.center.y);
  // 320*50사이즈 일때만, 가로를 디바이스에 맞추거나 영역사이즈로 설정하는 것 중에 선택가능
  // 320*50을 제외한 사이즈일때는 영역사이즈로 설정해야 함

  _adView.delegate= self;
  [self.viewaddSubview:_adView];

  [_adViewstartWithAdInfo:adInfobaseViewController:self];

  // 앱 백그라운드 진입 시 혹은 다른 뷰로 넘어갈 때 띠배너 객체를 해제하는 방법은 아래와 같습니다.
  [_adViewremoveFromSuperview];
  _adView= nil;
}
```

*  AdMixerViewDelegate를 통한 이벤트 수신
  - AdMixerViewDelegate를 위한 method를 구현합니다.
  - onSucceededToReceiveAd는 광고를 잘 받아온 경우 호출됩니다.
  - onFailedToReceiveAd는 광고 받기에 실패한 경우 호출됩니다.
  - 현재 선택된 adapter 이름 확인 : [adViewcurrentAdapterName];

```objc
#pragma mark -AdMixerViewDelegate

- (void)onSucceededToReceiveAd:(AdMixerView*)adView{
  NSLog(@"onSucceededToReceiveAd");
}

- (void)onFailedToReceiveAd:(AdMixerView*)adViewerror:(AXError*)error {
  NSLog(@"onFailedToReceiveAd: %@", error.errorMsg);
}
```


## Step 6. Interstitial 광고 추가 예제

- 전면광고에는 두 가지 형태가 제공됩니다.
- 팝업형 전면광고의 경우 admixer 네트워크 전면배너만 사용 가능합니다.

| 일반 전면광고 예시 | 팝업형 전면광고 예시
|:---:|:---:|
|![일반 전면광고 예시](https://github.com/Nasmedia-Tech/admixer-ios-sdk/blob/master/images/Interstitial_ads.png) |![팝업형 전면광고 예시](https://github.com/Nasmedia-Tech/admixer-ios-sdk/blob/master/images/Interstitial_popup_ads.png)

### 6-1 Interstitial 광고(전면광고) 추가 예제 - 광고 뷰 추가

- Interstitial 광고를 위해서는 AdMixerInterstitialDelegate 구현하셔야 합니다.
- Interstitial 광고는 1회성 객체입니다. start 혹은 load 메소드 호출은 한 번만 가능합니다.
- startWithAdInfoAPI를 호출하시면 onSucceededToReceiveInterstitalAd 이벤트와 동시에 자동적으로 전면광고가 표시됩니다.
- loadWithAdInfo API를 호출하시면 onSucceededToReceiveInterstitalAd 이벤트를 받아서 광고로딩이 성공하면 원하는시점에 displayAd API로 전면광고를 노출하게 됩니다.
- loadWithAdInfo API를 호출하고 일정시간이 지나면, 광고가 노출이 되어도 유효노출로 처리되지 않는 경우가 있습니다. 이 경우는 ad network별로 다르므로, 해당 네트워크 사에 확인하여 loadWithAdInfo 호출 후 적절한 타임아웃을 걸어서 재호출 하는 방식으로 사용하시기 바랍니다. 최소호출간격이 있는 경우도 있으므로, 적당한 타임아웃을 설정하시기 바랍니다.

- 아래 코드는 Interstitial 광고를 추가한 예제입니다.

```objc
@property(nonatomic, strong) AdMixerInterstitial* interstitial;
- (IBAction)interstitialAdButtonAction:(id)sender {
  AdMixerInfo* adInfo= [[[AdMixerInfoalloc] init] autorelease];
  adInfo.adunitID= @"my_adunit_id"; // adunitid값을 설정합니다.
  // adInfo.interstitialTimeout= 20; // 전면요청 timeout설정(Default값은 0으로 서버에서 주는 시간으로 처리)
  // adInfo.setBackgroundAlpha= YES; // 전면노출시 광고 외 영역반 투명처리(Default값은NO)

  //팝업형 전면광고 설정 코드(선택사항)
  AdMixerInterstitialPopupOption*adConfig= [[AdMixerInterstitialPopupOptionalloc] init]; // 팝업형 전면광고 옵션 설정
  [adConfigsetButton:@”광고종료” withButtonColor:[UIColorwhiteColor]];
  // 광고를 닫는 기능의 버튼이 제공되며, 버튼문구와 버튼색상을 지정가능(버튼문구 Default값은‘광고종료’)
  [adConfigsetButtonFrameColor:[UIColorblackColor]]; // 버튼프레임색상을지정가능
  [adInfosetInterstitialAdType:AdMixerInterstitialPopupTypewithInterstitialPopupOption:adConfig];
  // 팝업형 전면광고 option을 adInfo에 적용(optionnil로 설정시 Default option으로 제공됨)
  // AdMixerInterstitialBasicType: 일반(Default), AdMixerInterstitialPopupType: 팝업형

  // 전면광고는 1회성 객체이며,
  // adunit_id와 1:1 매핑되므로 광고호출시 자원이 남아있으면 명시적으로 해제함
  [self stopInterstitial];

  interstitial = [[AdMixerInterstitialalloc] init];
  interstitial.delegate= self;
  [interstitial startWithAdInfo:adInfobaseViewController:self];//광고로딩시 바로 표시
  //[interstitial loadWithAdInfo:adInfobaseViewController:self]; //광고로딩 후원하는 시점에 displayAd를 호출
}
- (void)stopInterstitial {
  if(interstitial != nil) {
    [interstitial stop];
    interstitial = nil;
  }
}

#pragma mark -AdMixerInterstitialDelegate
- (void)onSucceededToReceiveInterstitialAd:(AdMixerInterstitial*)interstitial {
  NSLog(@"onSucceededToReceiveInterstitialAd");
}
- (void)onFailedToReceiveInterstitialAd:(AdMixerInterstitial*)interstitial error:(AXError*)error {
  NSLog(@"onFailedToReceiveInterstitialAd: %@", error.errorMsg);
  [self stopInterstitial];
}
- (void)onClosedInterstitialAd:(AdMixerInterstitial*)interstitial {
  NSLog(@"onClosedInterstitialAd");
  [self stopInterstitial];
}
- (void)onDisplayedInterstitialAd:(AdMixerInterstitial*)interstitial {
  NSLog(@"onDisplayedInterstitialAd");
}
- (void)onClickedPopupButton:(AdMixerInterstitial*)interstitial {
  NSLog(@”onClickedPopupButton”);
}

• AdMixerInterstitialDelegate를 위한 method를 구현합니다.
• onSucceededToReceiveInterstitialAd는 광고를 잘 받아온 경우 호출됩니다.
• onFailedToReceiveInterstitialAd는 광고받기에 실패한 경우 호출됩니다.
• onClosedInterstitialAd는 전면광고창이 닫혔을 때에 호출됩니다.
• onDisplayedInterstitialAd는 전면광고가 화면에 보여졌을 때에 호출됩니다. (선택사항)
• onClickedPopupButton은 팝업형 전면광고 버튼을 누르면 호출됩니다. (선택사항)

```

### 6-2 Interstitial 광고 추가 예제 - 닫기 (Close)

- 전면광고가 화면에 노출되기 전에 close를 호출하게 되면 동작하지 않습니다.
- 아래와 같이 타이머를 사용할 경우, 반드시 close delegate에서 타이머를 해제하여야 합니다. (타이머 작동 이전에 사용자가 전면광고를 끄게되면, close method가 다음 전면광고에 영향을 줄 수 있습니다.)

```obcj
AdMixerInterstitial*_interstitial ;
NSTimer*timer;

-(void)onDisplayedInterstitialAd:(AdMixerInterstitial*)intersitial{
  NSLog(@"onDisplayedInterstitialAd");
  timer = [NSTimerscheduledTimerWithTimeInterval:5 target:self
  selector:@selector(closeInterstiail) userInfo:nilrepeats:NO];
  // 전면광고 노출 후 5초 타이머 설정
}

-(void)onClosedInterstitialAd:(AdMixerInterstitial*)intersitital{NSLog(@"onClosedInterstitialAd");
  [timer invalidate]; // 타이머 해제
}

-(void)closeInterstitial{
  If(_interstitial) {
    [_interstitial close]; // 전면광고 닫기
    _interstitial = nil;
  }
}
```

##### (자세한 사항은 샘플 프로젝트 소스코드를 참조하십시오.)

## Step 7. 자주하는 질문 (Q&A)

* 문제 확인을 위한 로그는 없나요?
  - [AdMixersetLogLevel:AXLogLevelAll];
  - 위의 코드를 넣으시면 상세한 로그를 확인하실 수 있습니다.문제 발생 시 해당 로그를 전달해 주시면 좀 더 정확한 원인 파악에 도움이 됩니다.

* 하나의 App에 복수 개의 Media Key를 적용해도 되나요?
  - 한 개의 App에는 한 개의 Media Key만 적용하셔야 합니다.

* 동일한 Adunit ID로 여러 개의 광고객체를 생성해도 되나요?
  - 한 개의 Adunit ID는 한 개의 광고객체에서만 사용가능합니다.

* 광고객체를 정상적으로 호출했으나 광고요청이 이루어지지 않습니다.
  - AdMixer 객체를 통해 초기화 호출을 해주셨는지 확인 부탁드립니다. 초기화 시에 설정한 Media Key 및 adunitID 배열과 일치하는 정보를 가진 광고객체만 정상적으로 동작합니다.
  - Adunit 생성 시에 입력한 fullscreen 정보에 따라서 사용가능한 광고객체가 다릅니다. banner 객체는 fullscreen이 off 일때, interstitial 객체는 fullscreen이 on일 때 각각 사용할 수 있습니다.

* Adunit에 설정한 사이즈와 다른 사이즈의 광고가 노출됩니다.
  - AdUnit 에 설정한 사이즈값은 AdMixer 는 내부적으로 사이즈가 보장되지만, 광고의 유형에 따라 다르게 노출 될 수 있습니다.

* 한App내에서많은adunit을사용해도되나요?
  - 사용 가능한 adunit수에 제한은 없지만, 광고 객체를 설정하고 로딩하는데에 많은 메모리가 할당되기 때문에 앱 성능을 위해서 많은 광고객체 호출은 지양하시는 것이 좋습니다.

* 시뮬레이터Configuration에서는빌드가되지않습니다.
  - 기본으로 포함되어 있는 libAdMixer.a 라이브러리는 디바이스 전용 라이브러리입니다. 상위 폴더에 있는 libAdMixer_Combo.a 라이브러리로 교체하시면 됩니다.

* ARC(Automatic Reference Counting)설정이 되어 있지 않은 것 같습니다.
  - ARC는 빌드 시에 소스파일(.m)에 적용하는 옵션으로 라이브러리 자체에는 ARC 적용에 따른 차이는 없습니다. ARC가 적용된 프로젝트 혹은 소스에서는 AdMixer 관련 Class 사용 시 retain, release를 호출하실 필요가 없고, ARC가 적용되지 않은 소스에서는 반드시 retain, release를 적절하게 호출해 주셔야 합니다. 다만, ARC 프로젝트내에서 각 adapter(.m) 파일을 import하여 사용하실때는 build phases에서 compile sources에 있는 adapter(.m)파일마다-fno-objc-arc 옵션값을 설정하시기 바랍니다.

* 라이브러리 크기를 줄일 수 있습니까?
  - 모든 광고를 적용하시는 편이 표시할 광고가 없는 상황을 줄일 수 있기 때문에 가급적이면 모든 광고를 포함하시는 편이 좋겠지만 프로그램 크기가 커져서 문제가 되신다면 꼭 필요한 Ad Network를 결정하시고 불필요한 adapter를 삭제하시고, 필요한 Ad Network adapter만 등록하시면 됩니다.

* 전면광고가 자주 나오지 않습니다.
  - 전면 광고의 경우 배너 광고보다 광고 물량이 적어 설정하신 Ad Network가 적은 경우 광고가 나오지 않을 확률도 그 만큼 커집니다.
