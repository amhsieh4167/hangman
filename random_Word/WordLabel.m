//
//  WordLabel.m
//  random_Word
//
//  Created by Alex Hsieh on 11/16/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import "WordLabel.h"

@interface WordLabel ()
@property (retain, nonatomic) NSArray* anArray;
@end

@implementation WordLabel

- (id)initWithFrame:(CGRect)frame andText:(NSString*)alphabet
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect labelFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIColor* labelColor = [UIColor clearColor];
        NSInteger textAlignment = NSTextAlignmentCenter;
        UIColor* textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gold.jpg"]];
        
        _labelBack = [[UILabel alloc] initWithFrame:labelFrame];
        _labelBack.backgroundColor = labelColor;
        _labelBack.textAlignment = textAlignment;
        _labelBack.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:30];
        _labelBack.textColor = textColor;
        _labelBack.text = @"__";
        [_labelBack retain];
        
        _labelFront = [[UILabel alloc] initWithFrame:labelFrame];
        _labelFront.backgroundColor = labelColor;
        _labelFront.textAlignment = textAlignment;
        _labelFront.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:35];
        _labelFront.textColor = textColor;
        _labelFront.text = alphabet;
        [_labelFront retain];
        
        [self addSubview:_labelBack];
    }
    return self;
}

- (void)dealloc
{
    [_labelFront release];
    [_labelBack release];
    [super dealloc];
}

-(void)flipToFront
{
    [UIView transitionWithView:self
                      duration:kAnimateDuration
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^{
                        [_labelBack removeFromSuperview];
                        [self addSubview:_labelFront];
                        _isRevealed = YES;
                    }
                    completion:nil];
}

-(void)flipToBack
{
    [UIView transitionWithView:self
                      duration:kAnimateDuration
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^{
                        [_labelFront removeFromSuperview];
                        [self addSubview:_labelBack];
                        _isRevealed = NO;
                    }
                    completion:nil];
}

@end
