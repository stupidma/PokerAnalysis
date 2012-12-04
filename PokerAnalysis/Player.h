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
    
    int         seatNum;
    int         position;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic) int seatNum;
@property (nonatomic) int position;

- (id) initWithName:(NSString *)_name seatNum:(int)_seatNum position:(int)_position;
@end
