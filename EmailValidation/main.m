//
//  main.m
//  EmailValidation


#import <Foundation/Foundation.h>


int main(int argc, const char * argv[]) {
    @autoreleasepool {
    
    NSString *line = @"\"very.unusual.@.unusual.com\"@example.com";
        
        BOOL invalid = NO;
    
        NSArray *disallowedCharacters = [NSArray arrayWithObjects: @"(", @")", @",", @":", @";", @"<", @">", @"[", @"\\", @"]", @"@", nil];
        
        BOOL containsAtSign = NO;
        NSInteger indexOfAtSign = 0;

        
        BOOL containsDot = NO;
        NSInteger indexOfDot = 0;
        
        BOOL containsAtBeforeDot = NO;
        
        BOOL containsSpaces = NO;
        
        BOOL containsUnevenNumberOfQuotes = NO;
        
        
        // finds spaces
        NSArray *spaceSepArray = [line componentsSeparatedByString:@" "];
        
        if (spaceSepArray.count > 1) {
            containsSpaces = YES;
        }
            // look for quatations
        NSArray *quoteSepArray = [line componentsSeparatedByString: @"\""];
            
        if (quoteSepArray.count % 2 == 0) {
            containsUnevenNumberOfQuotes = YES;
            invalid = YES;
        }
        
    
        // do all the stuff to check the rest
        
        NSInteger i = 0;
        for (i = 0; i < line.length; i++) {
            NSString *charString = [NSString stringWithFormat:@"%c", [line characterAtIndex:i]];
            
            if ([charString isEqualToString:@"."]) {
                // index of final .
                indexOfDot = i;
                containsDot = YES;
            }
            // check for dot seperated strings or
            else if ([charString isEqualToString:@"\""]) {
                if (i != 0) {
                    NSString *indexBeforeI = [NSString stringWithFormat:@"%c", [line characterAtIndex:i - 1]];
                    NSString *indexAfterI = [NSString stringWithFormat:@"%c", [line characterAtIndex:i + 1]];
                    
                    if (![indexBeforeI isEqualToString:@"."] && ![indexAfterI isEqualToString:@"."] && ![indexAfterI isEqualToString:@"@"]) {
                        invalid = YES;
                    }
                }
            }
            else if ([disallowedCharacters containsObject: charString]) {
                // check for surrounding Quotations
                BOOL quoteBefore = NO;
                BOOL quoteAfter = NO;
                
                NSInteger m = i;
                for (m = i - 1; m > -1; m --) {
                    NSString *charAtIndexM = [NSString stringWithFormat:@"%c", [line characterAtIndex:m]];
                    if ([charAtIndexM isEqualToString:@"\""]) {
                        quoteBefore = YES;
                    }
                }
                
                if(quoteBefore) {
                    NSInteger n = i;
                    for (n = i + 1; n < line.length; n ++) {
                        NSString *charAtIndexN = [NSString stringWithFormat:@"%c", [line characterAtIndex:n]];
                        if ( [charAtIndexN isEqualToString:@"\""]) {
                            quoteAfter = YES;
                            break;
                        }
                    }
                }
                if ([charString isEqualToString:@"@"]) {
                    if (!quoteBefore || !quoteAfter) {
                        if (!containsAtSign) {
                            // index of final @
                            indexOfAtSign = i;
                            containsAtSign = YES;
                        }
                        else {
                            // too many @'s
                            invalid = YES;
                        }
                    }
                }
                else {
                    invalid = YES;
                }
            }
        }
        // check for after last dot
        NSCharacterSet *alphanumericSet = [NSCharacterSet alphanumericCharacterSet];
        NSInteger o = indexOfDot + 1;
        for (o = indexOfDot + 1; o < line.length; o ++) {
            if (![alphanumericSet characterIsMember:[line characterAtIndex:o]]) {
                invalid = YES;
            }
        }
        
        
        if (indexOfAtSign < indexOfDot) {
            containsAtBeforeDot = YES;
        }
    
        
        
        if (containsAtBeforeDot && containsAtSign && containsDot && !invalid) {
            NSLog(@"true");
        }
        else {
            NSLog(@"false");
        }
    
    }
    return 0;
}
