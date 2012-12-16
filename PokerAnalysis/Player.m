//
//  Player.m
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-25.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize name;
@synthesize playerID;
@synthesize preflop;
@synthesize postflop;
@synthesize turn;
@synthesize river;


- (id) init {
    self = [super init];
    if ( self ) {
        self.preflop = [NSMutableDictionary dictionary];
        self.postflop = [NSMutableDictionary dictionary];
        self.turn = [NSMutableDictionary dictionary];
        self.river = [NSMutableDictionary dictionary];
    }
    
    return self;
}

@end
