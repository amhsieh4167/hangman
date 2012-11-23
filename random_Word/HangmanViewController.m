//
//  HangmanViewController.m
//  random_Word
//
//  Created by Alex Hsieh on 11/15/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import "HangmanViewController.h"
#import "Constants.h"
#import "WordLabel.h"
#import "AlphabetLabel.h"

@interface HangmanViewController ()
{
    NSInteger score;
    NSInteger misses;
}

@property (strong, nonatomic) NSString* randomWord;
@property (strong, nonatomic) IBOutlet UILabel *oRandomWordLabel;

@property (strong, nonatomic) NSString* currentGuess;

@property (retain, nonatomic) UIView *alphabetsView;
@property (retain, nonatomic) UIView *randomWordView;

- (IBAction)getRandomWordButton:(UIButton *)sender;

@end

@implementation HangmanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self drawAlphabetLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_currentGuess release];
    [_randomWord release];
    [_oRandomWordLabel release];
    [_alphabetsView release];
    [_randomWordView release];
    [super dealloc];
}

- (IBAction)getRandomWordButton:(UIButton *)sender
{
   [self resetWordLabels];
    score = 0;
    misses = 0;
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.wordnik.com//v4/words.json/randomWord?hasDictionaryDef=true&includePartOfSpeech=noun&maxLength=8&minCorpusCount=100000&minLength=6&api_key=ccf8c3f681887211b316a0aaba9013d03b1baf16f97d16359"]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init]
           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
                 {
                     _randomWord = [[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] valueForKey:@"word"] uppercaseString];
                     
                     //must retain here, otherwise the value would be lost in the main queue
                     [_randomWord retain];
                     dispatch_async(dispatch_get_main_queue(), ^
                             {
                                 // on main queue
                                 self.oRandomWordLabel.text = _randomWord;
                                 [self drawRandomWordLabels];
                             });
                 }];
}


#pragma mark UIEvents


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touch = [[touches anyObject] locationInView:self.alphabetsView];
    
    for (AlphabetLabel* label in _alphabetsView.subviews) {
        if(CGRectContainsPoint(label.frame, touch)) {
            if (!label.isUsed) {
                [label setToFade];
                self.currentGuess = label.text;
                [self compareGuess];
            }
        }
    }

}

-(void)compareGuess
{
    BOOL noMatch = true;
    for(WordLabel* label in self.randomWordView.subviews) {
        if([label.labelFront.text isEqualToString: self.currentGuess]) {
            [label flipToFront];
            score++;
            noMatch = false;
        }
    }
    
    if(noMatch) {
        misses++;
    }
    [self checkIfGameShouldEnd];
}

-(void)checkIfGameShouldEnd
{
    if(score == [_randomWord length]) {
        NSLog(@"you win!");
    }
    else if (misses == 10) {
        NSLog(@"game over");
    }
}


#pragma mark label methods


-(void)resetWordLabels
{
    for(WordLabel* label in _randomWordView.subviews)
    {
        [label removeFromSuperview];
    }
    
    for(AlphabetLabel* label in _alphabetsView.subviews) {
        if (label.isUsed) {
            [label setToDefault];
        }
    }
}

-(void)drawAlphabetLabels
{
    NSString* alphabetsString = [[NSString alloc] initWithString:@"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"];
    NSMutableArray* alphabetsArray = [[alphabetsString componentsSeparatedByString:@","] mutableCopy];
    
    CGFloat containerWidth = kAlphabetLabelWidth*2;
    CGFloat containerHeight = kAlphabetLabelHeight*13;
    
    _alphabetsView = [[UIView alloc] initWithFrame:CGRectMake(260.0f, 14.0f, containerWidth, containerHeight)];
    [self.view addSubview:_alphabetsView];
    
    CGFloat mCurrentX = 0.0f;
    CGFloat mCurrentY = 0.0f;
    CGFloat startY = mCurrentY;
    
    int alphabetPosition = 0;
    
    while (mCurrentX + kAlphabetLabelWidth <= containerWidth)
    {
        while ((mCurrentY + kAlphabetLabelHeight <= containerHeight) && (alphabetPosition < 26))
        {
            AlphabetLabel* alphabetLabel = [[AlphabetLabel alloc] initWithFrame:CGRectMake(mCurrentX, mCurrentY, kAlphabetLabelWidth, kAlphabetLabelHeight) andText:alphabetsArray[alphabetPosition]];
            
            alphabetLabel.text = alphabetsArray[alphabetPosition];
            alphabetPosition++;
            [_alphabetsView addSubview:alphabetLabel];

            mCurrentY += kAlphabetLabelHeight;
        }
        mCurrentY = startY;
        mCurrentX += kAlphabetLabelWidth;
    }
    [alphabetsString release];
    [alphabetsArray release];
}

-(void)drawRandomWordLabels
{
    int numberOfLetters = [_randomWord length];
    
    CGFloat containerWidth = kRandomWordLabelWidth*numberOfLetters;
    CGFloat containerHeight = kRandomWordLabelHeight;
    
    _randomWordView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - containerWidth)/2, self.view.frame.size.height - kRandomWordLabelHeight, containerWidth, containerHeight)];
    [self.view addSubview:_randomWordView];
    
    CGFloat mCurrentX = 0.0f;
    CGFloat mCurrentY = 0.0f;
    
    for(int i = 0; i < numberOfLetters; i++)
    {
        NSString* randomWordLetter = [NSString stringWithFormat:@"%c", [_randomWord characterAtIndex:i]];
        WordLabel* wordLabel = [[WordLabel alloc] initWithFrame:CGRectMake(mCurrentX, mCurrentY, kRandomWordLabelWidth, kRandomWordLabelHeight) andText:randomWordLetter];
        
        [self.randomWordView addSubview:wordLabel];
        mCurrentX += kRandomWordLabelWidth;
    }
}

@end
