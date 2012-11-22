//
//  AlphabetLabel.m
//  random_Word
//
//  Created by Alex Hsieh on 11/16/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import "AlphabetLabel.h"

@implementation AlphabetLabel
{
    UILabel* defaultLabel;
    UILabel* usedLabel;
}

- (id)initWithFrame:(CGRect)frame andText:(NSString*)alphabet
{
    self = [super initWithFrame:frame];
    if (self) {
        UIFont* labelFont = [UIFont boldSystemFontOfSize:16];
        NSInteger textAlignment = NSTextAlignmentCenter;
        CGRect labelFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        defaultLabel = [[UILabel alloc] initWithFrame:labelFrame];
        defaultLabel.textColor = [UIColor blackColor];
        defaultLabel.font = labelFont;
        defaultLabel.textAlignment = textAlignment;
        defaultLabel.text = alphabet;
        [defaultLabel retain];
        
        usedLabel = [[UILabel alloc] initWithFrame:labelFrame];
        usedLabel.textColor = [UIColor grayColor];
        usedLabel.font = labelFont;
        usedLabel.textAlignment = textAlignment;
        usedLabel.text = alphabet;
        [usedLabel retain];
        
        [self addSubview:defaultLabel];
    }
    return self;
}

-(void)setToDefault
{
    [UIView transitionWithView:self
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^{
                        [usedLabel removeFromSuperview];
                        [self addSubview:defaultLabel];
                        _isUsed = NO;
                    }
                    completion:NULL];
}

-(void)setToFade
{
    [UIView transitionWithView:self
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^{
                        [defaultLabel removeFromSuperview];
                        [self addSubview:usedLabel];
                        _isUsed = YES;
                    }
                    completion:NULL];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    
//}


@end
