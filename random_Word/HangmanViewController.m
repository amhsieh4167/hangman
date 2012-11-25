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
#import "HangmanImageView.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface HangmanViewController () <UIAlertViewDelegate>
{
    NSInteger score;
    NSInteger misses;
}

@property (strong, nonatomic) NSString* randomWord;

@property (strong, nonatomic) NSString* currentGuess;

@property (retain, nonatomic) UIView *alphabetsView;
@property (retain, nonatomic) UIView *randomWordView;

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
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"highscore"];
//    [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
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
    [_alphabetsView release];
    [_randomWordView release];
    [super dealloc];
}

-(void)startGame
{
    [self drawAlphabetLabels];
    [self getRandomWord];
}


#pragma mark Game logics


-(void)getRandomWord
{
    // get a new word from wordnic
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.wordnik.com//v4/words.json/randomWord?hasDictionaryDef=true&includePartOfSpeech=noun&maxLength=8&minCorpusCount=100000&minLength=6&api_key=ccf8c3f681887211b316a0aaba9013d03b1baf16f97d16359"]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         _randomWord = [[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] valueForKey:@"word"] uppercaseString];
         
         //must retain here, otherwise the value would be lost in the main queue
         [_randomWord retain];
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            // on main queue
                            NSLog(@"random word is %@", _randomWord);
                            [self drawRandomWordLabels];
                        });
     }];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touch = [[touches anyObject] locationInView:self.alphabetsView];
    
    for (AlphabetLabel* label in _alphabetsView.subviews) {
        if(CGRectContainsPoint(label.frame, touch)) {
            if (!label.isUsed) {
                [label setToFade];
                self.currentGuess = label.unusedLabel.text;
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
    [self drawHangman];
}

-(void)showAlertWithTitle:(NSDictionary*)titleAndTwitterPrompt
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:[titleAndTwitterPrompt valueForKey:@"title"]
                                                        message:@"Play Again?"
                                                       delegate:self
                                              cancelButtonTitle:@"No, I need a nap"
                                              otherButtonTitles:@"Sure, I have no life.",
                                                                [titleAndTwitterPrompt valueForKey:@"twitter prompt"], nil];
    alertView.tag = GameEndAlertView;
    [alertView show];
    [alertView release];
}

-(void)checkIfGameShouldEnd
{
    NSDictionary* titleAndTwitterPrompt;
    if(score == [_randomWord length]) {
        titleAndTwitterPrompt = @{ @"title":@"You've won", @"twitter prompt":@"Brag about it!" };
        [self performSelector:@selector(showAlertWithTitle:) withObject:titleAndTwitterPrompt afterDelay:kAnimateDuration];
        


//        I had NSString before and I could release. Not sure why I can't release NSDictionary here'
//        [titleAndTwitterPrompt release];
    }
    else if (misses == kMaximumGuess) {
        titleAndTwitterPrompt = @{@"title":@"You've lost", @"twitter prompt":@"Internet will comfort you!"};
        [self performSelector:@selector(showAlertWithTitle:) withObject:titleAndTwitterPrompt afterDelay:kAnimateDuration];
//        [titleAndTwitterPrompt release];
    }
}

-(void)saveToUserDefault
{
    NSMutableArray* topTenScores;
    NSDictionary* currentScore;
    
    currentScore = @{
    @"numberOfMisses":[NSNumber numberWithInteger:misses],
    @"timeStamp":[NSDate date] };
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"]) {
        topTenScores = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
        
        for(int i=0; i < [topTenScores count]; i++) {
            if(misses < [[topTenScores[i] valueForKey:@"numberOfMisses"] integerValue]) {
                [topTenScores insertObject:currentScore atIndex:i];
                [topTenScores removeLastObject];
                i = [topTenScores count]; // exit loop
            }
            else if([topTenScores count] < kMaximumNumberOfStoredHighScore) {
                [topTenScores insertObject:currentScore atIndex:i];
                i = [topTenScores count]; // exit loop
            }
        }
    }
    else {
        topTenScores = [[NSMutableArray alloc] initWithObjects:currentScore, nil];
    }
    [[NSUserDefaults standardUserDefaults] setValue:topTenScores forKey:@"highscore"];
}


#pragma mark draw labe and hangmanImageView methods


-(void)resetGame
{
    score = 0;
    misses = 0;
    
    for(WordLabel* label in _randomWordView.subviews)
    {
        [label removeFromSuperview];
    }
    
    for(AlphabetLabel* label in _alphabetsView.subviews) {
        if (label.isUsed) {
            [label setToDefault];
        }
    }
    
    for(UIImageView* imageView in self.view.subviews) {
        if ([imageView isMemberOfClass: [HangmanImageView class]] && imageView.alpha == 1) {
            [UIView animateWithDuration:kAnimateDuration animations:^{imageView.alpha = 0;}];
        }
    }
    
    [self getRandomWord];
}

-(void)drawHangman
{
    for(UIImageView* imageView in self.view.subviews) {
        if(imageView.tag == misses) {
            [UIView animateWithDuration:kAnimateDuration animations:^{imageView.alpha = 1;}];
        }
    }
}

-(void)drawAlphabetLabels
{
    NSString* alphabetsString = [[NSString alloc] initWithString:@"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"];
    NSMutableArray* alphabetsArray = [[alphabetsString componentsSeparatedByString:@","] mutableCopy];
    
    CGFloat containerWidth = kAlphabetLabelWidth*13;
    CGFloat containerHeight = kAlphabetLabelHeight*2;
    
    _alphabetsView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - containerWidth)/2, self.view.frame.size.height - containerHeight, containerWidth, containerHeight)];
    [self.view addSubview:_alphabetsView];
    
    CGFloat mCurrentX = 0.0f;
    CGFloat mCurrentY = 0.0f;
    CGFloat startX = mCurrentX;
    
    int alphabetPosition = 0;
    
    while (mCurrentY + kAlphabetLabelHeight <= containerHeight)
    {
        while (mCurrentX + kAlphabetLabelWidth <= containerWidth)
        {
            AlphabetLabel* alphabetLabel = [[AlphabetLabel alloc] initWithFrame:CGRectMake(mCurrentX, mCurrentY, kAlphabetLabelWidth, kAlphabetLabelHeight) andText:alphabetsArray[alphabetPosition]];
            
            alphabetLabel.backgroundColor = [UIColor clearColor];
            alphabetPosition++;
            [_alphabetsView addSubview:alphabetLabel];
            
            mCurrentX += kAlphabetLabelWidth;
        }
        mCurrentY += kAlphabetLabelHeight;
        mCurrentX = startX;
    }
    [alphabetsString release];
    [alphabetsArray release];
}

-(void)drawRandomWordLabels
{
    int numberOfLetters = [_randomWord length];
    
    CGFloat containerWidth = kRandomWordLabelWidth*numberOfLetters;
    CGFloat containerHeight = kRandomWordLabelHeight;
    
    _randomWordView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - containerWidth)/2, self.view.frame.size.height - (kAlphabetLabelHeight*2 + kRandomWordLabelHeight), containerWidth, containerHeight)];
    [self.view addSubview:_randomWordView];
    
    CGFloat mCurrentX = 0.0f;
    CGFloat mCurrentY = 0.0f;
    
    for(int i = 0; i < numberOfLetters; i++)
    {
        NSString* randomWordLetter = [NSString stringWithFormat:@"%c", [_randomWord characterAtIndex:i]];
        WordLabel* wordLabel = [[WordLabel alloc] initWithFrame:CGRectMake(mCurrentX, mCurrentY, kRandomWordLabelWidth, kRandomWordLabelHeight) andText:randomWordLetter];
        wordLabel.backgroundColor = [UIColor clearColor];
        [self.randomWordView addSubview:wordLabel];
        mCurrentX += kRandomWordLabelWidth;
    }
}


#pragma mark social service methods


-(void)postToTwitter
{
    SLComposeViewController* mySLComposerSheet;
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        mySLComposerSheet = [[SLComposeViewController alloc] init];
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        if (misses == kMaximumGuess) {
            [mySLComposerSheet setInitialText:@"I lost a game Hangman"];
         } else {
             [mySLComposerSheet setInitialText:@"Hey I just won at life"];
         }
        
        
        CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGContextRef ctx = CGBitmapContextCreate(nil, screenSize.width, screenSize.height, 8, 4*(int)screenSize.width, colorSpaceRef, kCGImageAlphaPremultipliedLast);
        CGContextTranslateCTM(ctx, 0.0, screenSize.height);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        
        [(CALayer*)self.view.layer renderInContext:ctx];
        
        CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
        UIImage *twitterImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        CGContextRelease(ctx);
        [mySLComposerSheet addImage:twitterImage];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *title;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                title = @"I am too humble to boast";
                break;
            case SLComposeViewControllerResultDone:
                title = @"The World knows I am awesome!";
                break;
            default:
                break;
        } //check if everythink worked properly. Give out a message on the state.
        [self dismissViewControllerAnimated:YES completion:nil];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:@"Play Again?" delegate:self cancelButtonTitle:@"Nah, I need a nap" otherButtonTitles:@"Sure I have no life", nil];
        alertView.tag = TwitterAlertView;
        [alertView show];
        [alertView release];
    }];
//    why can't release here?'
//    [mySLComposerSheet release];
}


#pragma mark UIAlertViewDelegate


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == GameEndAlertView) {
        switch (buttonIndex) {
            case 0:
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            case 1:
                [self resetGame];
                break;
            case 2:
                [self postToTwitter];
                break;
            default:
                break;
        }
    } else if (alertView.tag == TwitterAlertView) {
        switch (buttonIndex) {
            case 0:
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            case 1:
                [self resetGame];
                break;
            default:
                break;
        }
    }
}

@end

//-(void)drawAlphabetLabels
//{
//    NSString* alphabetsString = [[NSString alloc] initWithString:@"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"];
//    NSMutableArray* alphabetsArray = [[alphabetsString componentsSeparatedByString:@","] mutableCopy];
//
//    CGFloat containerWidth = kAlphabetLabelWidth*13;
//    CGFloat containerHeight = kAlphabetLabelHeight*2;
//
//    _alphabetsView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - containerWidth)/2, self.view.frame.size.height - containerHeight, containerWidth, containerHeight)];
//    [self.view addSubview:_alphabetsView];
//
//    CGFloat mCurrentX = 0.0f;
//    CGFloat mCurrentY = 0.0f;
//    CGFloat startY = mCurrentY;
//
//    int alphabetPosition = 0;
//
//    while (mCurrentX + kAlphabetLabelWidth <= containerWidth)
//    {
//        while (mCurrentY + kAlphabetLabelHeight <= containerHeight)
//        {
//            AlphabetLabel* alphabetLabel = [[AlphabetLabel alloc] initWithFrame:CGRectMake(mCurrentX, mCurrentY, kAlphabetLabelWidth, kAlphabetLabelHeight) andText:alphabetsArray[alphabetPosition]];
//
//            alphabetLabel.backgroundColor = [UIColor clearColor];
//            alphabetPosition++;
//            [_alphabetsView addSubview:alphabetLabel];
//
//            mCurrentY += kAlphabetLabelHeight;
//        }
//        mCurrentY = startY;
//        mCurrentX += kAlphabetLabelWidth;
//    }
//    [alphabetsString release];
//    [alphabetsArray release];
//}
