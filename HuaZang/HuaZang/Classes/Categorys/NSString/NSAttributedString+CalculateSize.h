//
//  NSAttributedString+CalculateSize.h
//  AirChina
//
//  Created by BIN QIN on 2018/10/29.
//  Copyright © 2018 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (CalculateSize)
- (CGSize)getStringRectWithWidth:(CGFloat)width height:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
