//
//  MemberViewController.h
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-25.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberDelegate.h"

@class AnalysisViewController;

@interface MemberViewController : UITableViewController <UITextViewDelegate> {
    id<MemberDelegate>          delegate;
    IBOutlet UINavigationBar    *navBar;
    NSMutableDictionary                *player;
    
    IBOutlet UITextView         *nameView;
    IBOutlet UISegmentedControl *mebCtrl;
    
    int type;
    
    
}
@property (nonatomic, assign) id<MemberDelegate> delegate;
@property (nonatomic, copy) NSMutableDictionary *players;
@property (nonatomic, retain) AnalysisViewController *analysisCtrl;

- (IBAction) addMember:(id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction) cancel:(id)sender;

- (void) createPlayer;
- (void) playerSelected:(NSString *)_name playerID:(int)_id;
- (void) playerAnalysis:(NSString *)_name playerID:(int)_id;
@end
