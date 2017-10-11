//
//  NSString+Additions.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 20/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//
//  NSString Additions Category
//

#import <Cocoa/Cocoa.h>

/**
 * A category for adding functionality to the `NSString` class.
 */
@interface NSString (NSStringAdditions)

/**
 * Returns a formatted string representing the given size in bytes.
 *
 * @param size The size to convert to a string.
 * @return A newly created string representing the given byte count.
 */
+ (NSString *)stringForByteCount:(long long)size;

/**
 * Returns an attributed string with given title, color, font and alignment.
 *
 * @param title The title of the new attributed string.
 * @param color The color of the new attributed string.
 * @param font The font used by the new attributed string.
 * @param alignment  The alignment of text in the attributed string.
 * @return A newly created string having the given attributes.
 */
+ (NSAttributedString *)attributedStringWithTitle:(NSString *)title color:(NSColor *)color font:(NSFont *)font alignment:(CTTextAlignment)alignment;

/**
 * Returns a formatted string for the given transfer rate.
 * 
 * @param speed The transfer rate to base the string on.
 * @return A string representing the given speed.
 */
+ (NSString *)stringForSpeed:(CGFloat)speed;
+ (NSString *)stringForSpeedAbbrev:(CGFloat)speed;

/**
 * Convert this string to a C string.
 *
 * @param cStringPointer A pointer to a C string. It will point to the converted NSString if the conversion was successful.
 */
- (void)convertToCString:(char *)cStringPointer;

/**
 * Convert this string to an unsigned long long integer.
 *
 * @return An unsigned long long integer, or zero if this string is empty.
 */
- (unsigned long long)unsignedLongLongValue;

/**
 * Checks whether this string is numeric.
 *
 * @return True if and only if this string is numeric.
 */
- (BOOL)isNumeric;

/**
 * Checks whether this string is alphanumeric.
 *
 * @return True if and only if this string is alphanumeric.
 */
- (BOOL)isAlphaNumeric;

/**
 * Checks whether this string is made of whitespace only.
 *
 * @return True if and only if this string only contains whitespace characters.
 */
- (BOOL)isWhitespace;

/**
 * Checks whether this string is empty.
 *
 * @return True if and only if this string has no characters or only whitespace characters.
 */
- (BOOL)isEmpty;

/**
 * Checks if this string contains the given substring.
 *
 * @param string The substring to search for.
 * @return True if and only if this string contains the given substring.
 */
- (BOOL)contains:(NSString *)string;

/**
 * Get the uniform type identifier (UTI) of this string, which is supposed to represent a file path.
 *
 * @return The UTI of this string.
 */
- (NSString *)UTI;

@end
