//
//  HZBaseModel.m
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseModel.h"
#import "YYModel.h"
@implementation HZBaseModel
+ (nullable instancetype)modelWithJSON:(id)json {
    return [self yy_modelWithJSON:json];
}

+ (nullable instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [self yy_modelWithDictionary:dictionary];
}

- (BOOL)modelSetWithJSON:(id)json {
    return [self yy_modelSetWithJSON:json];
}

- (BOOL)modelSetWithDictionary:(NSDictionary *)dic {
    return [self yy_modelSetWithDictionary:dic];
}

- (nullable id)modelToJSONObject {
    return [self yy_modelToJSONObject];
}


- (nullable NSData *)modelToJSONData {
    return [self yy_modelToJSONData];
}

- (nullable NSString *)modelToJSONString {
    return [self yy_modelToJSONString];
}

- (nullable id)modelCopy {
    return [self yy_modelCopy];
}

- (void)modelEncodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)modelInitWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

- (NSUInteger)modelHash {
    return [self yy_modelHash];
}


- (BOOL)modelIsEqual:(id)model {
    return [self yy_modelIsEqual:model];
}

- (NSString *)modelDescription {
    return [self yy_modelDescription];
}

+ (nullable NSArray *)modelArrayWithClass:(Class)cls json:(id)json {
    return [NSArray yy_modelArrayWithClass:cls json:json];
}

+ (nullable NSDictionary *)modelDictionaryWithClass:(Class)cls json:(id)json {
    return [NSDictionary yy_modelDictionaryWithClass:cls json:json];
}
@end
