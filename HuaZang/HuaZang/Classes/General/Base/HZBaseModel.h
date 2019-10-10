//
//  HZBaseModel.h
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZBaseModel : NSObject

/**
 * 基于JSON创建并返回新实例（线程安全）
 * @param json 类型为`NSDictionary`,`NSString`或者`NSData`的对象
 * @return instancetype 新实例，如果发生错误则返回nil
 */
+ (nullable instancetype)modelWithJSON:(id)json;

/**
 * 基于NSDictionary创建并返回新实例（线程安全）
 * @param dictionary 属性字典，任何无效的键值对都会被忽略
 * @return instancetype 新实例，如果发生错误则返回nil
 * @discussion 字典中的Key与接受者的属性是映射对应关系。
 如果字典中的value的类型与属性类型不一致，这个方法会尝试用如下规则转换value
 `NSString` or `NSNumber` -> c number, such as BOOL, int, long, float, NSUInteger...
 `NSString` -> NSDate, parsed with format "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd HH:mm:ss" or "yyyy-MM-dd".
 `NSString` -> NSURL.
 `NSValue` -> struct or union, such as CGRect, CGSize, ...
 `NSString` -> SEL, Class.
 */
+ (nullable instancetype)modelWithDictionary:(NSDictionary *)dictionary;

/**
 * 基于JSON给实例赋值
 * @discussion JSON中任何无效的数据都会被忽略
 * @param json 类型为`NSDictionary`,`NSString`或者`NSData`的对象,与接受者的属性是映射对应关系
 * @return 是否成功
 */
- (BOOL)modelSetWithJSON:(id)json;

/**
 * 基于NSDictionary给实例赋值
 * @param dic 属性字典，任何无效的键值对都会被忽略
 * @discussion 字典中的Key与接受者的属性是映射对应关系。
 如果字典中的value的类型与属性类型不一致，这个方法会尝试用如下规则转换value
 `NSString` or `NSNumber` -> c number, such as BOOL, int, long, float, NSUInteger...
 `NSString` -> NSDate, parsed with format "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd HH:mm:ss" or "yyyy-MM-dd".
 `NSString` -> NSURL.
 `NSValue` -> struct or union, such as CGRect, CGSize, ...
 `NSString` -> SEL, Class.
 * @return 是否成功
 */
- (BOOL)modelSetWithDictionary:(NSDictionary *)dic;

/**
 * 模型转NSObject
 */
- (nullable id)modelToJSONObject;

/**
 * 模型转NSData
 */
- (nullable NSData *)modelToJSONData;

/**
 * 模型转json字符串
 */
- (nullable NSString *)modelToJSONString;

/**
 * 模型深拷贝
 * @return 新实例，如果发生错误则返回nil
 */
- (nullable id)modelCopy;

/**
 * 判断模型是否相等
 * @param model  另一个模型
 * @return 如果相等返回`YES`，反之返回`NO`.
 */
- (BOOL)modelIsEqual:(id)model;



/**
 Encode the receiver's properties to a coder.

 @param aCoder  An archiver object.
 */
- (void)modelEncodeWithCoder:(NSCoder *)aCoder;

/**
 Decode the receiver's properties from a decoder.

 @param aDecoder  An archiver object.

 @return self
 */
- (id)modelInitWithCoder:(NSCoder *)aDecoder;

/**
 Get a hash code with the receiver's properties.

 @return Hash code.
 */
- (NSUInteger)modelHash;

/**
 Description method for debugging purposes based on properties.

 @return A string that describes the contents of the receiver.
 */
- (NSString *)modelDescription;

/**
 Creates and returns an array from a json-array.
 This method is thread-safe.

 @param cls  The instance's class in array.
 @param json  A json array of `NSArray`, `NSString` or `NSData`.
 Example: [{"name":"Mary"},{name:"Joe"}]

 @return A array, or nil if an error occurs.
 */
+ (nullable NSArray *)modelArrayWithClass:(Class)cls json:(id)json;

/**
 Creates and returns a dictionary from a json.
 This method is thread-safe.

 @param cls  The value instance's class in dictionary.
 @param json  A json dictionary of `NSDictionary`, `NSString` or `NSData`.
 Example: {"user1":{"name","Mary"}, "user2": {name:"Joe"}}

 @return A dictionary, or nil if an error occurs.
 */
+ (nullable NSDictionary *)modelDictionaryWithClass:(Class)cls json:(id)json;

@end

NS_ASSUME_NONNULL_END
