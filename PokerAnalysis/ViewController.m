//
//  ViewController.m
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-21.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import "ViewController.h"
#import "AnalysisViewController.h"
#import "MemberViewController.h"
#import "config.h"
#import "DataOp.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize players = _players;
@synthesize membController = _membController;
@synthesize seatView = _seatView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.reCtrl = [[RecordViewController alloc] init];
//    self.anCtrl = [[AnalysisViewController alloc] init];
//    self.mebCtrl = [[MemberViewController alloc] init];
    gameState = 0;  // 0 -- initial; 1 -- set player; 2 -- gaming
    
    
    
    self.players = [NSMutableArray array];
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:22];
    btn.hidden = YES;
    
    [DataOp createTable];
    
    _membController = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:nil];
    _membController.delegate = self;
    
//    self.view = _seatView;
    [self.view insertSubview:_seatView atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemorWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
//    self.reCtrl = nil;
//    self.anCtrl = nil;
//    self.mebCtrl = nil;
    _players = nil;
    _membController = nil;
    _seatView = nil;
    
    [super dealloc];
}

#pragma mark - selector
//- (IBAction) textFieldDoneEditing:(id)sender {
//    [sender resignFirstResponder];
//    
//    if ( nameFiled.text.length > 0 ) {
//        NSString *name = [NSString stringWithFormat:@"%@", nameFiled.text];
//        UIButton *btn = (UIButton *)[self.view viewWithTag:playerNum];
//        [btn setTitle:name forState:0];
//
//    }
//    setView.hidden = YES;
//}
//- (IBAction) recorder:(id)sender {
//
//}
//
//- (IBAction) member:(id)sender {
//    
//}
//
//- (IBAction) analysis:(id)sender {
//    
//}

- (IBAction) sitDown:(id)sender {
    gameState = 1;
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:22];
    btn.hidden = NO;
}

- (IBAction) setPlayer:(id)sender {
    if ( gameState != 1 ) {
        return;
    }
    
    NSLog( @"setPlayer tag = %d", [sender tag] );
    
    playerNum = [sender tag];
    
//    setView.hidden = NO;
//    [self.view addSubview:_membController];

    [_seatView removeFromSuperview];
    [self.view insertSubview:_membController.view atIndex:0];
}

- (IBAction) start:(id)sender {
    
}

- (IBAction) setPlyerComplete:(id)sender {
    gameState = 2;
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:22];
    btn.hidden = YES;
}

#pragma mark - delegate
- (void) cancelMemberView {
    [_membController.view removeFromSuperview];
    [self.view insertSubview:_seatView atIndex:0];
}

- (void) selectedPlayer:(NSString *)_name id:(int)_id {
    NSLog( @"ViewController:selectedPlayer in" );
    
    assert( _name );
    
    struct PLAYER_INFO p;
    p.player_name = [_name copy];
    p.player_id = _id;
    p.seat_num = playerNum;
    
//    _PLAYER_INFO *p = (_PLAYER_INFO *)malloc(sizeof(_PLAYER_INFO));
//    p->player_name = [_name copy];
//    p->player_id = _id;
//    p->seat_num = playerNum;
    [_players addObject:[NSData dataWithBytes:&p length:sizeof(_PLAYER_INFO)]];
//    [_players insertObject:[NSData dataWithBytes:&p length:sizeof(_PLAYER_INFO)] atIndex:playerNum];
    
    UIButton *btn = (UIButton *)[_seatView viewWithTag:playerNum];
    [btn setTitle:_name forState:UIControlStateNormal];
//    btn.titleLabel.text = _name;
}
@end
