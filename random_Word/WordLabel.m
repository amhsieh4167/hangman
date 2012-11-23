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
        UIFont* labelFont = [UIFont boldSystemFontOfSize:16];
        NSInteger textAlignment = NSTextAlignmentCenter;
        CGRect labelFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        _labelBack = [[UILabel alloc] initWithFrame:labelFrame];
        _labelBack.textAlignment = textAlignment;
        _labelBack.font = labelFont;
        _labelBack.text = @"_";
        [_labelBack retain];
        
        _labelFront = [[UILabel alloc] initWithFrame:labelFrame];
        _labelFront.textAlignment = textAlignment;
        _labelFront.font = labelFont;
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
                      duration:2.0f
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^{
                        [_labelBack removeFromSuperview];
                        [self addSubview:_labelFront];
                        _isRevealed = YES;
                    }
                    completion:NULL];
}

-(void)flipToBack
{
    [UIView transitionWithView:self
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^{
                        [_labelFront removeFromSuperview];
                        [self addSubview:_labelBack];
                        _isRevealed = NO;
                    }
                    completion:NULL];
}

@end
