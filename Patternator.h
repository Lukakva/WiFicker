//
//  PatternGenerator.h
//  WiFi
//
//  Created by Luka Kvavilashvili on 1/7/16.
//  Copyright (c) 2016 Luka Kvavilashvili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Patternator : NSObject

// array cntains strings which will be permutated
// action parameter will be called for every permutation
+ (void)generatePatternsFromArray:(NSArray *)array length:(int)length action:(void (^)(NSString *string, BOOL *shouldContinue))action;


@end
