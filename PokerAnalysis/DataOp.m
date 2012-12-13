//
//  DataOp.m
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-27.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import "DataOp.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "config.h"

@implementation DataOp

+ (NSString *)getFilePath:(NSString *)filename{
	NSArray *paths = [[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)];
	NSString *documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
	[paths release];
	[documentsDirectory release];
	return filepath;
}

+ (BOOL) createTable {
    NSString *doPath = [self getFilePath:DBFile];
    NSArray *tableListSql = [NSArray arrayWithObjects:C_T_INFO, C_T_DATA, C_T_PLAYER, nil];
    NSArray *tableList = [NSArray arrayWithObjects:T_INFO, T_DATA, T_PLAYER, nil];
    
    FMDatabase  *db = [FMDatabase databaseWithPath:doPath];
    if ([db open]) {
		[db setShouldCacheStatements:YES];
		for (int i = 0 ;i <[tableList count];i++) {
            NSString *checkTableSQL = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'",[tableList objectAtIndex:i]];
			NSLog(@"checktablke %@",checkTableSQL);
			FMResultSet *rs = [db executeQuery:checkTableSQL];
			if (![rs next])
            {
				NSLog(@"create table %@",[tableList objectAtIndex:i]);
                
                [db executeUpdate:[tableListSql objectAtIndex:i]];
			}
		}
	}
    
    [db close];
    
    return YES;
}

+ (NSMutableDictionary *) allPlayers {
    NSString *dbFilePath=[self getFilePath:DBFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
    if ( [db open] ) {
        [db setShouldCacheStatements:YES];
        NSMutableDictionary *players = [NSMutableDictionary dictionary];
        
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select player_id,player_name from %@", T_PLAYER]];
        while ( [rs next] ) {
//            [players :[rs stringForColumn:@"player_name"]];
            [players setObject:[rs stringForColumn:@"player_name"] forKey:[rs stringForColumn:@"player_id"]];
        }
        
        [rs close];
        [db close];
        
        return players;
    }else {
        NSLog( @"DataOp: could not open DB" );
        return nil;
    }
}

+ (BOOL) createPlayer:(NSString *)_name {
    assert( _name );
    
    NSString *dbFilePath = [self getFilePath:DBFile];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    if ( [db open] ) {
        [db setShouldCacheStatements:YES];

        [db beginTransaction];
        
        if ( [self isPlayerExisted:_name DB:db] ) {
            [db close];
            return FALSE;
        }
        
        [db executeUpdate:[NSString stringWithFormat:@"insert into t_player ('player_name') values('%@')",_name]];
		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			[db close];
			return NO;
		}
		
		[db commit];
		[db close];
		return YES;
    }else {
        NSLog( @"Could not open database" );
        return NO;
    }
}

+ (BOOL) isPlayerExisted:(NSString *)_name DB:(FMDatabase *)_db {
    assert( _name );
    
//    NSString *dbFilePath = [self getFilePath:DBFile];
//    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
//    if ( [db open] ) {
//        
//    }

    
    NSString *sql = [NSString stringWithFormat:@"select player_name from t_player"];
    
    FMResultSet *rs = [_db executeQuery:sql];
    int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
    while ([rs next]) {
//        NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<col; i++) {
            NSString *temp =[rs stringForColumnIndex:i];
//            if (temp == nil) {
//                [rsArray addObject:@""];
//            }
//            else {
//                [rsArray addObject:temp];
//            }
//            
            if ( [_name isEqualToString:temp] ) {
                [rs close];
                return YES;
            }
        }
        
        //[rsArray removeAllObjects];
    }
    
    [rs close];
    return NO;
}

+ (void) saveRecord:(NSMutableArray *)_process {
    assert( _process );
    
#ifdef DEBUG
    for ( int i = 0; i < [_process count]; i++) {
        NSLog( @"saveRecord process=%@, gameStage=%d", [_process objectAtIndex:i], i+1 );
    }
#endif
    
    NSString *p = nil;
    for ( int i = 0; i < RIVER; i++ ) {
        if ( i == 0 ) {
            p = [NSString stringWithFormat:@"'%@'", [_process objectAtIndex:i]];
        }else {
            if ( i < [_process count] ) {
                p = [NSString stringWithFormat:@"%@,'%@'", p, [_process objectAtIndex:i]];
            }else {
                p = [NSString stringWithFormat:@"%@,NULL", p];
            }
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert into t_data (preflop,postflop,turn,river) values(%@)", p];
    
#ifdef DEBUG
    NSLog( @"saveRecord p=%@", sql );
#endif
    
    NSString *dbFilePath = [self getFilePath:DBFile];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    if ( [db open] ) {
        [db setShouldCacheStatements:YES];
        
        [db beginTransaction];
        
        [db executeUpdate:sql];
		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			[db close];
			return;
		}
		
		[db commit];
		[db close];
		return;
    }else {
        NSLog( @"Could not open database" );
        return;
    }
    
}
@end
