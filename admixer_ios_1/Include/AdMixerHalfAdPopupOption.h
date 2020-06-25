//
//  AdMixerHalfAdPopupOption.h
//  AdMixer
//
//  Created by 원소정 on 2017. 1. 16..
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AdMixerHalfAdPopupOption : NSObject

- (void)setButton:(NSString *)title withButtonColor:(UIColor *)color;
- (void)setButtonFrameColor:(UIColor *)color;

@property (nonatomic, retain, readonly) NSString *btnTitle;
@property (nonatomic, retain, readonly) UIColor *btnColor;
@property (nonatomic, retain, readonly) UIColor *frameColor;

@end
