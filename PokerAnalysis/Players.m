//
//  Players.m
//  PokerAnalysis
//
//  Created by He Tyrion on 12-12-7.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import "Players.h"
#import "config.h"

@implementation Players

@synthesize count;
@synthesize aliveCount;

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
    aliveCount++;
    
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

- (int) currentPlayer:(int)_dealNum {
    assert( _dealNum );
    assert( listHead );
    assert( listTail );
    
    _PLAYER_INFO *p = listHead;
    int tag = 1;
    while ( p ) {
        if ( p == listHead && tag == 0 ) {
            assert( nil );
            
            return 0;
        }
        
        if ( p->seat_num == _dealNum ) {
            break;
        }
        
        tag = 0;
        p = p->next;
    }
    
    for ( int i = 0; i < 3; i++ ) {
        p = p->next;
    }
    
    return p->seat_num;
}

- (int) playerIDWithSeatNum:(int)_seatNum endPlayer:(int)_endSeatNum {
    assert( _seatNum );
    assert( listHead );
    assert( listTail );
    
    _PLAYER_INFO *p = listHead;
    while ( p ) {
        if ( p->seat_num == _seatNum ) {
            break;
        }
        
        if ( p->seat_num == _endSeatNum ) {
            assert( nil );
            return 0;
        }
        
        p = p->next;
    }
    
    return p->player_id;
}

- (BOOL) isLastPlayer:(int)_seatNum {
    assert( _seatNum );
    assert( listHead );
    assert( listTail );
    
    return false;
}

- (int) endPlayerWithDealer:(int)_dealerNum {
    assert( _dealerNum );
    assert( listHead );
    assert( listTail );
    
    _PLAYER_INFO *p = listHead;
    // find dealer
    while ( p ) {
        if ( p->seat_num == _dealerNum ) {
            break;
        }
        
        if ( p == listTail ) {
            assert( nil );
            return 0;
        }
        
        p = p->next;
    }
    
    // find BB player
    for ( int i = 0; i < 2; i++ ) {
        assert( p->next );
        p = p->next;
    }
    
    return p->seat_num;
}

- (int) nextPlayerWithCurrentPlayer:(int)_seatNum endPlayer:(int)_endSeatNum {
    assert( _seatNum );
    assert( listHead );
    assert( listTail );

    _PLAYER_INFO *p = listHead;
    // find the current player
    while ( p ) {
        if ( p->seat_num == _seatNum ) {
            assert( p->next );
            p = p->next;
            break;
        }
        
        if ( p->seat_num == _endSeatNum ) {
            assert( nil );
            return 0;
        }
        
        p = p->next;
    }
    
    assert( p );
    
    // ignore dead player
    while ( p ) {
        assert( aliveCount >= 2 );
        
        if ( p->player_state == ALIVE ) {
            break;
        }
        
        p = p->next;
    }
    
    return p->seat_num;
}

- (void) playerFold:(int)_seatNum {
    assert( _seatNum );
    assert( listHead );
    assert( listTail );
    
    _PLAYER_INFO *p = listHead;
    while ( p ) {
        if ( p->seat_num == _seatNum ) {
            p->player_state = DEAD;
            break;
        }
    }
    
    assert( aliveCount > 0 );
    aliveCount--;
    
#ifdef DEBUG
    NSLog( @"Players:playerFold aliveCount=%d", aliveCount );
#endif
}

- (int) nextDealerWithNum:(int)_dealerNum {
    assert( _dealerNum );
    assert( listHead );
    assert( listTail );
    
    _PLAYER_INFO *p = listHead;
    int m = 1;
    while ( p ) {
        if ( p == listHead && m == 0 ) {
            assert( nil );
            return 0;
        }
        
        if ( p->seat_num == _dealerNum ) {
            assert( p->next );
            p = p->next;
            break;
        }
        
        assert( p->next );
        p = p->next;
        m = 0;
    }
    
    return p->seat_num;
}

- (int) smallBlindWithNum:(int)_dealerNum {
    assert( _dealerNum );
}

- (int) playerWithDealer:(int)_dealerNum num:(int)_num {
    assert( _dealerNum );
    assert( _num );
    assert( listHead );
    assert( listTail );
    
    _PLAYER_INFO *p = listHead;
    int m = 1;
    while ( p ) {
        if ( p == listHead && m == 0 ) {
            assert( nil );
            return 0;
        }
        
        if ( p->seat_num == _dealerNum ) {
            break;
        }
        
        assert( p->next );
        p = p->next;
        m = 0;
    }
    
    assert( _num < TOTAL_PLAYERS );
    
    for ( int i = 0; i < _num; i++ ) {
        assert( p->next );
        p = p->next;
    }
    
    return p->seat_num;
}
@end
