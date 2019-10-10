//
//  JSONKit.h
//  AirChina
//
//  Created by BIN on 2019/2/15.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JSONKitDeserializing)
- (id)objectFromJSONString;
- (id)mutableObjectFromJSONString;
- (id)fragmentObjectFromJSONString;

@end

@interface NSData (JSONKitDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)objectFromJSONData;
- (id)mutableObjectFromJSONData;
- (id)fragmentObjectFromJSONData;
- (id)mutableLeavesFromJSONData;

@end

#pragma mark Serializing methods
@interface NSString (JSONKitSerializing)
- (nullable NSData *)JSONData;

@end

@interface NSArray (JSONKitSerializing)
- (nullable NSData *)JSONData;
- (NSString *)JSONString;

@end

@interface NSDictionary (JSONKitSerializing)
- (nullable NSData *)JSONData;
- (NSString *)JSONString;

@end

NS_ASSUME_NONNULL_END
