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
    int player_state;   // 0 -- fold; 1 -- alive
    struct PLAYER_INFO *next;
}_PLAYER_INFO;

@interface Players : NSObject {
    _PLAYER_INFO    *listHead;
    _PLAYER_INFO    *listTail;
    
    int     count;
    int     aliveCount;
}
@property (nonatomic) int count;
@property (nonatomic) int aliveCount;

- (void) insertPlayer:(_PLAYER_INFO *)_player;
- (void) closeCycle;
- (void) openCycle;
- (int) currentPlayer:(int)_dealNum;
- (int) playerIDWithSeatNum:(int)_seatNum endPlayer:(int)_endSeatNum;
- (BOOL) isLastPlayer:(int)_seatNum;
- (int) endPlayerWithDealer:(int)_dealerNum;
- (int) nextPlayerWithCurrentPlayer:(int)_seatNum endPlayer:(int)_endSeatNum;
- (void) playerFold:(int)_seatNum;
- (int) nextDealerWithNum:(int)_dealerNum;
- (int) smallBlindWithNum:(int)_dealerNum;
- (int) playerWithDealer:(int)_dealerNum num:(int)_num;
@end
