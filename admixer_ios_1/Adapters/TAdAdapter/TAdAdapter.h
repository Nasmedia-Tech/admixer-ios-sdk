//
//  TAdAdapter.h
//  AdMixerTest
//
//  Created by 정건국 on 12. 6. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//
// v3.6.1.0

#import <Foundation/Foundation.h>
#import "AdMixerAdAdapter.h"
#import "TadCore.h"

@interface TAdAdapter : AdMixerAdAdapter<TadDelegate> {
	
	UIView * _adView;
	BOOL _needRelease;
	TadCore * _tadCore;
	
}

@end
