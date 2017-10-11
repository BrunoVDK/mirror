//
//  IntegerFormatter.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 31/05/15.
//  Copyright (c) 2015 Bruno Vandekerkhove. All rights reserved.
//
//  This subclass can be used to allow only integers in a text field.
//      It doesn't alert when the maximum value is surpassed.
//

#import "IntegerFormatter.h"
#import "NSString+Additions.h"

#pragma mark Integer Formatter

@implementation IntegerFormatter

#define pragma mark Delegate

// Methods in case the integer formatter is to handle invalid input (by preventing dialog from popping up etc.)

- (BOOL)control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error {
    
    NSTextField *field = (NSTextField *)control;
    [self updateTextValue:field];
    
    return true; // To suppress dialog
    
}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
        
    NSTextField *field = (NSTextField *)[notification object];
    [self updateTextValue:field];
    
}

- (void)updateTextValue:(NSTextField *)field {
    
    long integerValue = field.integerValue;
    if (integerValue < self.minimum.integerValue || integerValue > self.maximum.integerValue) {
        
        NSDictionary *bindingInfo = [field infoForBinding:NSValueBinding];
        
        // Crude code to restore default, renders this class rather specific to this application
        id observedObject = [bindingInfo valueForKey:NSObservedObjectKey];
        NSString *keyPath = [bindingInfo valueForKey:NSObservedKeyPathKey];
        NSString *newValue = self.minimum.stringValue;
        if ([observedObject isKindOfClass:[NSUserDefaultsController class]]) {
            [(NSUserDefaultsController *)observedObject setValue:nil forKeyPath:keyPath];
            NSString *defaultValue = [[[NSUserDefaultsController sharedUserDefaultsController] valueForKeyPath:keyPath] stringValue];
            if (defaultValue)
                newValue = defaultValue;
            else
                [(NSUserDefaultsController *)observedObject setValue:newValue forKeyPath:keyPath]; // Enforce minimum
        }
        
        [[bindingInfo valueForKey:NSObservedObjectKey] setValue:newValue forKeyPath:keyPath]; // Manually update bound key if any
        [field setStringValue:newValue];
        
    }
    
}

#pragma mark Partial String Validation

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr
       proposedSelectedRange:(NSRangePointer)proposedSelRangePtr
              originalString:(NSString *)origString
       originalSelectedRange:(NSRange)origSelRange
            errorDescription:(NSString **)error {
    
    if ([*partialStringPtr length] > 0) {
        
        if (![*partialStringPtr isNumeric])
            NSBeep();
        else if ([*partialStringPtr longLongValue] > [[self maximum] longLongValue])
            *partialStringPtr = [self.maximum stringValue];
        // else if ([*partialStringPtr longLongValue] < [[self minimum] longLongValue])
            // return false; // *partialStringPtr = [self.minimum stringValue];
        else
            return true;
        
        proposedSelRangePtr->length = 0;
        proposedSelRangePtr->location = [*partialStringPtr length]; // Brings the cursor to the end of the string
        
        return false;
        
    }
    
    return true;
    
}

@end