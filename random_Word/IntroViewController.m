//
//  ViewController.m
//  random_Word
//
//  Created by Alex Hsieh on 11/15/12.
//  Copyright (c) 2012 Alex Hsieh. All rights reserved.
//

#import "IntroViewController.h"
#import "HangmanViewController.h"

@interface IntroViewController ()
-(IBAction)startHangman:(UIButton* )sender;
-(IBAction)showHighScore:(UIButton* )sender;

@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startHangman:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"HangmanSegue" sender:self];
}

-(IBAction)showHighScore:(UIButton* )sender
{
    [self performSegueWithIdentifier:@"HighScoresSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"HangmanSegue"]) {
        
        [[segue destinationViewController] startGame];
    }
}

@end
