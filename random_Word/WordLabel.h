//
//  WordLabel.h
//  random_Word
//
//  Created by Alex Hsieh on 11/16/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#define kAnimateDuration 1.0f
#import <UIKit/UIKit.h>

@interface WordLabel : UILabel

@property(nonatomic, strong) UILabel* labelFront;
@property(nonatomic, strong) UILabel* labelBack;
@property(nonatomic, readonly)BOOL isRevealed;

- (id)initWithFrame:(CGRect)frame andText:(NSString*)alphabet;
-(void)flipToFront;
-(void)flipToBack;

@end
