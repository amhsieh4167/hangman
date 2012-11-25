//
//  AlphabetLabel.m
//  random_Word
//
//  Created by Alex Hsieh on 11/16/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import "AlphabetLabel.h"

@implementation AlphabetLabel

- (id)initWithFrame:(CGRect)frame andText:(NSString*)alphabet
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect labelFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIColor* labelColor = [UIColor clearColor];
        UIFont* labelFont = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
        NSInteger textAlignment = NSTextAlignmentCenter;

        
        _unusedLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _unusedLabel.backgroundColor = labelColor;
        _unusedLabel.font = labelFont;
        _unusedLabel.textAlignment = textAlignment;
        _unusedLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gold.jpg"]];
        _unusedLabel.text = alphabet;
        [_unusedLabel retain];
        
        _usedLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _usedLabel.backgroundColor = labelColor;
        _usedLabel.font = labelFont;
        _usedLabel.textAlignment = textAlignment;
//        _usedLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rusted-metal-pattern.jpg"]];
        _usedLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"metal.jpg"]];
        _usedLabel.text = alphabet;

        [_usedLabel retain];
        
        [self addSubview:_unusedLabel];
    }
    return self;
}

-(void)setToDefault
{
    [UIView transitionWithView:self
                      duration:kAnimateDuration
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^{
                        [_usedLabel removeFromSuperview];
                        [self addSubview:_unusedLabel];
                        _isUsed = NO;
                    }
                    completion:nil];
}

-(void)setToFade
{
    [UIView transitionWithView:self
                      duration:kAnimateDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^{
                        [_unusedLabel removeFromSuperview];
                        [self addSubview:_usedLabel];
                        _isUsed = YES;
                    }
                    completion:nil];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    
//}


@end
