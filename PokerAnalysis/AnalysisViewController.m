//
//  AnalysisViewController.m
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-25.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import "AnalysisViewController.h"
#import "DataOp.h"
#import "config.h"
#import "Player.h"

@interface AnalysisViewController ()

@end

@implementation AnalysisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    players = [[NSMutableDictionary dictionary] retain];
    
    [self analysis:[DataOp dataWithStage:PREFLOP] stage:PREFLOP];
    [self analysis:[DataOp dataWithStage:POSTFLOP] stage:POSTFLOP];
    [self analysis:[DataOp dataWithStage:TURN] stage:TURN];
    [self analysis:[DataOp dataWithStage:RIVER] stage:RIVER];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayWithPlayerName:(NSString *)_name playerID:(int)_id {
    assert( _name );
    assert( _id );
    
//    preCheck.text = [preflopData objectAtIndex:0];
}

- (void) analysis:(NSArray *)_data stage:(int)_stage{
    assert( _data );
    assert( _stage );
    
    for ( NSString *s in _data ) {
        const char *_s = [s cStringUsingEncoding:NSUTF8StringEncoding];
        assert( strlen(_s) > 5 );
        assert( (_s[0] - '0') == _stage );
        
        const char *_d = [self positionWithData:_s num:3];
        assert( _d );
        while ( _d ) {
            const char *playerID = [self nextData:_d];
            assert( playerID );
            
            _d = [self positionWithData:_d num:1];
            assert( _d );
            
            const char *playerAction = [self nextData:_d];
            assert( playerAction );
            
            _d = [self positionWithData:_d num:1];
            assert( _d );
            
            [self recordWithID:playerID action:playerAction stage:_stage];
        }
    }
}

- (void) recordWithID:(const char *)_id action:(const char *)_action stage:(int)_stage {
    assert( _id );
    assert( _action );
    assert( _stage );
    
    int playerID = atoi(_id);
    int playerAction = atoi(_action);
    
#ifdef DEBUG
    NSLog( @"AnalysisViewController playerID=%d, playerAction=%d", playerID, playerAction );
#endif
    
    Player *p = [players objectForKey:[NSNumber numberWithInt:playerID]];
    if ( p ) {
        switch ( _stage ) {
            case PREFLOP:
            {
                NSNumber *count = [p.preflop objectForKey:[NSNumber numberWithInt:playerAction]];
                if ( count ) {
                    [p.preflop setObject:[NSNumber numberWithInt:[count intValue]+1] forKey:[NSNumber numberWithInt:playerAction]];
                }else {
                    [p.preflop setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:playerAction]];
                }
            }
                break;
            case POSTFLOP:
            {
                NSNumber *count = [p.postflop objectForKey:[NSNumber numberWithInt:playerAction]];
                if ( count ) {
                    [p.postflop setObject:[NSNumber numberWithInt:[count intValue]+1] forKey:[NSNumber numberWithInt:playerAction]];
                }else {
                    [p.postflop setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:playerAction]];
                }
            }
                break;
            case TURN:
            {
                NSNumber *count = [p.turn objectForKey:[NSNumber numberWithInt:playerAction]];
                if ( count ) {
                    [p.turn setObject:[NSNumber numberWithInt:[count intValue]+1] forKey:[NSNumber numberWithInt:playerAction]];
                }else {
                    [p.turn setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:playerAction]];
                }
            }
                break;
            case RIVER:
            {
                NSNumber *count = [p.river objectForKey:[NSNumber numberWithInt:playerAction]];
                if ( count ) {
                    [p.river setObject:[NSNumber numberWithInt:[count intValue]+1] forKey:[NSNumber numberWithInt:playerAction]];
                }else {
                    [p.river setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:playerAction]];
                }
            }
                break;
            default:
                assert( nil );
                break;
        }
    }else {
        p = [[Player alloc] init];
        switch ( _stage ) {
            case PREFLOP:
                [p.preflop setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:playerAction]];
                break;
            case POSTFLOP:
                [p.postflop setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:playerAction]];
                break;
            case TURN:
                [p.turn setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:playerAction]];
                break;
            case RIVER:
                [p.river setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:playerAction]];
                break;
            default:
                assert( nil );
                break;
        }
    }
    
    free( _id );
    free( _action );
}

- (const char *) positionWithData:(const char *)_data num:(int)_num {
    assert(_data);
    assert( _num );
    
    const char *p = _data;
    int m = 0;
    for ( int i = 0; i < strlen(p); i++ ) {
        assert( m < _num );
        
        if ( p[i] == '|' ) {
            m++;
        }
        
        if ( m == _num ) {
            assert( p[i+1] );
            return &p[i+1];
        }
    }
    
    assert( nil );
    return nil;
}

- (const char *) nextData:(const char *)_data {
    assert( _data );
    
    char *s = (char *)malloc(sizeof(5));
    memset( s, 0, strlen(s) );
    
    for ( int i = 0; i < strlen(_data); i++ ) {
        if ( _data[i] != '|' ) {
            strncat( s, _data, 1 );
#ifdef DEBUG
            printf( "\nAnalysis:nextData s=%s\n", s );
#endif
        }else {
            break;
        }
    }
    
    return s;
}
@end
