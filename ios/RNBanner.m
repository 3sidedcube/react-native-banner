#import "RNBanner.h"
#import "TSCToastView.h"
#import "TSCToastNotificationController.h"
#import <React/RCTConvert.h>
#import <React/RCTFont.h>

@implementation RNBanner

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSMutableDictionary *)textAttributesFromDictionary:(NSDictionary *)dictionary withPrefix:(NSString *)prefix baseFont:(UIFont *)baseFont
{
    NSMutableDictionary *textAttributes = [NSMutableDictionary new];
    
    NSString *colorKey = @"color";
    NSString *familyKey = @"fontFamily";
    NSString *weightKey = @"fontWeight";
    NSString *sizeKey = @"fontSize";
    NSString *styleKey = @"fontStyle";
    NSString *shadowColourKey = @"shadowColor";
    NSString *shadowOffsetKey = @"shadowOffset";
    NSString *shadowBlurRadiusKey = @"shadowBlurRadius";
    NSString *showShadowKey = @"showShadow";
    
    if (prefix) {
        
        colorKey = [colorKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[colorKey substringToIndex:1].capitalizedString];
        colorKey = [NSString stringWithFormat:@"%@%@", prefix, colorKey];
        
        familyKey = [familyKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[familyKey substringToIndex:1].capitalizedString];
        familyKey = [NSString stringWithFormat:@"%@%@", prefix, familyKey];
        
        weightKey = [weightKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[weightKey substringToIndex:1].capitalizedString];
        weightKey = [NSString stringWithFormat:@"%@%@", prefix, weightKey];
        
        sizeKey = [sizeKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[sizeKey substringToIndex:1].capitalizedString];
        sizeKey = [NSString stringWithFormat:@"%@%@", prefix, sizeKey];
        
        styleKey = [styleKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[styleKey substringToIndex:1].capitalizedString];
        styleKey = [NSString stringWithFormat:@"%@%@", prefix, styleKey];
        
        shadowColourKey = [shadowColourKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[shadowColourKey substringToIndex:1].capitalizedString];
        shadowColourKey = [NSString stringWithFormat:@"%@%@", prefix, shadowColourKey];
        
        shadowOffsetKey = [shadowOffsetKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[shadowOffsetKey substringToIndex:1].capitalizedString];
        shadowOffsetKey = [NSString stringWithFormat:@"%@%@", prefix, shadowOffsetKey];
        
        shadowBlurRadiusKey = [shadowBlurRadiusKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[shadowBlurRadiusKey substringToIndex:1].capitalizedString];
        shadowBlurRadiusKey = [NSString stringWithFormat:@"%@%@", prefix, shadowBlurRadiusKey];
        
        showShadowKey = [showShadowKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[showShadowKey substringToIndex:1].capitalizedString];
        showShadowKey = [NSString stringWithFormat:@"%@%@", prefix, showShadowKey];
    }
    
    NSShadow *shadow;
    
    NSNumber *shadowColor = dictionary[shadowColourKey];
    if (shadowColor && [shadowColor isKindOfClass:[NSNumber class]]) {
        if (!shadow) {
            shadow = [NSShadow new];
        }
        shadow.shadowColor = [RCTConvert UIColor:shadowColor];
    }
    
    NSDictionary *shadowOffsetDict = dictionary[shadowOffsetKey];
    if (shadowOffsetDict && [shadowOffsetDict isKindOfClass:[NSDictionary class]]) {
        CGSize shadowOffset = [RCTConvert CGSize:shadowOffsetDict];
        if (!shadow) {
            shadow = [NSShadow new];
        }
        shadow.shadowOffset = shadowOffset;
    }
    
    NSNumber *shadowRadius = dictionary[shadowBlurRadiusKey];
    if (shadowRadius) {
        CGFloat radius = [RCTConvert CGFloat:shadowRadius];
        if (!shadow) {
            shadow = [NSShadow new];
        }
        shadow.shadowBlurRadius = radius;
    }
    
    NSNumber *showShadow = dictionary[showShadowKey];
    if (showShadow) {
        BOOL show = [RCTConvert BOOL:showShadow];
        if (!show) {
            shadow = nil;
        }
    }
    
    if (shadow) {
        [textAttributes setObject:shadow forKey:NSShadowAttributeName];
    }
    
    NSNumber *textColor = dictionary[colorKey];
    if (textColor && [textColor isKindOfClass:[NSNumber class]])
    {
        UIColor *color = [RCTConvert UIColor:textColor];
        [textAttributes setObject:color forKey:NSForegroundColorAttributeName];
    }
    
    NSString *fontFamily = dictionary[familyKey];
    if (![fontFamily isKindOfClass:[NSString class]]) {
        fontFamily = nil;
    }
    
    NSString *fontWeight = dictionary[weightKey];
    if (![fontWeight isKindOfClass:[NSString class]]) {
        fontWeight = nil;
    }
    
    NSNumber *fontSize = dictionary[sizeKey];
    if (![fontSize isKindOfClass:[NSNumber class]]) {
        fontSize = nil;
    }
    
    NSNumber *fontStyle = dictionary[styleKey];
    if (![fontStyle isKindOfClass:[NSString class]]) {
        fontStyle = nil;
    }
    
    UIFont *font = [RCTFont updateFont:baseFont withFamily:fontFamily size:fontSize weight:fontWeight style:fontStyle variant:nil scaleMultiplier:1];
    
    if (font && (fontStyle || fontWeight || fontSize || fontFamily)) {
        [textAttributes setObject:font forKey:NSFontAttributeName];
    }
    
    return textAttributes;
}


RCT_EXPORT_METHOD(showToastWithTitle:(NSString *)title subtitle:(NSString *)subtitle config:(id)config)
{
    TSCToastView *toastNotification = [TSCToastView toastNotificationWithTitle:title message:subtitle image:nil];
    
    if ([config isKindOfClass:[NSDictionary class]]) {
        if (config[@"backgroundColor"]) {
            UIColor *backgroundColor = [RCTConvert UIColor:config[@"backgroundColor"]];
            toastNotification.backgroundColor = backgroundColor;
        }
        
        toastNotification.titleAttributes = [self textAttributesFromDictionary:config withPrefix:@"titleText" baseFont:[UIFont boldSystemFontOfSize:18]];
        toastNotification.subTitleAttributes = [self textAttributesFromDictionary:config withPrefix:@"subtitleText" baseFont:[UIFont systemFontOfSize:16]];
        
        if (config[@"padding"] && [config[@"padding"] isKindOfClass:[NSDictionary class]]) {
            toastNotification.padding = [RCTConvert UIEdgeInsets:config[@"padding"]];
        }
        
        if (config[@"titleSpacing"] && [config[@"titleSpacing"] isKindOfClass:[NSNumber class]]) {
            toastNotification.titleSpacing = [RCTConvert CGFloat:config[@"titleSpacing"]];
        }
        
        if (config[@"duration"] && [config[@"duration"] isKindOfClass:[NSNumber class]]) {
            toastNotification.visibleDuration = [RCTConvert CGFloat:config[@"duration"]];
        }
    }
    
    
    [[TSCToastNotificationController sharedController] displayToastNotificationView:toastNotification];
}

@end
