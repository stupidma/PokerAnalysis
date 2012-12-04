//
//  ViewController.h
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-21.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberDelegate.h"

@class RecordViewController;
@class AnalysisViewController;
@class MemberViewController;

typedef struct PLAYER_INFO {
    NSString *player_name;
    int seat_num;
    int player_id;
}_PLAYER_INFO;

@interface ViewController : UIViewController <MemberDelegate> {
//    RecordViewController    *reCtrl;
//    AnalysisViewController  *anCtrl;
//    MemberViewController    *mebCtrl;
    
    int gameState;
    int playerNum;
    int dealNum;
    
    NSMutableArray  *players;
    
//    MemberViewController *membController;
}
@property (nonatomic, assign) id<MemberDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *players;
@property (nonatomic, retain) MemberViewController *membController;
@property (nonatomic, retain) IBOutlet UIView *seatView;

//@property (nonatomic, retain) RecordViewController *reCtrl;
//@property (nonatomic, retain) AnalysisViewController *anCtrl;
//@property (nonatomic, retain) MemberViewController *mebCtrl;

//- (IBAction) recorder:(id)sender;
//- (IBAction) member:(id)sender;
//- (IBAction) analysis:(id)sender;

- (IBAction) textFieldDoneEditing:(id)sender;
@end
