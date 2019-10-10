//
//  JSONKit.m
//  AirChina
//
//  Created by BIN on 2019/2/15.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "JSONKit.h"

@implementation NSString (JSONKitDeserializing)
- (NSData *)dataUsingUTF8 {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)fromJsonStringWithOptions:(NSJSONReadingOptions)options {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:[self dataUsingUTF8]
                                              options:options
                                                error:&error];
    if (error) {
        NSAssert(error, [error localizedFailureReason]);
        return nil;
    }
    return json;
}

- (id)objectFromJSONString {
    return [self fromJsonStringWithOptions:0];
}

- (id)mutableObjectFromJSONString {
    return [self fromJsonStringWithOptions:NSJSONReadingMutableContainers];
}

- (id)fragmentObjectFromJSONString {
    return [self fromJsonStringWithOptions:NSJSONReadingAllowFragments];
}

@end

@implementation NSData (JSONKitDeserializing)
- (id)fromJsonDataWithOptions:(NSJSONReadingOptions)options {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:self
                                              options:options
                                                error:&error];
    if (error) {
        NSAssert(error, [error localizedFailureReason]);
        return nil;
    }
    return json;
}

- (id)objectFromJSONData {
    return [self fromJsonDataWithOptions:0];
}

- (id)mutableObjectFromJSONData {
    return [self fromJsonDataWithOptions:NSJSONReadingMutableContainers];
}

- (id)fragmentObjectFromJSONData {
    return [self fromJsonDataWithOptions:NSJSONReadingAllowFragments];
}

- (id)mutableLeavesFromJSONData {
    return [self fromJsonDataWithOptions:NSJSONReadingMutableLeaves];
}

@end

#pragma mark Serializing methods

@implementation NSString (JSONKitSerializing)
- (NSData *)JSONData {
    if (![NSJSONSerialization isValidJSONObject:self]) {
        NSAssert(self, @"The object can't be converted to JSON data.");
        return nil;
    }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (error) {
        NSAssert(error, [error localizedFailureReason]);
        return nil;
    }
    return data;
}

@end

@implementation NSArray (JSONKitSerializing)
- (NSData *)JSONData {
    if (![NSJSONSerialization isValidJSONObject:self]) {
        NSAssert(self, @"The object can't be converted to JSON data.");
        return nil;
    }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (error) {
        NSAssert(error, [error localizedFailureReason]);
        return nil;
    }
    return data;
}

- (NSString *)JSONString {
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];

}

@end


@implementation NSDictionary (JSONKitSerializing)
- (NSData *)JSONData {
    if (![NSJSONSerialization isValidJSONObject:self]) {
        NSAssert(self, @"The object can't be converted to JSON data.");
        return nil;
    }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (error) {
        NSAssert(error, [error localizedFailureReason]);
        return nil;
    }
    return data;
}

- (NSString *)JSONString {
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];

}

@end
