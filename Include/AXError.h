//
//  AXError.h
//  AdMixer
//
//  Created by admixer on 12. 3. 19..
//  Copyright (c) 2012년 nasmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXError : NSError {
	
	NSString * _errorMsg;
	
}

+ (AXError *)errorWithCode:(int)errorCode message:(NSString *)message;

- (id)initWithCode:(int)errorCode message:(NSString *)message;

@property (nonatomic, readonly) NSString * errorMsg;

@end
