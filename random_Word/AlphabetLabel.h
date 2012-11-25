//
//  AlphabetLabel.h
//  random_Word
//
//  Created by Alex Hsieh on 11/16/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import "WordLabel.h"

@interface AlphabetLabel : WordLabel

@property(nonatomic, strong) UILabel* unusedLabel;
@property(nonatomic, strong) UILabel* usedLabel;
@property(nonatomic, readonly)BOOL isUsed;

-(void)setToDefault;
-(void)setToFade;

@end
