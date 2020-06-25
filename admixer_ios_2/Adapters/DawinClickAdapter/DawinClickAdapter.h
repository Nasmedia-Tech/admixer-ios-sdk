//
//  TAdAdapter.h

#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"
#import "TadCore.h"

@interface DawinClickAdapter : AdMixerAdAdapter<TadDelegate> {
	
    NSString * _clientId;
	UIView * _adView;
	BOOL _needRelease;
	TadCore * _tadCore;
	
}

@end
