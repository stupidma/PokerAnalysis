//
//  Players.m
//  PokerAnalysis
//
//  Created by He Tyrion on 12-12-7.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import "Players.h"

@implementation Players

@synthesize count;

- (void) insertPlayer:(_PLAYER_INFO *)_player {
    assert( _player );
    assert( _player->player_id );
    assert( _player->player_name );
    
    
    if ( count == 0 ) {
        listHead = _player;
        listTail = _player;
    }else {
        _PLAYER_INFO *pH = listHead;
        _PLAYER_INFO *pre = nil;
        while ( pH->next ) {
            if ( _player->player_id < pH->player_id ) {
                if ( pH == listHead ) {
                    listHead = _player;
                }else {
                    pre->next = _player;
                }
                
                _player->next = pH;
                
                break;
            }
            
            pH = pH->next;
    
        }
        
        assert( _player->player_id > pH->player_id );
    
        pH->next = _player;
        listTail = _player;
    }
    
    count++;
    
#ifdef DEBUG
    _PLAYER_INFO *p = listHead;
    while ( p ) {
        NSLog( @"player_id=%d|player_name=%@|seat_num=%d", p->player_id, p->player_name, p->seat_num );
        p = p->next;
    }
#endif
}

- (void) openCycle {
    if ( count == 0 ) {
        return;
    }
    
    listTail->next = nil;
}

- (void) closeCycle {
    if ( count == 0 ) {
        return;
    }
    
    listTail->next = listHead;
}
@end
