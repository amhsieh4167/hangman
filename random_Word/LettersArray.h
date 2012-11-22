//
//  LettersArray.h
//  random_Word
//
//  Created by Alex Hsieh on 11/16/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LettersArray : NSArray

@property (nonatomic) NSInteger numberOfLetters;
@property BOOL      isRevealed;

-(NSInteger)location:(NSString*)guessedLetter;

@end
