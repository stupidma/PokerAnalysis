//
//  MemberViewController.h
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-25.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberDelegate.h"

@interface MemberViewController : UITableViewController <UITextViewDelegate> {
    id<MemberDelegate>          delegate;
    IBOutlet UINavigationBar    *navBar;
    NSMutableDictionary                *player;
    
    IBOutlet UITextView         *nameView;
}
@property (nonatomic, assign) id<MemberDelegate> delegate;
@property (nonatomic, copy) NSMutableDictionary *players;

- (IBAction) addMember:(id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction) cancel:(id)sender;

- (void) createPlayer;
@end
