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
    pot = 0;
    
    procArray = [[NSMutableArray array] retain];
    
    btnFontColor = [[startBtn titleColorForState:UIControlStateNormal] retain];
    
    allPlayers = [[Players alloc] init];
    allPlayers.count = 0;
    allPlayers.aliveCount = 0;
    
    [DataOp createTable];
    
    _membController = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:nil];
    _membController.delegate = self;
    
    [self interfaceInit];
//    [self.view insertSubview:_seatView atIndex:0];
    [self.view addSubview:_seatView];
    NSLog(@"viewdid");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemorWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"memorywarning");
}

- (void) dealloc {
//    self.reCtrl = nil;
//    self.anCtrl = nil;
//    self.mebCtrl = nil;
//    _players = nil;
    [procArray release];
    
    _membController = nil;
    _seatView = nil;
    allPlayers = nil;
    btnFontColor = nil;
    
    [super dealloc];
}

- (void) setCurrentPlayer {
    if ( curPlayer != -1 ) {
        UIButton *preBtn = (UIButton *)[_seatView viewWithTag:curPlayer];
        [preBtn setTitleColor:btnFontColor forState:UIControlStateNormal];
    }
    
    assert( gameStage == PREFLOP );
    
    curPlayer = [allPlayers currentPlayer:dealNum];
    
    assert( curPlayer );
    
    NSLog( @"ViewController:setCurrentPlayer curPlayer num=%d", curPlayer );
    
    UIButton *btn = (UIButton *)[_seatView viewWithTag:curPlayer];
    [btn setTitleColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
}

- (void) settingButton {
    startBtn.hidden = YES;
    foldBtn.hidden = YES;
    checkBtn.hidden = YES;
    callBtn.hidden = YES;
    raiseBtn.hidden = YES;
    
//    UIButton *btn = (UIButton *)[_seatView viewWithTag:22];
//    btn.hidden = YES;
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
    
    dealerImage.hidden = NO;
    
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

- (void) nextPlayer {
    UIButton *btn = (UIButton *)[_seatView viewWithTag:curPlayer];
    [btn setTitleColor:btnFontColor forState:UIControlStateNormal];
    
    curPlayer = [allPlayers nextPlayerWithCurrentPlayer:curPlayer endPlayer:endPlayerNum];
    
    btn = (UIButton *)[_seatView viewWithTag:curPlayer];
    [btn setTitleColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
}

- (void) nextStage {
    assert( gameStage >= PREFLOP && gameStage <= RIVER );
    
    if ( gameStage == RIVER ) {
        [DataOp saveRecord:procArray];
        [self resetStage];
        return;
    }else {
        UIButton *btn = (UIButton *)[_seatView viewWithTag:curPlayer];
        [btn setTitleColor:btnFontColor forState:UIControlStateNormal];
        
        curPlayer = [allPlayers playerWithDealer:dealNum num:1];
        
        btn = (UIButton *)[_seatView viewWithTag:curPlayer];
        [btn setTitleColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        
        endPlayerNum = dealNum;
        gameStage++;
        
        assert( gameStage > PREFLOP && gameStage <= RIVER );
    }
    
    NSString *p = process;
    process = [[NSString alloc] initWithFormat:@"%d|%d|%d|", gameStage, pot, allPlayers.aliveCount];
    [p release];
}

- (void) resetStage {
    gameStage = PREFLOP;
    
    UIButton *btn = (UIButton *)[_seatView viewWithTag:curPlayer];
    [btn setTitleColor:btnFontColor forState:UIControlStateNormal];
    
    dealNum = [allPlayers playerWithDealer:dealNum num:1];
    curPlayer = [allPlayers currentPlayer:dealNum];
    endPlayerNum = [allPlayers endPlayerWithDealer:dealNum];
    [allPlayers resetPlayers];
    
    [procArray removeAllObjects];
    
    [process release];
    
    process = [[NSString alloc] initWithFormat:@"%d|0|%d|", gameStage, [allPlayers count]];
    
#ifdef DEBUG
    NSLog( @"ViewController:resetStage process=%@,dealNum=%d,curPlayer=%d,endPlayer=%d", process, dealNum, curPlayer, endPlayerNum );
#endif
    
    btn = (UIButton *)[_seatView viewWithTag:curPlayer];
    [btn setTitleColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
}

- (void) raiseNextPlayer {
    assert( gameStage >= PREFLOP && gameStage <= RIVER );
    
    UIButton *btn = (UIButton *)[_seatView viewWithTag:curPlayer];
    [btn setTitleColor:btnFontColor forState:UIControlStateNormal];

    endPlayerNum = [allPlayers endPlayerWithRaiser:curPlayer];
    curPlayer = [allPlayers nextPlayerWithCurrentPlayer:curPlayer endPlayer:endPlayerNum];
    
    btn = (UIButton *)[_seatView viewWithTag:curPlayer];
    [btn setTitleColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    
#ifdef DEBUG
    NSLog( @"ViewController:raiseNextPlayer curPlayer=%d, endPlayer=%d", curPlayer, endPlayerNum );
#endif
}

- (void)saveProcess:(NSString *)_process {
    [procArray insertObject:_process atIndex:gameStage-1];
}

#pragma mark - selector

- (IBAction) startBtnPress:(id)sender {
    [allPlayers closeCycle];
    
    [self gamingButton];
    [self setCurrentPlayer];
    
    process = [[NSString alloc] initWithFormat:@"%d|0|%d|", gameStage, [allPlayers count]];
    
    assert( gameStage == PREFLOP );
    
    endPlayerNum = [allPlayers endPlayerWithDealer:dealNum];
    
#ifdef DEBUG
    NSLog( @"dealerImage x=%f,y=%f.dealNum=%d, endNum=%d", dealerImage.center.x, dealerImage.center.y, dealNum, endPlayerNum );
#endif
    
}

- (IBAction) fold:(id)sender {
    int playerID = [allPlayers playerIDWithSeatNum:curPlayer endPlayer:endPlayerNum];
    
    NSString *p = process;
    
    process = [[NSString alloc] initWithFormat:@"%@%d|%d|", process, playerID, FOLD];
    
    [p release];
    
#ifdef DEBUG
    NSLog( @"fold process=%@", process );
#endif
    
    if ( curPlayer == endPlayerNum ) {
        [procArray insertObject:process atIndex:gameStage-1];
        if ( allPlayers.aliveCount == 2 ) {
            [DataOp saveRecord:procArray];
            [self resetStage];
        }else {
            [self nextStage];
        }
    
    }else {
        [allPlayers playerFold:curPlayer];
        if ( allPlayers.aliveCount == 1 ) {
            [procArray insertObject:process atIndex:gameStage-1];
            [DataOp saveRecord:procArray];
            [self resetStage];
        }else {
            [self nextPlayer];
        }
    }
}

- (IBAction) check:(id)sender {
    int playerID = [allPlayers playerIDWithSeatNum:curPlayer endPlayer:endPlayerNum];
    
    NSString *p = process;
    process = [[NSString alloc] initWithFormat:@"%@%d|%d|", process, playerID, CHECK];
    [p release];
    
#ifdef DEBUG
    NSLog( @"check process=%@", process );
#endif
    
    if ( curPlayer == endPlayerNum ) {
        [procArray insertObject:process atIndex:gameStage-1];
        [self nextStage];
    }else {
        [self nextPlayer];
    }
}

- (IBAction) call:(id)sender {
    int playerID = [allPlayers playerIDWithSeatNum:curPlayer endPlayer:endPlayerNum];

    NSString *p = process;
    process = [[NSString alloc] initWithFormat:@"%@%d|%d|", process, playerID, CALL];
    [p release];
    
#ifdef DEBUG
    NSLog( @"call process=%@", process );
#endif

    if ( curPlayer == endPlayerNum ) {
        [procArray insertObject:process atIndex:gameStage-1];
        [self nextStage];
    }else {
        [self nextPlayer];
    }

}

- (IBAction) raise:(id)sender {
    int playerID = [allPlayers playerIDWithSeatNum:curPlayer endPlayer:endPlayerNum];
    
    NSString *p = process;
    process = [[NSString alloc] initWithFormat:@"%@%d|%d|", process, playerID, RAISE];
    [p release];
    
    [self raiseNextPlayer];
    
#ifdef DEBUG
    NSLog( @"raise process=%@", process );
#endif
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
    
    UIButton *btn = (UIButton *)[_seatView viewWithTag:dealNum];
    
//    dealerImage.center = CGPointMake( btn.center.x, btn.center.y + 40.0f );
    
    [dealerImage setFrame:CGRectMake( btn.center.x, btn.center.y + 40.f, dealerImage.frame.size.width, dealerImage.frame.size.height )];
#ifdef DEBUG
    NSLog( @"dealerImage x=%f,y=%f", dealerImage.center.x, dealerImage.center.y );
#endif
//    [self setCurrentPlayer];
}

- (IBAction) sitDownBtnPressed:(id)sender {
    gameState = 1;
    
    [allPlayers openCycle];
    
    [self settingButton];
    
    UIButton *btn = (UIButton *)[_seatView viewWithTag:22];
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
    [self.view addSubview:_membController.view];
//    [self.view insertSubview:_membController.view atIndex:0];
}


- (IBAction) completeBtnPressed:(id)sender {
    gameState = 2;
    
    UIButton *btn = (UIButton *)[_seatView viewWithTag:22];
    btn.hidden = YES;
    
    dealerCtrl.hidden = YES;
    
    [allPlayers closeCycle];
    
    startBtn.hidden = NO;
}

#pragma mark - delegate
- (void) cancelMemberView {
    [_membController.view removeFromSuperview];
//    [self.view insertSubview:_seatView atIndex:0];
    [self.view addSubview:_seatView];
}

- (void) selectedPlayer:(NSString *)_name playerID:(int)_id {
    NSLog( @"ViewController:selectedPlayer in" );
    
    assert( _name );
    
    _PLAYER_INFO *p = (_PLAYER_INFO *)malloc(sizeof(_PLAYER_INFO));
    p->player_name = [_name copy];
    p->player_id = _id;
    p->seat_num = playerNum;
    p->player_state = ALIVE;
    p->next = nil;
    
    [allPlayers insertPlayer:p];
    
    UIButton *btn = (UIButton *)[_seatView viewWithTag:playerNum];
    [btn setTitle:_name forState:UIControlStateNormal];

}
@end
