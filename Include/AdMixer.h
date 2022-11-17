//
//  AdMixer.h
//  AdMixer
//
//  Created by admixer on 12. 6. 11..
//  Copyright (c) 2012년 nasmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXError.h"

#define ADAPTER_ADMIXER             (@"admixerrtb")
#define ADAPTER_ADMIXER_HOUSE		(@"admixer")

#define AX_ERR_INIT                 (0x80000001)
#define AX_ERR_ADUNIT               (0x80000002)
#define AX_ERR_HTTP		            (0x80000003)
#define AX_ERR_TIMEOUT			    (0x80000004)
#define AX_ERR_NO_ADAPTER		    (0x80000005)
#define AX_ERR_ADAPTER	            (0x80000006)
#define AX_ERR_CONFIG_FAIL          (0x80000007)
#define AX_ERR_NO_FILL              (0x80000008)

#define ADFORMAT_BANNER             (@"banner")
#define ADFORMAT_NATIVE             (@"native")
#define ADFORMAT_VIDEO              (@"video")

#define AX_TAG_FOR_CHILD_DIRECTED_TREATMENT_FALSE (0)
#define AX_TAG_FOR_CHILD_DIRECTED_TREATMENT_TRUE (1)

typedef enum {
	AXLogLevelNone,
	AXLogLevelRelease,
	AXLogLevelDebug,
	AXLogLevelAll
} AXLogLevel;

@interface AdMixer : NSObject

+ (void)setLogLevel:(AXLogLevel)logLevl;
+ (AXLogLevel)logLevel;

+ (void)initWithMediaKey:(NSString *)mediaKey adunits:(NSArray *)adunits;
+ (BOOL)registerAdapter:(NSString *)adapterName cls:(Class)cls;
+ (void)setTagForChildDirectedTreatment:(int)tagId;
+ (int)getTagForChildDirectedTreatment;

@end

