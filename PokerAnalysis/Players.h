//
//  Players.h
//  PokerAnalysis
//
//  Created by He Tyrion on 12-12-7.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct PLAYER_INFO {
    NSString *player_name;
    int seat_num;
    int player_id;
    struct PLAYER_INFO *next;
}_PLAYER_INFO;

@interface Players : NSObject {
    _PLAYER_INFO    *listHead;
    _PLAYER_INFO    *listTail;
    
    int     count;
}
@property (nonatomic) int count;

- (void) insertPlayer:(_PLAYER_INFO *)_player;
- (void) closeCycle;
- (void) openCycle;
@end
