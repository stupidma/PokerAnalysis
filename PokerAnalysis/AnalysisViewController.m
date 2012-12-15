//
//  AnalysisViewController.m
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-25.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import "AnalysisViewController.h"
#import "DataOp.h"
#import "config.h"

@interface AnalysisViewController ()

@end

@implementation AnalysisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayWithPlayerName:(NSString *)_name playerID:(int)_id {
    assert( _name );
    assert( _id );
    
    NSArray *preflopData = [DataOp dataWithStage:PREFLOP];
    NSArray *postflopData = [DataOp postflopDataWithPlayerName:_name playerID:_id];
    NSArray *turnData = [DataOp turnDataWithPlayerName:_name playerID:_id];
    NSArray *riverData = [DataOp riverDataWithPlayerName:_name playerID:_id];
    
    NSArray *playerPreData = [self analysis:preflopData];
    
    preCheck.text = [preflopData objectAtIndex:0];
}

- (NSArray *) analysis:(NSArray *)_data {
    assert( _data );
    
    
}
@end
