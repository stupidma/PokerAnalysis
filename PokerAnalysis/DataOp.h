//
//  DataOp.h
//  PokerAnalysis
//
//  Created by He Tyrion on 12-11-27.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DBFile          @"Pa.db"

#define T_INFO          @"t_info"
#define C_T_INFO        @"create table t_info(table_name TEXT PRIMARY KEY,\
total_hands INTEGER,\
total_players INTEGER,\
total_pots INTEGER)"

#define T_DATA          @"t_data"
#define C_T_DATA        @"create table t_data(hand_id INTEGER PRIMARY KEY,\
preflop INTEGER,\
postflop INTEGER,\
turn, INTEGER,\
river INTEGER)"

#define T_PLAYER        @"t_player"
#define C_T_PLAYER      @"create table t_player(player_id INTEGER PRIMARY KEY,\
player_name TEXT,\
preflop_action INTEGER,\
postflop_action INTEGER,\
turn_action INTEGER,\
river_action INTEGER)"

@class FMDatabase;

@interface DataOp : NSObject

+ (BOOL) createTable;
+ (BOOL) insertData:(NSArray *)_data tableName:(NSString *)_name;
+ (NSArray *) queryData:(NSString *)_name colum:(NSString *)_colum columValue:(id)_columValue withAll:(BOOL)_bool;
+ (BOOL) updataData:(NSString *)_name colum:(NSString *)_colum columValue:(id)_columValue;
+ (BOOL) deleteData:(NSString *)_name colum:(NSString *)_colum columValue:(id)_columValue;
+ (NSMutableDictionary *) allPlayers;
+ (BOOL) createPlayer:(NSString *)_name;
+ (BOOL) isPlayerExisted:(NSString *)_name DB:(FMDatabase *)_db;
+ (void) saveRecord:(NSString *)_process step:(int)_gameStage;
@end
