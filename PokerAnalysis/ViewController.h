//
//  ViewController.h
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-21.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberDelegate.h"
#import "config.h"

@class RecordViewController;
@class AnalysisViewController;
@class MemberViewController;
@class Players;

@interface ViewController : UIViewController <MemberDelegate> {
//    RecordViewController    *reCtrl;
//    AnalysisViewController  *anCtrl;
//    MemberViewController    *mebCtrl;
    
    int gameState;
    int playerNum;
    int dealNum;
    int gameStage;
    int curPlayer;
    int endPlayerNum;
    int pot;
    
    NSMutableArray *procArray;
    NSString *process;
    
//    NSMutableArray  *players;

    UIColor     *btnFontColor;
//    MemberViewController *membController;
    
    IBOutlet UIImageView        *dealerImage;
    IBOutlet UISegmentedControl *dealerCtrl;
    IBOutlet UIButton           *startBtn;
    IBOutlet UIButton           *foldBtn;
    IBOutlet UIButton           *checkBtn;
    IBOutlet UIButton           *callBtn;
    IBOutlet UIButton           *raiseBtn;
    
    Players     *allPlayers;
}
@property (nonatomic, assign) id<MemberDelegate> delegate;
//@property (nonatomic, retain) NSMutableArray *players;
@property (nonatomic, retain) MemberViewController *membController;
@property (nonatomic, retain) IBOutlet UIView *seatView;

//@property (nonatomic, retain) RecordViewController *reCtrl;
//@property (nonatomic, retain) AnalysisViewController *anCtrl;
//@property (nonatomic, retain) MemberViewController *mebCtrl;

//- (IBAction) recorder:(id)sender;
//- (IBAction) member:(id)sender;
//- (IBAction) analysis:(id)sender;

- (IBAction) textFieldDoneEditing:(id)sender;
//- (IBAction) setDealer:(id)sender;

- (IBAction) fold:(id)sender;
- (IBAction) check:(id)sender;
- (IBAction) call:(id)sender;
- (IBAction) raise:(id)sender;
- (IBAction) start:(id)sender;

- (void) interfaceInit;
- (void) setCurrentPlayer;
- (void) settingButton;
- (void) gamingButton;
- (void) nextStage;
- (void) nextPlayer;
- (void) raiseNextPlayer;
- (void) resetStage;
- (void) saveProcess:(NSString *)_process;
@end
