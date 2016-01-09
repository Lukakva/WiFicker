//
//  Patternator.m
//  WiFi
//
//  Created by Luka Kvavilashvili on 1/7/16.
//  Copyright (c) 2016 Luka Kvavilashvili. All rights reserved.
//

#import "Patternator.h"

@implementation Patternator

// function which increases indexed element in array (which is an int) by 1
// and if it is higher than the MAX value, it increases next slot (just like counting)
// but not in decimal but in count system where max number is max parameter
+ (void)increaseIndex:(NSMutableArray *)arr index:(unsigned long)index max:(unsigned long)max {
    // just in case
    if (index >= arr.count) {
        return;
    }
    
    // get the value
    NSNumber *value = [arr objectAtIndex:index];
    // since nsnumber is immutable, just take the int value and create new NSNumber
    NSNumber *newValue = [NSNumber numberWithInt:[value intValue] + 1];
    
    // replace the value
    [arr replaceObjectAtIndex:index withObject:newValue];
    
    // if value exceeded the max parameter
    if ([newValue intValue] > max) {
        // set current value to 0
        [arr replaceObjectAtIndex:index withObject:@0];
        // and increase next slot (previous one)
        // in case if index - 1 is negative, unsigned long index will be really big
        // that's why we need the if statement above
        [self increaseIndex:arr index:index - 1 max:max];
    }
}

+ (void)generatePatternsFromArray:(NSArray *)array length:(int)length action:(void (^)(NSString *string, BOOL *shouldContinue))action {
    // logic of this function
    // we have an array called pattersnWithNumber
    // at the beginning it's array of specific length (specified by length argument)
    // so it consits of 0's [@0, @0, @0, @0, @0];
    // then what happens is that we loop thru count of possible numberOfPermutations
    // and for each one, we use this patternsWithNumber array to create string
    // we take each letter from characters array based on pattersWithNumber and
    // then increase the value of patternsWithNumber by 1
    // to [@0, @0, @0, @0, @1]; but since no value of this array has to exceed the count of characters array
    // we used function increaseIndex which takes care of it

    // create mutable array
    NSMutableArray *patternsWithNumber = [NSMutableArray arrayWithCapacity:length];
    // fill it with 0's
    for (int i = 0; i < length; i++) {
        [patternsWithNumber insertObject:@0 atIndex:i];
    }
    
    // formula to calculate the number of permutations is
    // count of characters (elements) ^ length of string
    NSUInteger numberOfPermutations = pow(array.count, length);
    
    for (int i = 0; i < numberOfPermutations; i++) {
        // create permutation string
        NSString *permutation = @"";
        
        // loop thru current values of pattersnWithNumber
        for (int k = 0; k < patternsWithNumber.count; k++) {
            // add character from characters array based on patternsWithNumber's value on current index
            int characterIndex = [[patternsWithNumber objectAtIndex:k] intValue];
            permutation = [permutation stringByAppendingString:[array objectAtIndex:characterIndex]];
        }
        
        BOOL shouldContinueBool = YES;

        // call the action function with permutation string
        action(permutation, &shouldContinueBool);
        // unset the reference to permutation string
        permutation = nil;
        
        if (!shouldContinueBool) break;
        
        // increase the value of pattersnWithNumber
        [self increaseIndex:patternsWithNumber index:patternsWithNumber.count - 1 max:array.count - 1];
    }
}

@end
