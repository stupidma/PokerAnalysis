//
//  Player.h
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-25.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SB      1
#define BB      2
#define UTG     3
#define MP      4
#define CO      5
#define BTN     6

@interface Player : NSObject {
    NSString    *name;
    
    int         playerID;

    NSMutableDictionary  *preflop;
    NSMutableDictionary  *postflop;
    NSMutableDictionary  *turn;
    NSMutableDictionary  *river;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableDictionary *preflop;
@property (nonatomic, retain) NSMutableDictionary *postflop;
@property (nonatomic, retain) NSMutableDictionary *turn;
@property (nonatomic, retain) NSMutableDictionary *river;
@property (nonatomic) int playerID;

- (id) init;

@end
