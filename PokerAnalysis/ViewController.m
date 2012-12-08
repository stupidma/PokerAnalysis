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
#import "Players.h"

#import "DataOp.h"

@interface ViewController ()

@end

@implementation ViewController

//@synthesize players = _players;
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
    gameStage = PREFLOP;
    curPlayer = -1;
    
    allPlayers = [[Players alloc] init];
    allPlayers.count = 0;
    
    [DataOp createTable];
    
    _membController = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:nil];
    _membController.delegate = self;
    
//    self.view = _seatView;
    
    [self interfaceInit];
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
//    _players = nil;
    _membController = nil;
    _seatView = nil;
    allPlayers = nil;
    
    [super dealloc];
}

- (void) settingButton {
    startBtn.hidden = YES;
    foldBtn.hidden = YES;
    checkBtn.hidden = YES;
    callBtn.hidden = YES;
    raiseBtn.hidden = YES;
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:22];
    btn.hidden = YES;
}

- (void) gamingButton {
    startBtn.hidden = YES;
    foldBtn.hidden = NO;
    checkBtn.hidden = NO;
    callBtn.hidden = NO;
    raiseBtn.hidden = NO;
}

- (void) interfaceInit {
    [dealerCtrl addTarget:self
                   action:@selector(dealerChanged:)
         forControlEvents:UIControlEventValueChanged];
    dealerCtrl.hidden = NO;
    
    dealer.hidden = NO;
    
    [self settingButton];
}
//- (void) setCurrentPlayer {
//    int count = 0;
//    switch ( gameStage ) {
//        case PREFLOP:
//            count = 3;
//            break;
//        case POSTFLOP:
//        case TURN:
//        case RIVER:
//            count = 1;
//            break;
//        default:
//            assert( nil );
//            break;
//    }
//    
//    int first = 1;
//    for ( int i = dealNum-1; ; i++ ) {
//        if ( i == dealNum-1 && first == 0 ) {
//            assert( nil );
//            break;
//        }
//        
//        if ( i + count >= TOTAL_PLAYERS ) {
//            curPlayer = i + count - TOTAL_PLAYERS;
//        }else {
//            curPlayer = i + count;
//        }
//        
//        if ( players[curPlayer].player_id != 0 ) {
//            break;
//        }
//        
//        curPlayer = 0;
//        
//        if ( i == TOTAL_PLAYERS - 1 ) {
//            i = -1;
//        }
//        
//        first = 0;
//    }
//    
//    NSLog( @"ViewController:setCurrentPlayer current player=%d", curPlayer );
//}

#pragma mark - selector

- (IBAction) start:(id)sender {
    [allPlayers closeCycle];
    
    [self gamingButton];
}

- (IBAction) fold:(id)sender {
    
}

- (IBAction) check:(id)sender {
    
}

- (IBAction) call:(id)sender {
    
}

- (IBAction) raise:(id)sender {
    
}

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

- (void) dealerChanged:(id)sender {
    NSLog( @"setDealr in" );
    
    dealNum = [sender selectedSegmentIndex]+1;

    NSLog( @"dealer num=%d", dealNum );
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:dealNum];
    NSLog( @"btn center.x=%f,y=%f", btn.center.x, btn.center.y );
    dealer.center = CGPointMake( btn.center.x, btn.center.y + 40.0f );
    
    [self setCurrentPlayer];
}

- (IBAction) sitDownBtnPressed:(id)sender {
    gameState = 1;
    
    [allPlayers openCycle];
    
    [self settingButton];
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:22];
    btn.hidden = NO;
    
    dealerCtrl.hidden = NO;
}

- (IBAction) playerBtnPressed:(id)sender {
    if ( gameState == 2 ) {
        return;
    }
    
    NSLog( @"setPlayer tag = %d", [sender tag] );
    
    playerNum = [sender tag];
    
//    setView.hidden = NO;
//    [self.view addSubview:_membController];

    [_seatView removeFromSuperview];
    [self.view insertSubview:_membController.view atIndex:0];
}


- (IBAction) completeBtnPressed:(id)sender {
    gameState = 2;
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:22];
    btn.hidden = YES;
    
    dealerCtrl.hidden = YES;
    
    [allPlayers closeCycle];
    
    startBtn.hidden = NO;
}

#pragma mark - delegate
- (void) cancelMemberView {
    [_membController.view removeFromSuperview];
    [self.view insertSubview:_seatView atIndex:0];
}

- (void) selectedPlayer:(NSString *)_name id:(int)_id {
    NSLog( @"ViewController:selectedPlayer in" );
    
    assert( _name );
    
    _PLAYER_INFO *p = (_PLAYER_INFO *)malloc(sizeof(_PLAYER_INFO));
    p->player_name = [_name copy];
    p->player_id = _id;
    p->seat_num = playerNum;
    p->next = nil;
    
    [allPlayers insertPlayer:p];
    
    UIButton *btn = (UIButton *)[_seatView viewWithTag:playerNum];
    [btn setTitle:_name forState:UIControlStateNormal];

}
@end
