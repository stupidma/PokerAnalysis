//
//  AnalysisViewController.h
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-25.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalysisViewController : UIViewController {
    IBOutlet UILabel    *name;
    IBOutlet UILabel    *hands;
    
    IBOutlet UILabel    *preCheck;
    IBOutlet UILabel    *preCall;
    IBOutlet UILabel    *preRaise;
    IBOutlet UILabel    *preFold;
    IBOutlet UILabel    *preReRaise;
    
    IBOutlet UILabel    *postCheck;
    IBOutlet UILabel    *postCall;
    IBOutlet UILabel    *postRaise;
    IBOutlet UILabel    *postFold;
    IBOutlet UILabel    *postReRaise;
    
    IBOutlet UILabel    *turnCheck;
    IBOutlet UILabel    *turnCall;
    IBOutlet UILabel    *turnRaise;
    IBOutlet UILabel    *turnFold;
    IBOutlet UILabel    *turnReRaise;
    
    IBOutlet UILabel    *riverCheck;
    IBOutlet UILabel    *riverCall;
    IBOutlet UILabel    *riverRaise;
    IBOutlet UILabel    *riverFold;
    IBOutlet UILabel    *riverReRaise;
}

- (void) displayWithPlayerName:(NSString *)_name playerID:(int)_id;
- (NSArray *) analysis:(NSArray *)_data;
@end
